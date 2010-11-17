package OLAC::Aggregator;

use OLAC::DB;
use XML::DOM;

my %errmsg = 
    ( "badArgument" =>
      "The request includes illegal arguments, is missing required " .
      "arguments, include a repeated argument, or values for arguments " .
      "have an illegal syntax.",
      
      "badResumptionToken" =>
      "The value of the resumptionToken argument is invalid or expired.",

      "badVerb" =>
      "Value of the verb argument is not a legal OAI-PMH verb, the verb " .
      "argument is missing, or the verb argument is repeated.",
      
      "cannotDisseminateFormat" =>
      "The metadata format identified by the value given for the " .
      "metadataPrefix argument is not supported by the item or by the " .
      "repository.",

      "idDoesNotExist" =>
      "The value of the identifier argument is unknown or illegal in " .
      "this repository.",
      
      "noRecordsMatch" =>
      "The combination of the values of the from, until, set and " .
      "metadataPrefix arguments results in an empty list.",
      
      "noRecordsMatch_Query" =>
      "The supplied SQL query does not match any records.",
      
      "noMetadataFormats" => "There are no metadata formats available " .
      "for the specified item.",

      "noSetHierarchy" =>
      "The repository does not support sets."
    );

sub new {
    my ($class, $dbinfofile, $idxml) = @_;

    my $self = {};

    $self->{db} = new OLAC::ADB($dbinfofile);
    $self->{idxml} = $idxml;
    $self->{extdb} = $self->{db}->getExtDB;
    #$self->{tagpx} = $self->{db}->getTagPxDB;
    $self->{dctag} = $self->{db}->getDcTagDB;
    $self->{country} = $self->{db}->getCountryDB;
    $self->{lineage} = $self->{db}->getLanguageCodeLineages;
    my $citedir = `olacvar static/root`;
    chomp $citedir;
    $self->{citedir} = $citedir . '/cite';

    $self->{GetRecord} = \&serve_GetRecord;
    $self->{Identify} = \&serve_Identify;
    $self->{ListIdentifiers} = \&serve_ListIdentifiers;
    $self->{ListMetadataFormats} = \&serve_ListMetadataFormats;
    $self->{ListRecords} = \&serve_ListRecords;
    $self->{ListSets} = \&serve_ListSets;
    $self->{Query} = \&serve_Query;

    $self->{mdata_processors} = {
	olac         => [\&get_mdata_container_olac, \&get_mdata_olac],
	olac_display => [\&get_mdata_container_olac, \&get_mdata_olac_display],
	olac_dla     => [\&get_mdata_container_olacdla, \&get_mdata_olacdla],
	oai_dc       => [\&get_mdata_container_oaidc,\&get_mdata_oaidc]
    };
    bless $self, $class;
    return $self;
}

sub date_time {
    my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = gmtime(time);   
    return sprintf("%04d-%02d-%02dT%02d:%02d:%02dZ",
                   $year+1900, $mon+1, $mday, $hour, $min, $sec);
}

sub url_encode {
    my ($str) = @_;

    $str =~ s/%/%25/g;
    $str =~ s/\//%2F/g;
    $str =~ s/\?/%3F/g;
    $str =~ s/#/%23/g;
    $str =~ s/=/%3D/g;
    $str =~ s/&/%26/g;
    $str =~ s/:/%3A/g;
    $str =~ s/;/%3B/g;
    $str =~ s/ /%20/g;
    $str =~ s/\+/%2B/g;

    return $str;
}

sub serve_request {
    my ($self, $request) = @_;

    if ($request->{resumptionToken}) {
        my %reqcopy = %$request;
	delete $reqcopy{baseURL};
	delete $reqcopy{verb};
	delete $reqcopy{resumptionToken};
	if (%reqcopy) {
	    return create_error("badArgument", $request);
	}
	my $token = $request->{resumptionToken};
	unless (open(RESUME, "</tmp/$token")) {
	    return create_error("badResumptionToken", $request);
	}

	# restore previous request
	$request = { resumptionToken => 1 };
	while (my $key = <RESUME>) {
	    my $val = <RESUME>;
	    chomp $key;
	    chomp $val;
	    $request->{$key} = $val;
	}
	close(RESUME);
	unlink "/tmp/$token";
    }

    unless ($self->{$request->{verb}}) {
        return create_error("badVerb");
    }

    my $dom = $self->{$request->{verb}}->($self, $request);

    if ($request->{next}) {
	my $token = "olac:" . time();
	unless (open(RESUME, ">/tmp/$token")) {
	    $request->{error} = "server error";
	    return undef;
	}

	foreach my $key (keys %$request) {
	    print RESUME "$key\n";
	    print RESUME "$request->{$key}\n";
	}
	close(RESUME);

	my $rt;
	if ($request->{verb} eq "Query") {
	    $rt = $dom->getElementsByTagName("ListRecords")->item(0)
		->appendChild($dom->createElement("resumptionToken"));
	}
	else {
	    $rt = $dom->getElementsByTagName($request->{verb})->item(0)
		->appendChild($dom->createElement("resumptionToken"));
	}
	$rt->addText($token);
    }
    return $dom;
}

sub get_template {
    my ($request) = @_;
    my ($doc, $OAI_PMH, $responseDate, $req_elem, $core);
    my $corename = $request->{verb};
    unless ($corename) {
	$corename = "unknown";
    }

    $doc = new XML::DOM::Document;
    $doc->setXMLDecl($doc->createXMLDecl("1.0","UTF-8"));
    
    $OAI_PMH = $doc->appendChild($doc->createElement("OAI-PMH"));
    $responseDate = $OAI_PMH->appendChild($doc->createElement("responseDate"));
    $req_elem = $OAI_PMH->appendChild($doc->createElement("request"));
    $core = $OAI_PMH->appendChild($doc->createElement($corename));

    $OAI_PMH->setAttribute("xmlns",
			   "http://www.openarchives.org/OAI/2.0/");
    $OAI_PMH->setAttribute("xmlns:xsi",
			   "http://www.w3.org/2001/XMLSchema-instance");
    $OAI_PMH->setAttribute("xsi:schemaLocation",
			   "http://www.openarchives.org/OAI/2.0/ " .
			   "http://www.openarchives.org/OAI/2.0/OAI-PMH.xsd");
    $responseDate->addText(date_time());
    set_request($req_elem, $request);

    return ($doc, $core);
}

