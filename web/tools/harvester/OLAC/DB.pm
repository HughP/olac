package OLAC::DB;

use strict;
use DBI;

sub new {
    my ($class, $database, $user, $password) = @_;
    
    my $self = {};
    $self->{dbh} = DBI->connect($database, $user, $password)
	or die "login failed\ndatabase=$database\nuser=$user\n";

    $self->{GetRecord} = \&getTable_GetRecord;
    $self->{ListIdentifiers} = \&getTable_ListIdentifiers;
    $self->{ListMetadataFormats} = \&getTable_ListMetadataFormats;
    $self->{ListRecords} = \&getTable_ListRecords;
    $self->{Query} = \&getTable_Query;

    bless $self, $class;
    return $self;
}

sub DESTROY {
    my ($self) = @_;
    $self->{dbh}->disconnect;
}

sub get_earliestDatestamp {
    my ($self) = @_;
    return $self->{dbh}->selectrow_arrayref
	("select min(DateStamp) from ARCHIVED_ITEM")->[0];
}

##########################
##########################
#                        #
#  Harvester Interfaces  #
#                        #
##########################
##########################

# DELETE THE ARCHIVE FROM THE DATABASE
# input: base url
sub clear {
    my($self, $url) = @_;

    my $olac_table = $self->{dbh}->selectall_arrayref
	("select Archive_ID from OLAC_ARCHIVE ". 
	 "where BaseURL='$url'");

    foreach my $row (@$olac_table) {
	my $archive_id = $row->[0];

	my $archive_table = $self->{dbh}->selectall_arrayref
	    ("select Item_ID from ARCHIVED_ITEM " .
	     "where Archive_ID=$archive_id");

	# delete metadata items
	my $res = $self->{dbh}->prepare
	    ("delete from METADATA_ELEM where Item_ID=?");
	foreach (@$archive_table) {
	    $res->execute($_->[0]) or die $self->{dbh}->errstr;
	}
	$res->finish;

	# delete an archive item
	$self->{dbh}->do("delete from ARCHIVED_ITEM " .
			 "where Archive_ID=$archive_id");

	# delete an archive
	$self->{dbh}->do("delete from OLAC_ARCHIVE " .
			 "where Archive_ID=$archive_id");
    }
}

# input: name of a table (string)
# input: reference to a record (hash)
# returns: query result
sub insert {
    my ($self, $table, $record) = @_;

    my $fields = "";
    my $values = "";

    foreach my $f (keys %$record) {
	my $v = $record->{$f};
	$v or next;
	$v =~ s/\'/\'\'/g;
        $v =~ s/\\/\\\\/g;

	$fields .= "$f,";
	$values .= "'" . $v . "',";
    }
    chop($fields);
    chop($values);

    my $query = $self->{dbh}->prepare
	("insert into $table ($fields) values (" . $values . ")");
    $query->execute or die $self->{dbh}->errstr;

    return $query->{mysql_insertid};
}

# input: archive url
# returns: first harvested date
sub getFirstHarvested {
    my ($self, $url) = @_;

    my $row = $self->{dbh}->selectrow_arrayref
	("select FirstHarvested from OLAC_ARCHIVE " .
	 "where BaseUrl='$url'");
    if ($row) {
	return $row->[0];
    }
    else {
	my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst)=gmtime(time);
	return sprintf("%04d-%02d-%02d", $year+1900, $mon+1, $mday);
    }
}

# input: reference to a record (hash table)
sub clearOlacArchive {
    my ($self, $record) = @_;
    clear($self, $record->{BaseURL});
}

# input: reference to a record (hash table)
# returns: archive id
sub insertOlacArchive {
    my ($self, $record) = @_;
    return insert($self, "OLAC_ARCHIVE", $record);
}

