#! /usr/bin/env perl

use OLAC::Aggregator;

my $dbinfofile = "";
my $identify   = "";

sub read_input {
    my ($buffer, @pairs, $pair, $name, $value, %FORM);
    # Read in text
    $ENV{'REQUEST_METHOD'} =~ tr/a-z/A-Z/;
    if ($ENV{'REQUEST_METHOD'} eq "POST") {
        read(STDIN, $buffer, $ENV{'CONTENT_LENGTH'});
    }
    else {
        $buffer = $ENV{'QUERY_STRING'};
    }
    # Split information into name/value pairs
    @pairs = split(/&/, $buffer);
    foreach $pair (@pairs) {
        ($name, $value) = split(/=/, $pair);
        $value =~ tr/+/ /;
        $value =~ s/%(..)/pack("C", hex($1))/eg;
        $FORM{$name} = $value;
    }
    if ($ENV{SERVER_PORT} eq "80") {
      $FORM{baseURL} = "http://$ENV{SERVER_NAME}$ENV{REQUEST_URI}";
    }
    else {
      $FORM{baseURL} = "http://$ENV{SERVER_NAME}:$ENV{SERVER_PORT}$ENV{REQUEST_URI}";
    }
    $FORM{baseURL} =~ s/\?.*//;
    \%FORM;
}

sub main {
    my $dp = new OLAC::Aggregator($dbinfofile, $identify);
    my $request = read_input();

    my $doc = $dp->serve_request($request);

    if ($doc) {
        print "Content-type: text/xml\n\n";
        print $doc->toString;
    }
    else {
        print "Content-type: text/html\n\n";
        my $error = new HTTP::Response;
        $error->code(400);
        $error->message
            ("Bad request" .
             "<p>http://$ENV{SERVER_NAME}$ENV{REQUEST_URI}" .
             "<p>$request->{error}");
        print $error->error_as_HTML;
    }
}

main;