sub get_template2 {
    my ($request) = @_;
    my ($doc, $OAI_PMH, $responseDate, $req_elem);

    $doc = new XML::DOM::Document;
    $doc->setXMLDecl($doc->createXMLDecl("1.0","UTF-8"));
    
    $OAI_PMH = $doc->appendChild($doc->createElement("OAI-PMH"));
    $responseDate = $OAI_PMH->appendChild($doc->createElement("responseDate"));
    $req_elem = $OAI_PMH->appendChild($doc->createElement("request"));

    $OAI_PMH->setAttribute("xmlns",
			   "http://www.openarchives.org/OAI/2.0/");
    $OAI_PMH->setAttribute("xmlns:xsi",
			   "http://www.w3.org/2001/XMLSchema-instance");
    $OAI_PMH->setAttribute("xsi:schemaLocation",
			   "http://www.openarchives.org/OAI/2.0/ " .
			   "http://www.openarchives.org/OAI/2.0/OAI-PMH.xsd");
    $responseDate->addText(date_time());
    set_request($req_elem, $request);

    return ($doc, $OAI_PMH);
}

sub create_error {
    my ($err_code, $request) = @_;
    my ($doc, $error) = get_template($request);

    $error->setTagName("error");
    $error->setAttribute("code", $err_code);
    $error->addText($errmsg{$err_code});

    return $doc;
}

sub create_error2 {
    my ($err_code_list, $request) = @_;
    my ($doc, $OAI_PMH) = get_template2($request);
    my $error, $err_code;

    my %dup = ();
    foreach $err_code (@$err_code_list) {
	if ($dup{$err_code}) {
	    next;
	} else {
	    $dup{$err_code} = 1;
	}
	$error = $OAI_PMH->appendChild($doc->createElement("error"));
	$error->setAttribute("code", $err_code);
	$error->addText($errmsg{$err_code});
    }
    return $doc;
}

sub is_identifier_okay {
    if ($_[0] =~ 'oai:[a-zA-Z][a-zA-Z0-9\-]*(\.[a-zA-Z][a-zA-Z0-9\-]+)+:[a-zA-Z0-9\-_\.!~\*&apos;\(\);/\?:@&amp;=\+$,%]+') {
	return 1;
    } else {
	return 0;
    }
}

sub set_request {
    my ($e, $request) = @_;

    my @atts = ("verb","identifier","metadataPrefix","from","until","set",
		# for Query verb (this breaks compatibility)
		"elements", "count", "sql");
    my ($att, $val);

    $val = $request->{resumptionToken};
    if ($val) {
	$e->setAttribute("resumptionToken", url_encode($val));
    }
    else {
	foreach $att (@atts) {
	    $val = $request->{$att};
	    if ($val) {
		$e->setAttribute($att, url_encode($val));
	    }
	}
    }

    $e->addText($request->{baseURL});
}

sub set_oai_atts {
    my ($e, $request) = @_;
    my $prefix = "http://www.openarchives.org/OAI/1.1/OAI_";
    my $verb = $request->{verb};
    if ($verb eq "Query") {
	$verb = "ListRecords";
    }
    my $xmlns =	"$prefix$verb";
    my $schema = "$prefix$verb.xsd";

    $e->setAttribute("xmlns", $xmlns);
    $e->setAttribute("xmlns:xsi", "http://www.w3.org/2001/XMLSchema-instance");
    $e->setAttribute("xsi:schemaLocation", "$xmlns $schema");
}

sub set_olac_atts {
    my ($e) = @_;
    my @px = ("xmlns:dc",
	      "xmlns:dcterms",
	      "xmlns:olac");
    my @ns = ("http://purl.org/dc/elements/1.1/",
	      "http://purl.org/dc/terms/",
	      "http://www.language-archives.org/OLAC/1.1/");
    my $schemaLoc = "
http://purl.org/dc/elements/1.1/
http://www.language-archives.org/OLAC/1.1/dc.xsd
http://purl.org/dc/terms/
http://www.language-archives.org/OLAC/1.1/dcterms.xsd
http://www.language-archives.org/OLAC/1.1/
http://www.language-archives.org/OLAC/1.1/olac.xsd
";

    foreach my $i (0..2) {
	$e->setAttribute($px[$i], $ns[$i]);
    }
    $e->setAttribute("xsi:schemaLocation", $schemaLoc);
}

sub set_oaidc_atts {
    my ($e) = @_;
    my @px = ("xmlns:dc",
	      "xmlns:oai_dc");
    my @ns = ("http://purl.org/dc/elements/1.1/",
	      "http://www.openarchives.org/OAI/2.0/oai_dc/");
    my $schemaLoc = "
http://purl.org/dc/elements/1.1/
http://www.language-archives.org/OLAC/1.1/dc.xsd
http://www.openarchives.org/OAI/2.0/oai_dc/
http://www.openarchives.org/OAI/2.0/oai_dc.xsd
";

    foreach my $i (0..1) {
	$e->setAttribute($px[$i], $ns[$i]);
    }
    $e->setAttribute("xsi:schemaLocation", $schemaLoc);
}