# input: reference to a record (hash table)
# returns: archive id
sub updateOlacArchive {
    my ($self, $record) = @_;

    my $ids = $self->{dbh}->selectrow_arrayref
	          ("select Archive_ID from OLAC_ARCHIVE
                    where baseURL='$record->{BaseURL}'");
    unless ($ids) {
	return insert($self, "OLAC_ARCHIVE", $record);
    }

    my $setstr = "";
    foreach my $key (keys %$record) {
        my $val = $record->{$key};
	$val =~ s/\'/\'\'/g;
	$val =~ s/\\/\\\\/g;
	$setstr .= "$key='$record->{$key}',";
    }
    chop $setstr;

    my $query = $self->{dbh}->prepare
	("update OLAC_ARCHIVE set $setstr
          where Archive_ID=$ids->[0]");
    $query->execute or die $self->{dbh}->errstr;
    
    return $ids->[0];
}

# input: olac xmlns
# returns: schema id
sub getSchemaId {
    my ($self, $xmlns) = @_;    

    my $retval = $self->{dbh}->selectrow_arrayref
	("SELECT Schema_ID from SCHEMA_VERSION " .
	 "where xmlns='$xmlns'")->[0];

    return $retval;
}

# input: reference to a record (hash table)
# returns: item id
sub insertArchivedItem {
    my ($self, $record) = @_;

    return insert($self, "ARCHIVED_ITEM", $record);
}

# input: reference to a record (hash table)
sub deleteArchivedItem {
    my ($self, $record) = @_;

    my $oai_id = $record->{OaiIdentifier};
    $oai_id =~ s/\'/\'\'/g;

    my $item = $self->{dbh}->selectall_arrayref
	("select Item_ID from ARCHIVED_ITEM " .
	 "where OaiIdentifier='$oai_id'");
    
    my $res = $self->{dbh}->prepare
	("delete from METADATA_ELEM where Item_ID=?");
    foreach (@$item) {
	$res->execute($_->[0]) or die $self->{dbh}->errstr;
    }
    $res->finish;

    my $query = $self->{dbh}->prepare
	("delete from ARCHIVED_ITEM " .
	 "where OaiIdentifier='$oai_id'");
    $query->execute;
}

# input: olac metadata element tag name
# returns: tag id
sub getTagId {
    my ($self, $tagname) = @_;

    my $retval = $self->{dbh}->selectrow_arrayref
	("select Tag_ID from ELEMENT_DEFN " .
	 "where TagName='$tagname'")->[0];

    return $retval;
}

# input: reference to a record (hash table)
sub insertMetadataElem {
    my ($self, $record) = @_;

    insert($self, "METADATA_ELEM", $record);
}

sub refreshIndices {
    my ($self) = @_;

    $self->{dbh}->do
	("drop index ARCHIVED_ITEM_INDEX on ARCHIVED_ITEM");
    $self->{dbh}->do
	("drop index METADATA_ELEM_INDEX on METADATA_ELEM");
    $self->{dbh}->do
	("create index ARCHIVED_ITEM_INDEX " .
	 "on ARCHIVED_ITEM (Archive_ID, Schema_ID, OaiIdentifier)");
    $self->{dbh}->do
	("create index METADATA_ELEM_INDEX " .
	 "on METADATA_ELEM (Item_ID, Tag_ID)");
}

# delete archives that are not in the given list
# input: a list of archive urls
sub delete_archives_not_in_list {
    my ($self, $list) = @_;
    my $table = $self->{dbh}->selectall_arrayref
	("select baseURL from OLAC_ARCHIVE");
    my %local_list;
    foreach my $row (@$table) {
	$local_list{$row->[0]} = 1;
    }
    foreach my $url (@$list) {
	delete $local_list{$url};
    }
    foreach my $url (keys %local_list) {
	$self->clear($url);
    }
}



###########################
###########################
#                         #
#  Aggregator Interfaces  #
#                         #
###########################
###########################

sub getTable {
    my ($self, $request) = @_;

    my $f = $self->{$request->{verb}};
    return $f ? $f->($self,$request) : undef;
}

sub getTable_GetRecord {
    my ($self, $request) = @_;

    my $archived_item = $self->{dbh}->selectrow_hashref
	("select * from ARCHIVED_ITEM " .
	 "where OaiIdentifier='$request->{identifier}'");

    my $header;
    if ($archived_item) {
	$header = [ $archived_item->{OaiIdentifier},
		    $archived_item->{DateStamp} ];
    }
    else {
	$header = undef;
    }

    my $metadata;
    if ($request->{metadataPrefix} eq "olac") {
	$metadata = $self->{dbh}->selectall_arrayref
	    ("select TagName,Lang,Refine,Code,Scheme,Content " .
	     "from METADATA_ELEM " .
	     "where Item_ID='$archived_item->{Item_ID}'");
    }
    else {
	$metadata = undef;
    }

    return ($header, $metadata);
}

sub getTable_ListIdentifiers {
    my ($self, $request) = @_;

    return undef if $request->{set};

    my $query = "select OaiIdentifier, DateStamp from ARCHIVED_ITEM ";

    my $conj = "where";
    if ($request->{resumptionToken}) {
	$query .= "$conj OaiIdentifier >= '$request->{next}' ";
	$conj = "and";
    }
    if ($request->{from}) {
	$query .= "$conj DateStamp >= '$request->{from}' ";
	$conj = "and";
    }
    if ($request->{until}) {
	$query .= "$conj DateStamp <= '$request->{until}'";
    }

    $query .= "order by OaiIdentifier";

    my $list = $self->{dbh}->selectall_arrayref($query);
    if (scalar(@$list) > 200) {
	$request->{next} = $list->[200]->[0];
	splice(@$list, 200);
    }
    elsif ($request->{next}) {
	delete $request->{next};
    }

    return $list;
}

sub getTable_ListMetadataFormats {
    my ($self, $request) = @_;

    return undef unless ($request->{identifier});

    return $self->{dbh}->selectrow_arrayref
	("select Item_ID from ARCHIVED_ITEM " .
	 "where OaiIdentifier='$request->{identifier}'");
}

sub getTable_ListRecords {
    my ($self, $request) = @_;

    return undef if $request->{set};

    my ($query, $header, $meta);
    my ($f, $u);  # from, until

    # prepare query for $header
    $query = "select OaiIdentifier, DateStamp, Item_ID from ARCHIVED_ITEM ";

    my $conj = "where";
    if ($request->{resumptionToken}) {
	$query .= "$conj Item_ID >= $request->{next} ";
	$conj = "and";
    }
    if ($request->{from}) {
	$query .= "$conj DateStamp >= '$request->{from}'";
	$conj = "and";
    }
    if ($request->{until}) {
	$query .= "$conj DateStamp <= '$request->{until}'";
    }

    $query .= "order by Item_ID limit 201";

    $header = $self->{dbh}->selectall_arrayref($query);
    if (scalar(@$header) > 200) {
	$request->{next} = $header->[200]->[2];
	splice(@$header, 200);
    }
    elsif ($request->{next}) {
	delete $request->{next};
    }

    if ($request->{metadataPrefix} eq "olac") {
	# prepare query for $meta
	$query = "select TagName,Lang,Refine,Code,Scheme,Content,a.Item_ID " .
	         "from METADATA_ELEM as m, ARCHIVED_ITEM as a " .
		 "where m.Item_ID = a.Item_ID ";
	
	if ($request->{next}) {
	    my $first = $header->[0]->[2];
	    my $last = $header->[199]->[2];
	    $query .= "and a.Item_ID >= $first and a.Item_ID <= $last ";
	}
	if ($request->{from}) {
	    $f = "DateStamp >= '$request->{from}'";
	    $query .= "and $f ";
	}
	if ($request->{until}) {
	    $u = "DateStamp <= '$request->{until}'";
	    $query .= "and $u ";
	}

	$query .= "order by a.Item_ID";

	$meta = $self->{dbh}->selectall_arrayref($query);
    }
    else {
	$meta = undef;
    }

    return ($header, $meta);
}

sub getTable_Query {
    my ($self, $request) = @_;

    my ($query, $header, $meta, $meta1);

    # prepare query for $header
    $query =
	"select distinct OaiIdentifier, DateStamp, a.Item_ID " .
	"from ARCHIVED_ITEM as a ";

    my ($i, $where, $conj);
    $conj = "";
    for ($i=1; $i <= $request->{elements}; ++$i) {
	$query .= ", METADATA_ELEM as e$i ";
	$where .= "$conj a.Item_ID=e$i.Item_ID ";
	$conj = "and";
    }

    if ($request->{resumptionToken}) {
	$where .= "$conj a.Item_ID >= $request->{next} ";
	$conj = "and";
    }

    my $count = $request->{count} ? $request->{count} : 20;
    my $count1 = $count + 1;

    $query .= "where $where $conj $request->{sql} " .
	      "order by a.Item_ID limit $count1";

    $header = $self->{dbh}->selectall_arrayref($query);
    unless ($header) {
        return (undef, undef);         # indicates an exception
    }

    if (scalar(@$header) > $count) {
        $request->{next} = $header->[$count]->[2];
	splice(@$header, $count);
    }
    elsif ($request->{next}) {
	delete $request->{next};
    }

    foreach my $item (@$header) {
	# prepare query for $meta
	$query =
	    "select TagName,Lang,Refine,Code,Scheme,Content,Item_ID " .
	    "from METADATA_ELEM where Item_ID=$item->[2]";
	$meta1 = $self->{dbh}->selectall_arrayref($query);
	push (@$meta, @$meta1);
    }

    return ($header, $meta);
}

1;

