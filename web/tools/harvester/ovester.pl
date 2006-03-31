#! /usr/bin/perl

use strict;
use OLAC::Harvester;
use Getopt::Std;
use POSIX;
use Cwd;

sub usage {
    print <<EOF;

usage: $0 [-hepv] [-c <config file>] -d <db info file>
  -h  show this message
  -e  erase the archive from database before harvesting
      (be careful to use this option when incrementally harvesting)
  -p  purge database after harvest
  -v  vebose output

  <db info file> should contain exactly 3 lines:
    first line - database name,
    second line - user name,
    third line - password.

EOF
    exit 1;
}

sub get_options {
    # set signal handler for getopts
    # print usage on unknown options
    $SIG{__WARN__} = 'usage';

    # get options
    my %opt;
    getopts('hevpc:d:', \%opt);

    # restore default signal handler
    $SIG{__WARN__} = 'DEFAULT';

    # check garbage (not checked by getopts) options
    if (scalar(@ARGV) || $opt{h} || !$opt{d}) {
	usage();
    }

    return \%opt;
}

sub get_config_file()
{
    my $url = "http://www.language-archives.org/register/archive_list.php4";
    my $filename;

    my $dom;
    eval {
	$dom = XML::DOM::Parser->new->parsefile($url);
    };
    if (!$dom) {
	return undef;
    }

    my $i;
    for ($i=0; $i < 10; $i++) {
	$filename = POSIX::tmpnam();
	open(FH, ">$filename") and last;
    }
    if ($i >= 10) {
	return undef;
    }

    my $archives = $dom->getElementsByTagName("archive");

    print FH "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n";
    print FH "<harvestconfig>\n";
    for ($i=0; $i < $archives->getLength; $i++) {
	my $archive = $archives->item($i);
	my $feature = $archive->getAttributes;
	my $id = $feature->getNamedItem("id")->getValue;
	my $baseURL = $feature->getNamedItem("baseURL")->getValue;

	print FH "  <archive>\n";
        print FH "    <identifier>$id</identifier>\n";
	print FH "    <url>$baseURL</url>\n";
	print FH "    <metadataPrefix>olac</metadataPrefix>\n";
	print FH "    <interval>1</interval>\n";
	print FH "    <interrequestgap>10</interrequestgap>\n";
	print FH "  </archive>\n";
	print FH "\n";
    }
    print FH "</harvestconfig>\n";

    close(FH);
    return $filename;
}

sub main {
    my ($config_file, $dbname, $user, $pass);

    # get harvester options
    my $opt = get_options();

    # get dbname, user, passwd
    open(FH, $opt->{d}) or die "can't open db info file, $opt->{d}\n";
    $dbname = <FH>; chomp $dbname; $dbname = "dbi:mysql:$dbname";
    $user = <FH>; chomp $user;
    $pass = <FH>; chomp $pass;
    close(FH);
	
    # get configuration file
    $config_file = $opt->{c} ? $opt->{c} : get_config_file();
    die("can't open configuration file") unless $config_file;
    if (substr($config_file, 0, 1) eq "/") {
	my $s = Cwd::cwd;
	$s =~ s/[^\/]+/../g;
	$config_file = substr($s,1) . $config_file;
    }

    # get a harvester and set options
    my $harvester = new OLAC::Harvester($config_file, $dbname, $user, $pass);
    if ($opt->{e}) {
	$harvester->set_preerase();
    }
    if ($opt->{v}) {
	$harvester->set_verbose();
    }

    # harvest
    $harvester->harvest;

    # purge
    if ($opt->{p}) {
	$harvester->purge;
    }

    # delete temporary file
    unlink($config_file) unless $opt->{c};
}

main;