##### serve_GetRecord
# input:
#   - oai request
# output:
#   - reference to an XML::DOM::Element object conforming to
#     http://www.openarchives.org/OAI/1.1/OAI_GetRecord
#   - undef on errors
# description:
#   serves GetRecord request
#   this func knows about olac database
##
sub serve_GetRecord {
    my ($self, $request) = @_;

    my @err_code_list = ();
    unless ($request->{identifier} && $request->{metadataPrefix}) {
        push @err_code_list, "badArgument";
    }
    if (exists $request->{identifier}) {
	unless ($request->{identifier} =~ 'oai:[a-zA-Z][a-zA-Z0-9\-]*(\.[a-zA-Z][a-zA-Z0-9\-]+)+:[a-zA-Z0-9\-_\.!~\*&apos;\(\);/\?:@&amp;=\+$,%]+') {
            push @err_code_list, "badArgument";
        }
    } else {
	push @err_code_list, "badArgument";
    }
    if ($request->{metadataPrefix}) {
	unless ($request->{metadataPrefix} eq "olac" ||
		$request->{metadataPrefix} eq "olac_display" ||
		$request->{metadataPrefix} eq "olac_dla" ||
		$request->{metadataPrefix} eq "oai_dc") {
	    return create_error("cannotDisseminateFormat", $request);
	}
    } else {
	push @err_code_list, "badArgument";
    }
    my %reqcopy = %$request;
    delete $reqcopy{baseURL};
    delete $reqcopy{verb};
    delete $reqcopy{identifier};
    delete $reqcopy{metadataPrefix};
    if (%reqcopy) {
	push @err_code_list, "badArgument";
    }
    if (@err_code_list) {
	return create_error2(\@err_code_list, $request);
    }

    my ($head, $meta) = $self->{db}->getTable($request);

    # tag lang content ext_id code
    # --- ---- ------- ------ ----
    #  0    1     2       3     4
    #

    unless ($head) {
	return create_error("idDoesNotExist", $request);
    }

    # GetRecord {
    #   record {
    #     header [status] {
    #       identifier
    #       datestamp
    #     }
    #     metadata? {
    #       olac
    #     }
    #   }
    # }
    my ($doc, $gr, $r, $h, $i, $d, $m, $o, $me);

    # build skeleton
    ($doc, $gr) = get_template($request);

    $r = $gr->appendChild($doc->createElement("record"));
    $h = $r->appendChild($doc->createElement("header"));
    $i = $h->appendChild($doc->createElement("identifier"));
    $d = $h->appendChild($doc->createElement("datestamp"));
    $i->addText(trim($head->[0]));
    $d->addText($head->[1]);

    my ($get_container, $get_metadata) =
	@{$self->{mdata_processors}{$request->{metadataPrefix}}};

    $m = $r->appendChild($doc->createElement("metadata"));
    $o = $m->appendChild($get_container->($doc));
    for my $metadata_element (@{ $get_metadata->($self, $doc, $meta) }) {
	$o->appendChild($metadata_element);
    }

    # check: we don't harvest 'about' elem. it that ok?
    # check: we don't harvest 'status' att of 'record' elem. ok?

    return $doc;
}

##### serve_Identify
# input:
#   - archive id ('Archive_ID' of olac db)
# output:
#   - reference to an XML::DOM::Element object conforming to
#     http://www.openarchives.org/OAI/1.1/OAI_Identify
#   - undef on errors
# description:
#   serves Identify request
#   this function knows about olac database
## 
sub serve_Identify {
    my ($self, $request) = @_;
    my $doc = XML::DOM::Parser->new->parsefile($self->{idxml});

    # OAI-PMH/reponseDate
    $doc->getElementsByTagName("responseDate")->item(0)->addText(&date_time);

    # OAI-PMH/request
    set_request($doc->getElementsByTagName("request")->item(0), $request);

    # OAI-PMH/Identify/baseURL
    $doc->getElementsByTagName("baseURL")->item(0)->
	addText($request->{baseURL});

    # OAI-PMH/Identify/earliestDatestamp
    $doc->getElementsByTagName("earliestDatestamp")->item(0)->
	addText($self->{db}->get_earliestDatestamp());

    $doc->getElementsByTagName("olac-archive")->item(0)->
	setAttribute("currentAsOf", $self->{db}->get_currentAsOfDatestamp());

    return $doc;
}


sub serve_ListIdentifiers {
    my ($self, $request) = @_;

    my ($doc, $li, $h, $i, $d);
    # ListIdentifiers {
    #   header {
    #     identifier+
    #     datestamp
    #   }
    #   resumptionToken?
    # }

    my @error_code_list = ();
    unless (exists $request->{metadataPrefix}) {
	push @error_code_list, "badArgument";
    }
    if (exists $request->{from}) {
	unless ($request->{from} =~ /^\d{4}-\d{2}-\d{2}$/) {
	    push @error_code_list, "badArgument";
	}
    }
    if (exists $request->{until}) {
	unless ($request->{until} =~ /^\d{4}-\d{2}-\d{2}$/) {
	    push @error_code_list, "badArgument";
	}
    }
    if ((not exists $request->{metadataPrefix}) ||
	($request->{metadataPrefix} ne "olac" &&
	 $request->{metadataPrefix} ne "olac_display" &&
	 $request->{metadataPrefix} ne "olac_dla" &&
	 $request->{metadataPrefix} ne "oai_dc")) {
	push @error_code_list, "cannotDisseminateFormat";
    }
    if (exists $request->{set}) {
	push @error_code_list, "noSetHierarchy";
    }
    if (@error_code_list) {
	return create_error2(\@error_code_list, $request);
    }

    my $list = $self->{db}->getTable($request);
    # identifier dateStamp
    # ---------- ---------
    #     .....

    unless (@$list) {
	return create_error("noRecordsMatch", $request);
    }

    ($doc, $li) = get_template($request);

    foreach $row (@$list) {
	$h = $li->appendChild($doc->createElement("header"));
        $i = $h->appendChild($doc->createElement("identifier"));
        $d = $h->appendChild($doc->createElement("datestamp"));
	$i->addText(trim($row->[0]));
        $d->addText($row->[1]);
    }

    return $doc;
}

