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
      "The combination of the values of the form, until, set and " .
      "metadataPrefix arguments results in an empty list.",
      
      "noMetadataFormats" => "There are no metadata formats available " .
      "for the specified item.",

      "noSetHierarchy" =>
      "The repository does not support sets."
    );

sub new {
    my ($class, $database, $user, $password, $idxml) = @_;

    my $self = {};

    $self->{db} = new OLAC::DB($database, $user, $password);
    $self->{idxml} = $idxml;

    $self->{GetRecord} = \&serve_GetRecord;
    $self->{Identify} = \&serve_Identify;
    $self->{ListIdentifiers} = \&serve_ListIdentifiers;
    $self->{ListMetadataFormats} = \&serve_ListMetadataFormats;
    $self->{ListRecords} = \&serve_ListRecords;
    $self->{ListSets} = \&serve_ListSets;
    $self->{Query} = \&serve_Query;
			 
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

sub create_error {
    my ($err_code, $request) = @_;
    my ($doc, $error) = get_template($request);

    $error->setTagName("error");
    $error->setAttribute("code", $err_code);
    $error->addText($errmsg{$err_code});

    return $doc;
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
    my $xmlns = "http://www.language-archives.org/OLAC/0.4/";
    $schema = $xmlns . "olac.xsd";

    $e->setAttribute("xmlns", $xmlns);
    $e->setAttribute("xmlns:xsi", "http://www.w3.org/2001/XMLSchema-instance");
    $e->setAttribute("xsi:schemaLocation", "$xmlns $schema");
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

    unless ($request->{identifier} && $request->{metadataPrefix}) {
        return create_error("badArgument", $request);
    } 

    unless ($request->{metadataPrefix} eq "olac") {
	return create_error("cannotDisseminateFormat", $request);
    }

    my ($head, $meta) = $self->{db}->getTable($request);

    # tag lang refine code scheme content
    # --- ---- ------ ---- ------ -------
    #  ..   ..    ...   ..    ...    ....
    # ...    .     ..    .   ....      ..

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
    $i->addText($head->[0]);
    $d->addText($head->[1]);
    if ($request->{metadataPrefix} eq "olac") {
	$m = $r->appendChild($doc->createElement("metadata"));
	$o = $m->appendChild($doc->createElement("olac"));
	set_olac_atts($o);
	$o->setAttribute("langs", "en");
	foreach my $row (@$meta) {
	    $me = $o->appendChild($doc->createElement($row->[0]));
	    $row->[1] && $me->setAttribute('lang', $row->[1]);
	    $row->[2] && $me->setAttribute('refine', $row->[2]);
	    $row->[3] && $me->setAttribute('code', $row->[3]);
	    $row->[4] && $me->setAttribute('scheme', $row->[4]);
	    $me->addText($row->[5]);
	}
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

    unless ($request->{metadataPrefix} eq "olac") {
	return create_error("cannotDisseminateFormat", $request);
    }

    if ($request->{set}) {
	return create_error("noSetHierarchy", $request);
    }

    my $list = $self->{db}->getTable($request);
    # identifier dateStamp
    # ---------- ---------
    #     .....

    unless ($list) {
	return create_error("noRecordsMatch", $request);
    }

    ($doc, $li) = get_template($request);

    foreach $row (@$list) {
	$h = $li->appendChild($doc->createElement("header"));
        $i = $h->appendChild($doc->createElement("identifier"));
        $d = $h->appendChild($doc->createElement("datestamp"));
	$i->addText($row->[0]);
        $d->addText($row->[1]);
    }

    return $doc;
}

sub serve_ListMetadataFormats {
    my ($self, $request) = @_;

    if ($request->{identifier} && !$self->{db}->getTable($request)) {
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
    $s->addText("http://www.language-archives.org/OLAC/0.4/olac.xsd");
    
    $mn = $mf->appendChild($doc->createElement("metadataNamespace"));
    $mn->addText("http://www.language-archives.org/OLAC/0.4/");

    return $doc;
}

sub serve_ListRecords {
    my ($self, $request) = @_;

    unless ($request->{metadataPrefix}) {
	return create_error("badArgument", $request);
    }
    unless ($request->{metadataPrefix} eq "olac") {
	return create_error("cannotDisseminateFormat", $request);
    }
    if ($request->{set}) {
	return create_error("noSetHierarchy", $request);
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
    # tag lang refine code scheme content Item_ID
    # --- ---- ------ ---- ------ ------- -------
    #  ..   ..    ...   ..    ...    ....     ..
    # ...    .     ..    .   ....      ..     ..

    unless (scalar(@$head)) {
	return create_error("noRecordsMatch", $request);
    }

    ($doc, $lr) = get_template($request);

    my $mcount = 0;
    foreach $item (@$head) {

	$r = $lr->appendChild($doc->createElement("record"));
	$h = $r->appendChild($doc->createElement("header"));
	$i = $h->appendChild($doc->createElement("identifier"));
	$i->addText($item->[0]);
	$d = $h->appendChild($doc->createElement("datestamp"));
	$d->addText($item->[1]);
	if ($request->{metadataPrefix} eq "olac") {
	    $m = $r->appendChild($doc->createElement("metadata"));
	    $o = $m->appendChild($doc->createElement("olac"));
	    $o->setAttribute("langs", "en");
	    # check: where is langs att of olac elem stored in the olac db?
	    set_olac_atts($o);
	    while ($mcount < scalar(@$meta) and
		   $meta->[$mcount]->[6] eq $item->[2]) {

		my $row = $meta->[$mcount++];
		$me = $o->appendChild($doc->createElement($row->[0]));
		$row->[1] && $me->setAttribute('lang', $row->[1]);
		$row->[2] && $me->setAttribute('refine', $row->[2]);
		$row->[3] && $me->setAttribute('code', $row->[3]);
		$row->[4] && $me->setAttribute('scheme', $row->[4]);
		$me->addText($row->[5]);
	    }
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

    if ($request->{elements} eq undef || $request->{elements} =~ /[^0-9]+/) {
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
    #      ....      ....      ..
    #       ...      ....      ..
    #
    # $meta
    # tag lang refine code scheme content Item_ID
    # --- ---- ------ ---- ------ ------- -------
    #  ..   ..    ...   ..    ...    ....     ..
    # ...    .     ..    .   ....      ..     ..

    unless (scalar(@$head)) {
	return create_error("noRecordsMatch", $request);
    }

    ($doc, $lr) = get_template($request);
    $lr->setTagName("ListRecords");
    $request->{metadataPrefix} = "olac";

    my $mcount = 0;
    foreach $item (@$head) {

	$r = $lr->appendChild($doc->createElement("record"));
	$h = $r->appendChild($doc->createElement("header"));
	$i = $h->appendChild($doc->createElement("identifier"));
	$i->addText($item->[0]);
	$d = $h->appendChild($doc->createElement("datestamp"));
	$d->addText($item->[1]);

	if ($request->{metadataPrefix} eq "olac") {
	    $m = $r->appendChild($doc->createElement("metadata"));
	    $o = $m->appendChild($doc->createElement("olac"));
	    $o->setAttribute("langs", "en");
	    # check: where is langs att of olac elem stored in the olac db?
	    set_olac_atts($o);

	    while ($mcount < scalar(@$meta) and
		   $meta->[$mcount]->[6] eq $item->[2]) {
		my $row = $meta->[$mcount++];
		$me = $o->appendChild($doc->createElement($row->[0]));
		$row->[1] && $me->setAttribute('lang', $row->[1]);
		$row->[2] && $me->setAttribute('refine', $row->[2]);
		$row->[3] && $me->setAttribute('code', $row->[3]);
		$row->[4] && $me->setAttribute('scheme', $row->[4]);
		$me->addText($row->[5]);
	    }
	}
    }

    delete $request->{metadataPrefix};
    return $doc;
}

1;