sub serve_ListMetadataFormats {
    my ($self, $request) = @_;

    if (exists $request->{identifier} && !$self->{db}->getTable($request)) {
	return create_error("idDoesNotExist", $request);
    }
	
    # ListMetadataFormats {
    #   metadataFormat+ {
    #     metadataPrefix
    #     schema
    #     metadataNamespace
    #   }
    # }

    my ($doc, $lmf, $mf, $mp, $s, $mn, $text);

    ($doc, $lmf) = get_template($request);

    $mf = $lmf->appendChild($doc->createElement("metadataFormat"));
    $mp = $mf->appendChild($doc->createElement("metadataPrefix"));
    $mp->addText("olac");
    $s = $mf->appendChild($doc->createElement("schema"));
    $s->addText("http://www.language-archives.org/OLAC/1.1/olac.xsd");
    $mn = $mf->appendChild($doc->createElement("metadataNamespace"));
    $mn->addText("http://www.language-archives.org/OLAC/1.1/");

    $mf = $lmf->appendChild($doc->createElement("metadataFormat"));
    $mp = $mf->appendChild($doc->createElement("metadataPrefix"));
    $mp->addText("olac_display");
    $s = $mf->appendChild($doc->createElement("schema"));
    $s->addText("http://www.language-archives.org/OLAC/1.1/olac.xsd");
    $mn = $mf->appendChild($doc->createElement("metadataNamespace"));
    $mn->addText("http://www.language-archives.org/OLAC/1.1/");

    $mf = $lmf->appendChild($doc->createElement("metadataFormat"));
    $mp = $mf->appendChild($doc->createElement("metadataPrefix"));
    $mp->addText("olac_dla");
    $s = $mf->appendChild($doc->createElement("schema"));
    $s->addText("http://www.language-archives.org/OLAC/1.1/olac.xsd");
    $mn = $mf->appendChild($doc->createElement("metadataNamespace"));
    $mn->addText("http://www.language-archives.org/OLAC/1.1/");

    $mf = $lmf->appendChild($doc->createElement("metadataFormat"));
    $mp = $mf->appendChild($doc->createElement("metadataPrefix"));
    $mp->addText("oai_dc");
    $s = $mf->appendChild($doc->createElement("schema"));
    $s->addText("http://www.openarchives.org/OAI/2.0/oai_dc.xsd");
    $mn = $mf->appendChild($doc->createElement("metadataNamespace"));
    $mn->addText("http://www.openarchives.org/OAI/2.0/oai_dc/");

    return $doc;
}

sub serve_ListRecords {
    my ($self, $request) = @_;

    my @error_code_list = ();
    unless (exists $request->{metadataPrefix}) {
	push @error_code_list, "badArgument";
    }
    if (exists $request->{from}) {
	unless ($request->{from} =~ /^\d{4}-\d{2}-\d{2}$/) {
	    push @error_code_list, "badArgument";
	}
    }
    if (exists $request->{until}) {
	unless ($request->{until} =~ /^\d{4}-\d{2}-\d{2}$/) {
	    push @error_code_list, "badArgument";
	}
    }
    if ((not exists $request->{metadataPrefix}) ||
	($request->{metadataPrefix} ne "olac" &&
	 $request->{metadataPrefix} ne "olac_display" &&
	 $request->{metadataPrefix} ne "olac_dla" &&
	 $request->{metadataPrefix} ne "oai_dc")) {
	push @error_code_list, "cannotDisseminateFormat";
    }
    if (exists $request->{set}) {
	push @error_code_list, "noSetHierarchy";
    }
    if (@error_code_list) {
	return create_error2(\@error_code_list, $request);
    }

    # ListRecords {
    #   record+ {
    #     header {
    #       identifier
    #       datestamp
    #     }
    #     metadata? {
    #       olac
    #     }
    #   }
    #   resumptionToken?
    # }

    my ($doc, $lr, $r, $h, $i, $d, $m, $o, $me);

    my ($head, $meta) = $self->{db}->getTable($request);
    # $head
    # identifier dateStamp Item_ID
    # ---------- --------- -------
    #      ....      ....      ..
    #       ...      ....      ..
    #
    # $meta
    # tag lang content ext_id code ext_lbl code_lbl Item_ID
    # --- ---- ------- ------ ---- ------- -------- -------
    #  0    1     2       3     4     5        6       7
    #

    unless (scalar(@$head)) {
	return create_error("noRecordsMatch", $request);
    }

    ($doc, $lr) = get_template($request);

    my ($get_container, $get_metadata) =
	@{$self->{mdata_processors}{$request->{metadataPrefix}}};

    my $mcount = 0;
    foreach $item (@$head) {

	$r = $lr->appendChild($doc->createElement("record"));
	$h = $r->appendChild($doc->createElement("header"));
	$i = $h->appendChild($doc->createElement("identifier"));
	$i->addText(trim($item->[0]));
	$d = $h->appendChild($doc->createElement("datestamp"));
	$d->addText($item->[1]);

	$m = $r->appendChild($doc->createElement("metadata"));
	$o = $m->appendChild($get_container->($doc));

	$metadata = [];
	while ($mcount < scalar(@$meta) and
	       $meta->[$mcount]->[7] eq $item->[2]) {
	    push(@$metadata, $meta->[$mcount++]);
	}
	for my $metadata_element (@{ $get_metadata->($self, $doc, $metadata) }) {
	    $o->appendChild($metadata_element);
	}
    }
    
    return $doc;
}

sub serve_ListSets {
    my ($self, $request) = @_;

    # ListSets {
    #   set+ {
    #     setSpec
    #     setName
    #   }
    #   resumptionToken?
    # }

    return create_error("noSetHierarchy", $request);
}

sub serve_Query {
    my ($self, $request) = @_;

    if (not exists $request->{elements} || $request->{elements} =~ /[^0-9]+/) {
        return create_error("badArgument", $request);
    }

    # ListRecords {
    #   record+ {
    #     header {
    #       identifier
    #       datestamp
    #     }
    #     metadata? {
    #       olac
    #     }
    #   }
    #   resumptionToken?
    # }

    my ($doc, $lr, $r, $h, $i, $d, $m, $o, $me);

    my ($head, $meta) = $self->{db}->getTable($request);
    if ($head eq undef && $meta eq undef) {
        return create_error("badArgument",  $request);
    }
    # $head
    # identifier dateStamp Item_ID
    # ---------- --------- -------
    #      ....      ....     ....
    #       ...      ....     ....
    #
    # $meta
    # tag lang content ext_id code ext_lbl code_lbl
    # --- ---- ------- ------ ---- ------- --------
    #  0    1     2       3     4     5        6
    #

    unless (scalar(@$head)) {
	return create_error("noRecordsMatch_Query", $request);
    }

    ($doc, $lr) = get_template($request);
    $lr->setTagName("ListRecords");
    $request->{metadataPrefix} = "olac";

    my ($get_container, $get_metadata) =
	@{$self->{mdata_processors}{$request->{metadataPrefix}}};

    foreach $item (@$head) {

	$r = $lr->appendChild($doc->createElement("record"));
	$h = $r->appendChild($doc->createElement("header"));
	$i = $h->appendChild($doc->createElement("identifier"));
	$i->addText(trim($item->[0]));
	$d = $h->appendChild($doc->createElement("datestamp"));
	$d->addText($item->[1]);

	$m = $r->appendChild($doc->createElement("metadata"));
	$o = $m->appendChild($get_container->($doc));

	my $mdata = shift @$meta;
	for my $metadata_element (@{ $get_metadata->($self, $doc, $mdata) }) {
	    $o->appendChild($metadata_element);
	}
    }

    delete $request->{metadataPrefix};
    return $doc;
}

sub get_mdata_container_olac {
    my $doc = shift;
    my $c = $doc->createElement("olac:olac");
    set_olac_atts($c);
    return $c;
}

sub get_mdata_container_olacdla {
    my $doc = shift;
    my $c = $doc->createElement("doc");
    return $c;
}

sub get_mdata_container_oaidc {
    my $doc = shift;
    my $c = $doc->createElement("oai_dc:dc");
    set_oaidc_atts($c);
    return $c;
}

sub same_olac_element {
    my ($elem1, $elem2) = @_;
    if (($elem1->getTagName eq $elem2->getTagName)) {
	if ($elem1->getFirstChild && $elem2->getFirstChild) {
	    if (($elem1->getFirstChild->getNodeValue eq $elem2->getFirstChild->getNodeValue) &&
		($elem1->getAttribute('xsi:type') eq $elem2->getAttribute('xsi:type')) &&
		($elem1->getAttribute('olac:code') eq $elem2->getAttribute('olac:code'))) {
		return 1;
	    }
	}
    }
    return 0;
}

sub same_dc_element {
    my ($elem1, $elem2) = @_;
    if (($elem1->getTagName eq $elem2->getTagName)) {
	if ($elem1->getFirstChild && $elem2->getFirstChild) {
	    if (($elem1->getFirstChild->getNodeValue eq $elem2->getFirstChild->getNodeValue)) {
		return 1;
	    }
	}
    }
    return 0;
}


sub add_olac_element {
    my ($list, $element) = @_;
    my @iden = grep {same_olac_element($element, $_)} @$list;
    if (scalar(@iden) == 0) {
	push @$list, $element;
    }
}


sub add_dc_element {
    my ($list, $element) = @_;
    my @iden = grep same_dc_element($element, $_), @$list;
    if (scalar(@iden) == 0) {
	push @$list, $element;
    }
}


sub set_text {
    my ($me, $text) = @_;
    for my $kid ($me->getChildNodes()) {
	$me->removeChild($kid);
    }
    $me->addText($text);
}


sub get_text {
    my $me = shift;
    if ($me->getFirstChild) {
	return $me->getFirstChild->getNodeValue;
    }
}

sub my_push {
    my ($arr, $me, $h) = @_;
    my $s = $me->toString;
    if (! exists $h->{$s}) {
	push @$arr, $me;
	$h->{$s} = 1;
    }
}

sub get_mdata_olac {
    my ($self, $doc, $tab) = @_;
    # $row : 0=tag, 1=lang, 2=content, 3=ext_id, 4=code
    my $elements = [];
    my $h = {};
    for my $row (@$tab) {
	my $tag = $row->[0];
	my $dctag = $self->{dctag}{$tag};
	my $me;
	if ($tag eq $dctag) {
	    $me = $doc->createElement("dc:$tag");
	} else {
	    $me = $doc->createElement("dcterms:$tag");
	}
	$row->[1] && $me->setAttribute('xml:lang', $row->[1]);
	$row->[2] && $me->addText($row->[2]);
	my ($ns,$tt) = @{$self->{extdb}{$row->[3]}};
	if ($ns eq 'http://www.language-archives.org/OLAC/1.0/' ||
	    $ns eq 'http://www.language-archives.org/OLAC/1.1/') {
	    $me->setAttribute('xsi:type', "olac:$tt");
	    $row->[4] && $me->setAttribute('olac:code', $row->[4]);
	}
	elsif ($ns eq 'http://purl.org/dc/terms/') {
	    $me->setAttribute('xsi:type', "dcterms:$tt");
	}
	my_push $elements, $me, $h;
    }
    return $elements;
}


sub make_element {
    my ($self, $doc, $tag, $content, $extid, $code) = @_;
    my $dctag = $self->{dctag}{$tag};
    my $me;
    if ($tag eq $dctag) {
	$me = $doc->createElement("dc:$tag");
    } else {
	$me = $doc->createElement("dcterms:$tag");
    }
    $content && $me->addText($content);
    my ($ns, $tt) = @{$self->{extdb}{$extid}};
    if ($ns eq 'http://www.language-archives.org/OLAC/1.0/' ||
	$ns eq 'http://www.language-archives.org/OLAC/1.1/') {
	$me->setAttribute('xsi:type', "olac:$tt");
	$code && $code ne null && $me->setAttribute('olac:code', $code);
    }
    elsif ($ns eq 'http://purl.org/dc/terms/') {
	$me->setAttribute('xsi:type', "dcterms:$tt");
    }
    return $me;
}

sub get_mdata_olac_display {
    my ($self, $doc, $tab) = @_;
    # $row : 0=tag,     1=lang,     2=content, 3=ext_id, 4=code,
    #        5=ext_lbl, 6=code_lbl
    my $elements = [];

    for my $row (@$tab) {
	
	my $tag = $row->[0];
	my $ext = $row->[5];
	my $extid = $row->[3];
	my $code = $row->[4];
	my $content = $row->[2];

	if (($tag eq "type") && ($ext eq "discourse-type")) {
	    # move the olac:code value to the element content
	    # discard any content that may have been there
	    if ($code) {
		$me = make_element($self, $doc, $tag, $code, $extid, null);
		add_olac_element($elements, $me);
	    }
	}
	elsif (($tag eq "type") && ($ext eq "linguistic-type")) {
	    # move the olac:code value to the element content
	    # discard any content that may have been there
	    if ($code) {
		$me = make_element($self, $doc, $tag, $code, $extid, null);
		add_olac_element($elements, $me);
	    }
	}
	elsif (($tag eq "subject") && ($ext eq "linguistic-field")) {
	    # move the olac:code value to the element content
	    # discard any content that may have been there
	    if ($code) {
		$me = make_element($self, $doc, $tag, $code, $extid, null);
		add_olac_element($elements, $me);
	    }
	    # drop xml:lang (nothing to do here since we don't harvest this)

	    # if there was original element content, generate <subject> element
	    # with that original content and no attributes except xml:lang
	    if ($content) {
		$me = make_element($self, $doc, $tag, $content, null, null);
		add_olac_element($elements, $me);
	    }
	}
	elsif (($tag eq "subject") && ($ext eq "language")) {
	    # move the olac:code value to the element content
	    # discard any content that may have been there
	    if ($code) {
		$me = make_element($self, $doc, $tag, $code, $extid, null);
		add_olac_element($elements, $me);
	    }

	    # drop xml:lang (nothing to do here since we don't harvest this)

	    # generate <subject> with the corresponding language name as content
	    # and no attributes; append 'language' unless the name of the
	    # language already contains the word
	    my $lang_name = $row->[6];
	    if ($lang_name) {
		my $me1 = $doc->createElement("dc:$tag");
		if ($lang_name !~ /language/i) {
		    $lang_name .= " language";
		}
		$me = make_element($self, $doc, $tag, $lang_name, null, null);
		add_olac_element($elements, $me);
	    }

	    # if there was original element content, generate <subject> with
	    # that original content and no attributes except xml:lang
	    # this should only be done where the content is different from
	    # the language name
	    if ($content && $content ne $row->[6]) {
		$me = make_element($self, $doc, $tag, $content, null, null);
		add_olac_element($elements, $me);
	    }
	}
	elsif (($tag eq "language") && ($ext eq "language")) {
	    # move the olac:code value to the element content
	    # discard any content that may have been there
	    if ($code) {
		$me = make_element($self, $doc, $tag, $code, $extid, null);
		add_olac_element($elements, $me);
	    }
	    
	    # if the element has contents, generate a <language> element with
	    # that content; if the content does not already contain the
	    # standard name associated with the code anywhere in the string
	    # prepend the language name followed by semicolon and space
	    if ($content) {
		my $me1 = $doc->createElement("dc:$tag");
		my $lang_name = $row->[6];
		if ($lang_name && $content !~ /$lang_name/) {
		    $content = "$lang_name; $content";
		}
		$me = make_element($self, $doc, $tag, $content, null, null);
		add_olac_element($elements, $me);
	    }
	    else {
		$me = make_element($self, $doc, $tag, $row->[6], null, null);
		add_olac_element($elements, $me);
	    }
	}
	else {
	    $me = make_element($self, $doc, $tag, $content, $extid, $code);
	    add_olac_element($elements, $me);
	}
    }

    return $elements;
}


sub make_field {
    my ($self, $doc, $name, $value) = @_;
    my $facet = $doc->createElement('field');
    $facet->setAttribute('name', $name);
    $facet->addText($value);
    return $facet;
}

sub get_mdata_olacdla {
    my ($self, $doc, $tab) = @_;
    # $row : 0=tag, 1=lang, 2=content, 3=ext_id, 4=code
    #        5=ext_label, 6=code_label, 7=item_id
    #        8=tag, 9=dc_tag, 10=me_type, 11=ns_prefix
    #        12=iso_lang, 13=country_code, 14=country_name, 15=area
    my $elements = [];
    my $facet;
    my $online = 'No';
    my $families = {};
    my $regions = {};
    my $h = {};

    if (scalar(@$tab) == 0) {
        return $elements;
    }

    my $title = '';
    my $alternative = '';
    my $date = '';

    for my $row (@$tab) {
        my $tag = $row->[0];
	my $content = trim($row->[2]);
        my $dctag = $self->{dctag}{$tag};
	my $ext_id = $row->[3];
	my $ext_code = $row->[4];
	my $ext_code_label = $row->[6];
	my ($ext_schema,$ext_type) = @{$self->{extdb}{$ext_id}};
        my $me;

	if ($tag eq 'contributor') {
	    if (!$ext_schema) {
		if ($content) {
		    $me = $self->make_field($doc, $tag, $content);
		    my_push $elements, $me, $h;
		}
	    } elsif ($ext_type eq 'role') {
		if ($content) {
		    $me = $self->make_field($doc, $tag, $content);
		    my_push $elements, $me, $h;
		    if ($ext_code) {
			my $field = "contributor_role";
                        my $role = replace($ext_code, '_', ' ');
			$content = "$content ($role)";
			$me = $self->make_field($doc, $field, $content);
			my_push $elements, $me, $h;
		    }
		}
	    }

	} elsif ($tag eq 'coverage' || $tag eq 'spatial') {
	    if (!$ext_schema) {
		if ($content) {
		    $me = $self->make_field($doc, 'other_coverage', $content);
		    my_push $elements, $me, $h;
		}
	    } elsif ($ext_type eq 'ISO3166') {
		my $country = $self->{country}->{$content};
		if ($country) {
		    $me = $self->make_field($doc, 'country', $country);
		    my_push $elements, $me, $h;
		}
	    }

	} elsif ($tag eq 'creator') {
	    if ($content) {
                $me = $self->make_field($doc, 'contributor', $content);
                my_push $elements, $me, $h;
		$content = "$content (author)";
		$me = $self->make_field($doc, 'contributor_role', $content);
		my_push $elements, $me, $h;
	    }

	} elsif (($tag eq 'date') || ($dctag eq 'date')) {
	    if ($content) {
		if (!$ext_schema) {
		    $me = $self->make_field($doc, 'other_date', $content);
		    my_push $elements, $me, $h;
		    if ($dctag ne $tag) {
			$process_dcterms_date_refinement = 0;
		    }
		} elsif ($ext_type == 'W3CDTF') {
		    if (check_w3cdtf($content)) {
			$content =~ /^(\d{4})/;
			if ($1 >= 0 && $1 <= 1000) {
			    $me = $self->make_field($doc, 'other_date', $content);
			    my_push $elements, $me, $h;
			    if ($dctag ne $tag) {
				$process_dcterms_date_refinement = 0;
			    }
			} elsif ($1 > 1000) {
			    if ($tag eq 'date') {
				$date = $content;
			    } elsif (!$date) {
				$date = $content;
			    }

			    my $field = 'date_range';
			    $content = half_centry_range($1);
			    $me = $self->make_field($doc, $field, $content);
			    my_push $elements, $me, $h;
			    
			    if ($1 >= 1800) {
				$content = decade_range($1);
				$me = $self->make_field($doc, $field, $content);
				my_push $elements, $me, $h;
			    }

			    if ($dctag ne $tag) {
				$process_dcterms_date_refinement = 0;
			    }
			}
		    } else {
			$me = $self->make_field($doc, 'other_date', $content);
			my_push $elements, $me, $h;
			if ($dctag ne $tag) {
			    $process_dcterms_date_refinement = 0;
			}
		    }
		}
	    }

	} elsif ($tag eq 'format' || $tag eq 'medium') {
	    if ($content) {
		if (!$ext_schema) {
		    $me = $self->make_field($doc, 'other_format', $content);
		    my_push $elements, $me, $h;
		} elsif ($ext_type eq 'IMT') {
		    $me = $self->make_field($doc, 'imt_format', $content);
		    my_push $elements, $me, $h;
		}
	    }

	} elsif ($tag eq 'identifier') {
	    if ($content && $content !~ /^oai:/) {
		$me = $self->make_field($doc, $tag, trim($content));
		my_push $elements, $me, $h;
	    }
	    if ($content =~ /^(http|https|ftp):.*/) {
		$online = 'Yes';
	    }

	} elsif ($tag eq 'language') {
	    if (!$ext_schema) {
		if ($content) {
		    $me = $self->make_field($doc, 'other_language', $content);
		    my_push $elements, $me, $h;
		}
	    } elsif ($ext_type eq 'language') {
		if ($ext_code_label) {
		    $me = $self->make_field($doc, $tag, capitalize($ext_code_label));
		    my_push $elements, $me, $h;
		}
		if ($content) {
		    $me = $self->make_field($doc, 'other_language', $content);
		    my_push $elements, $me, $h;
		}
	    }

	} elsif ($dctag eq 'relation') {
	    if ($content && $self->{db}->recordExists($content)) {
		$me = $self->make_field($doc, "relation", $content);
		my_push $elements, $me, $h;
	    }

	} elsif ($tag eq 'rightsHolder' && $content) {
	    $content = "Rights holder: $content";
	    my_push $elements, $self->make_field($doc, 'rights', $content), $h;

	} elsif ($tag eq 'license') {
	    if (!$ext_schema) {
		if ($content) {
		    $me = $self->make_field($doc, 'rights', $content);
		    my_push $elements, $me, $h;
		}
	    } elsif ($ext_type eq 'URI') {
		if ($content) {
		    $me = $self->make_field($doc, 'license_url', $content);
		    my_push $elements, $me, $h;
		}
		if ($content =~ m{^http://creativecommons.org/licenses/(by-nc-(sa|nd))/2\.5/?$}) {
		    $content = "CC $1";
		} else {
		    $content = 'Other';
		}
		my_push $elements, $self->make_field($doc, $tag, $content), $h;
	    }

	} elsif ($tag eq 'subject') {
	    if (!$ext_schema) {
		if ($content) {
		    $me = $self->make_field($doc, 'other_subject', $content);
		    my_push $elements, $me, $h;
		}
	    } elsif ($ext_type eq 'LCSH') {
		if ($content) {
		    $me = $self->make_field($doc, 'lcsh_subject', $content);
		    my_push $elements, $me, $h;
		}
	    } elsif ($ext_type eq 'linguistic-field') {
		if ($ext_code_label) {
		    $me = $self->make_field($doc, 'linguistic_field', capitalize($ext_code_label));
		    my_push $elements, $me, $h;
		}
	    } elsif ($ext_type eq 'language') {
		if ($ext_code_label) {
		    $me = $self->make_field($doc, 'subject_language', capitalize($ext_code_label));
		    my_push $elements, $me, $h;
		}
		if ($content) {
		    $me = $self->make_field($doc, 'other_subject', $content);
		    my_push $elements, $me, $h;
		}

		if ($ext_schema eq 'http://www.language-archives.org/OLAC/1.0/' ||
		    $ext_schema eq 'http://www.language-archives.org/OLAC/1.1/') {
		    my $area = $row->[15];
		    if ($area) {
			$regions->{$area} = 1;
		    }
		    my $lineage = $self->{lineage}->{$ext_code};
		    if ($lineage) {
			my $p = $lineage->{parent};
			while (defined $p) {
			    $families->{$p->{name}} = 1;
			    $p = $p->{parent};
			}
		    }
		}
	    }

	} elsif ($tag eq 'title') {
            if ($content) {
                if ($title) {
                    $title = "$title -- $content";
                } else {
                    $title = $content;
                }
            }

	} elsif ($tag eq 'alternative') {
	    if (!$alternative && $content) {
		$alternative = $content;
	    }

	} elsif ($tag eq 'type') {
	    if (!$ext_schema) {
		if ($content) {
		    $me = $self->make_field($doc, 'other_type', $content);
		    my_push $elements, $me, $h;
		}
	    } elsif ($ext_type eq 'DCMIType') {
		if ($content) {
		    $me = $self->make_field($doc, 'dcmi_type', $content);
		    my_push $elements, $me, $h;
		}
	    } elsif ($ext_type eq 'linguistic-type') {
		if ($ext_code_label) {
		    $me = $self->make_field($doc, 'linguistic_type', capitalize($ext_code_label));
		    my_push $elements, $me, $h;
		}
	    } elsif ($ext_type eq 'discourse-type') {
		if ($ext_code_label) {
		    $me = $self->make_field($doc, 'discourse_type', capitalize($ext_code_label));
		    my_push $elements, $me, $h;
		}
	    }
	    
	} elsif (($tag eq 'temporal' ||
		  $tag eq 'publisher') &&
                  $content) {
	    my_push $elements, $self->make_field($doc, $tag, $content), $h;

	} elsif (($dctag eq 'rights') &&
		 $content) {
	    my_push $elements, $self->make_field($doc, $dctag, $content), $h;

	} elsif (($tag eq 'description' ||
	         $tag eq 'abstract') &&
                 $content) {
	    $me = $self->make_field($doc, 'description', $content);
	    my_push $elements, $me, $h;
	}

    }

    if ($alternative) {
	if ($title) {
	    $title = "$title -- $alternative";
	} else {
	    $title = $alternative;
	}
    }
    if (!$title) {
        $title = '[No Title]';
    }
    my_push $elements, $self->make_field($doc, 'title', $title), $h;
    
    if ($date) {
	my_push $elements, $self->make_field($doc, 'date', $date), $h;
    }

    my $item_id = $tab->[0]->[7];
    my $row = $self->{db}->getArchiveInfoForItemId($item_id);
    my $desc = "http://www.language-archives.org/archive/" . $row->[3];
    my $citefile = $self->{citedir} . '/' . $row->[4] . '.txt';
    if (open(CITE, $citefile)) {
        my $cite = <CITE>;
	my $me = $self->make_field($doc, 'rest_of_citation', $cite);
        chomp $cite;
	my_push $elements, $me, $h;
    }
    my_push $elements, $self->make_field($doc, 'archive', norm($row->[2])), $h;
    my_push $elements, $self->make_field($doc, 'archive_home', $row->[1]), $h;
    my_push $elements, $self->make_field($doc, 'archive_description', $desc), $h;
    my_push $elements, $self->make_field($doc, 'online', $online), $h;

    foreach my $f (keys %$regions) {
        my_push $elements, $self->make_field($doc, "region", $f), $h;
    }
    foreach my $f (keys %$families) {
        my_push $elements, $self->make_field($doc, "family", $f), $h;
    }

    return $elements;
}


sub get_mdata_oaidc {
    my ($self, $doc, $tab) = @_;
    # $tab is a list of $row's
    # $row : 0=tag,     1=lang,     2=content, 3=ext_id, 4=code,
    #        5=ext_lbl, 6=code_lbl
    my $elements = [];
    my $old_elements = get_mdata_olac_display($self, $doc, $tab);

    my $date_elem;
    for my $tag (qw(dc:date dcterms:issued dcterms:dateCopyrighted dcterms:created dcterms:available dcterms:dateAccepted dcterms:dateSubmitted dcterms:modified dcterms:valid)) {
	my @date_elems = grep {$_->getTagName eq $tag} @$old_elements;
	if (scalar(@date_elems) > 0) {
	    $date_elem = $date_elems[0];
	    last;
	}
    }

    for my $me (@$old_elements) {
	my $tag = $me->getTagName;
	$tag =~ s/dcterms://;
	$tag =~ s/dc://;
	my $dctag = $self->{dctag}{$tag};
	my $ext = $me->getAttribute('xsi:type');
	my $code = $me->getAttribute('olac:code');
	my $content = get_text($me);

	if (!$content && !$code) {
	    next;
	}

	$me->setTagName("dc:$dctag");

	if (($ext eq "olac:linguistic-type") ||
	    ($ext eq "olac:linguistic-field") ||
	    ($ext eq "olac:discourse-type")) {
	    $content =~ s/_/ /g;
	    set_text($me, $content);
	}

	if (($tag eq "type") && ($ext eq "olac:discourse-type")) {
	    $me->setTagName("dc:description");
	    if ($content) {
		set_text($me, "Discourse type: " . $content);
	    }
	}
	elsif (($tag eq "type") && ($ext eq "olac:linguistic-type")) {
	    if ($content) {
		set_text($me, "Linguistic type: " . $content);
	    }
	}
	elsif (($tag eq "contributor") &&
	       ($ext eq "olac:role") && ($code eq "author")) {
	    $me->setTagName("dc:creator");
	}
	elsif (($tag eq "subject") && ($ext eq "olac:language")) {
	    $me->setTagName("dc:language");
	}


	if ($ext) {
	    $me->removeAttribute('xsi:type');
	}
	if ($code) {
	    $me->removeAttribute('olac:code');
	}

	if ($dctag ne "date") {
	    add_dc_element($elements, $me);
	}
    }
 
    if ($date_elem) {
	add_dc_element($elements, $date_elem);
    }

    return $elements;
}

sub trim {
    my $s = shift;
    $s =~ s/^\s*//;
    $s =~ s/\s*$//;
    return $s;
}

sub norm {
    my $s = shift;
    $s =~ s/^\s*//;
    $s =~ s/\s*$//;
    $s =~ s/\s+/ /g;
    return $s;
}

sub half_centry_range {
    my $s = shift;
    if ($s < 1800) {
	return "Before 1800";
    } elsif ($s >= 2000) {
	return "2000 and later";
    } else {
	my $x = int($s / 100) * 100;
	my $y = $s - $x;
	my $a = $x + ($y < 50 ? 0 : 50);
	my $b = $a + 49;
	return "$a - $b";
    }
}

sub decade_range {
    my $s = shift;
    if ($s < 1800) {
	return "Before 1800";
    } else {
	my $x = int($s / 10) * 10;
	my $y = $x + 9;
	return "$x - $y";
    }
}

sub check_w3cdtf {
    my $s = shift;
    if ($s =~ /^\d{4}(-\d{2}(-\d{2}(T\d{2}:\d{2}(:\d{2}(\.\d)?)?[+-]\d{2}:\d{2})?)?)?$/) {
	return 1;
    } else {
	return 0;
    }
}

sub replace {
    my $s = shift;
    my $from = shift;
    my $to = shift;
    $s =~ s/$from/$to/;
    return $s;
}

sub capitalize {
    my $s = shift;
    $s =~ s/_/ /g;
    return ucfirst($s);
}

1;
