#!/usr/bin/perl -w -I.
use strict;

#  ----------------------------------------------------------------------
# | OAI Harvester                                                        |
# | Hussein Suleman                                                      |
# | July 2001                                                            |
#  ----------------------------------------------------------------------
# |  Virginia Polytechnic Institute and State University                 |
# |  Department of Computer Science                                      |
# |  Digital Libraries Research Laboratory                               |
#  ----------------------------------------------------------------------

package Harvester;

use POSIX;
use XML::DOM;
use Cwd;
use LWP;

use TS;

sub new
{
   my ($classname, $configfile) = @_;
   
   my $self = {
      class           => $classname,
      directory       => cwd,

      # global defaults
      daysoverlap     => 2,
      interrequestgap => 600,
   };
   
   my $parser = new XML::DOM::Parser;
   $self->{config} = $parser->parsefile ("$self->{directory}/$configfile");
   
   bless $self, $classname;

   return $self;
}

sub toISO8601
{
   my ($self, $atime) = @_;
   my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime ($atime);
   sprintf ("%04d-%02d-%02d", $year+1900, $mon+1, $mday);
}

sub getHTTP
{
   my ($self, $url) = @_;

   # create a user agent object
   my $ua = new LWP::UserAgent;
   $ua->agent("VT OAI Harvester/1.0 " . $ua->agent);

   # create a request
   my $req = new HTTP::Request GET => $url;

   my $state = 0;
   my $res;
   while ($state == 0)
   {
      # pass request to the user agent and get a response back
      $res = $ua->request($req);
      
      if ($res->code == 503)
      {
         my $sleep = $res->header ('Retry-After');
         if (not defined ($sleep) || ($sleep < 0) || ($sleep > 86400))
         { $state = 1;}
         else
         { sleep ($sleep); }
      }
      else
      { $state = 1; }
   }
   
   # return results to caller
   $res;
}

sub harvest
{
   my ($self) = @_;
   
   # iterate over archives in configuration
   foreach my $archive ($self->{config}->getDocumentElement->getElementsByTagName ("archive"))
   {
      my $outputheader = 0;

      # get configuration variables
      my $archiveidentifier = $archive->getElementsByTagName ("identifier")->item(0)->getFirstChild->getNodeValue;
      my $archiveurl = $archive->getElementsByTagName ("url")->item(0)->getFirstChild->getNodeValue;
      my $archiveinterval = $archive->getElementsByTagName ("interval")->item(0)->getFirstChild->getNodeValue;
      my @archivemetadataPrefixes = ();
      foreach my $archivemetadataPrefix ($archive->getElementsByTagName ("metadataPrefix"))
      {
         push (@archivemetadataPrefixes, $archivemetadataPrefix->getFirstChild->getNodeValue);
      }
      my $archiveset = '';
      if (($archive->getElementsByTagName ("set")->getLength == 1) &&
          ($archive->getElementsByTagName ("set")->item(0)->hasChildNodes))
      {
         $archiveset = $archive->getElementsByTagName ("set")->item(0)->getFirstChild->getNodeValue;
      }
      my $archivedaysoverlap = $self->{daysoverlap};
      if (($archive->getElementsByTagName ("daysoverlap")->getLength == 1) &&
          ($archive->getElementsByTagName ("daysoverlap")->item(0)->hasChildNodes))
      {
         $archivedaysoverlap = $archive->getElementsByTagName ("daysoverlap")->item(0)->getFirstChild->getNodeValue;
      }
      my $archiveinterrequestgap = $self->{interrequestgap};
      if (($archive->getElementsByTagName ("interrequestgap")->getLength == 1) &&
          ($archive->getElementsByTagName ("interrequestgap")->item(0)->hasChildNodes))
      {
         $archiveinterrequestgap = $archive->getElementsByTagName ("interrequestgap")->item(0)->getFirstChild->getNodeValue;
      }

      # clean extraneous whitespace
      $archiveidentifier =~ s/^([\s\r\n\t]*)([^\s\r\n\t]*)([\s\r\n\t]*)$/$2/;
      $archiveurl =~ s/^([\s\r\n\t]*)([^\s\r\n\t]*)([\s\r\n\t]*)$/$2/;
      $archiveinterval =~ s/^([\s\r\n\t]*)([^\s\r\n\t]*)([\s\r\n\t]*)$/$2/;
      foreach my $archivemetadataPrefix (@archivemetadataPrefixes)
      {
         $archivemetadataPrefix =~ s/^([\s\r\n\t]*)([^\s\r\n\t]*)([\s\r\n\t]*)$/$2/;
      }
      $archiveset =~ s/^([\s\r\n\t]*)([^\s\r\n\t]*)([\s\r\n\t]*)$/$2/;
      $archivedaysoverlap =~ s/^([\s\r\n\t]*)([^\s\r\n\t]*)([\s\r\n\t]*)$/$2/;
      $archiveinterrequestgap =~ s/^([\s\r\n\t]*)([^\s\r\n\t]*)([\s\r\n\t]*)$/$2/;
            
      # create unique token for this harvesting operation - lock the archive
      my $ts = new TS ("$self->{directory}/data/$archiveidentifier.lock");

      # use non-blocking test-and-set to avoid overlapping harvesting
      if ($ts->test == 1)
      {
         # get from and until dates
         my $archivemetadataPrefix = 'all';
         if ($#archivemetadataPrefixes == 0)
         {
            $archivemetadataPrefix = $archivemetadataPrefixes[0];
         }
      
         # read in from date for this archive and metadataPrefix
         my $fromdate;
         if (-e "$self->{directory}/data/$archiveidentifier.$archivemetadataPrefix.date")
         {
            open (FILE, "<$self->{directory}/data/$archiveidentifier.$archivemetadataPrefix.date");
            $fromdate = <FILE>;
            close (FILE);
            chomp $fromdate;
         }
         else
         {
            $fromdate = 315550800; # 1 jan 1980
         }
         
         my $untildate = time;
         
         # check if new harvest is required
         if (($fromdate + ($archiveinterval * 86400)) < $untildate)
         {
            # enforce overlap to cater for timezones and granularity
            if (($untildate - $fromdate) < (86400 * $archivedaysoverlap))
            {
               $fromdate = $untildate - (86400 * $archivedaysoverlap);
            }
            
            # build request;
            my $request = $archiveurl;
            if ($#archivemetadataPrefixes == 0)
            {
               $request .= "?verb=ListRecords&metadataPrefix=".$archivemetadataPrefix;
            }
            else
            {
               $request .= "?verb=ListIdentifiers";
            }
            $request .= "&from=".$self->toISO8601 ($fromdate).
                        "&until=".$self->toISO8601 ($untildate);
            if ($archiveset ne '')
            {
               $request .= "&set=$archiveset";
            }

            # submit first request
            my $res = $self->getHTTP ($request);
            
            # halt on errors
            if ($res->code != 200)
            {
               $ts->clear;
               warn "REQUEST:" . $request;
               warn "HTTP Error connecting to OAI data provider $archiveidentifier/$archivemetadataPrefix\n".
                   $res->code.' '.$res->message;
               next;
            }
      
            # parse and process the XML
            my $gotresumptiontoken;
            do {
               my $parser = new XML::DOM::Parser;
               my $doc;
               eval { $doc = $parser->parse ($res->content); };
               if ($@) {
                  warn "REQUEST:" . $request;
                  warn $@;
                  goto BREAK;
               }               

               if ($#archivemetadataPrefixes == 0)
               {               
                  for my $record ($doc->getDocumentElement->getElementsByTagName ("record"))
                  {
                     if ($outputheader == 0)
                     {
                        $outputheader = 1;
                        $self->processHarvestStart ($archiveidentifier, $archiveurl,
                                  $archiveinterval, \@archivemetadataPrefixes,
                                  $archiveset, $archivedaysoverlap,
                                  $archiveinterrequestgap);
                     }
                     $self->processIdStart ($record->getElementsByTagName ("header")
                                       ->item(0)->getElementsByTagName ("identifier")
                                       ->item(0)->getFirstChild->getNodeValue,
                                       $record->getAttribute ('status'));
                     $self->processRecord ($record, $untildate, $archivemetadataPrefix, $archiveset, $archiveidentifier);
                     $self->processIdEnd ($record->getElementsByTagName ("header")
                                       ->item(0)->getElementsByTagName ("identifier")
                                       ->item(0)->getFirstChild->getNodeValue);
                  }
               }
               else
               {
                  for my $recordid ($doc->getDocumentElement->getElementsByTagName ("identifier"))
                  {
                     if ($outputheader == 0)
                     {
                        $outputheader = 1;
                        $self->processHarvestStart ($archiveidentifier, $archiveurl,
                                  $archiveinterval, \@archivemetadataPrefixes,
                                  $archiveset, $archivedaysoverlap,
                                  $archiveinterrequestgap);
                     }
                     my $identifier = $recordid->getFirstChild->getNodeValue;
                     $self->processIdStart ($identifier, $recordid->getAttribute ('status'));
                     foreach my $ametadataPrefix (@archivemetadataPrefixes)
                     {
                        # build request;
                        my $request = $archiveurl."?verb=GetRecord&metadataPrefix=".$ametadataPrefix.
                                      "&identifier=$identifier";

                        # submit request
                        my $res = $self->getHTTP ($request);
            
                        # halt on errors
                        if ($res->code != 200)
                        {
                           $ts->clear;
                           warn "REQUEST:" . $request;
                           warn "HTTP Error connecting to OAI data provider $archiveidentifier/$archivemetadataPrefix\n".
                               $res->code.' '.$res->message;
                           next;
                        }
                     
                        my $doc;
                        eval { $doc = $parser->parse ($res->content); };
                        if ($@) {
                           warn "REQUEST:" . $request;
                           warn $@;
                           next;
                        }

                        for my $record ($doc->getDocumentElement->getElementsByTagName ("record"))
                        {
                           $self->processRecord ($record, $untildate, $ametadataPrefix, $archiveset, $archiveidentifier);
                        }
                        $doc->dispose;
                     }
                     $self->processIdEnd ($identifier);
                  }
               }         
         
               # if resumption token exists, get more data
               my $resumptiontokenNodeList = $doc->getDocumentElement->getElementsByTagName ("resumptionToken");
               if ($resumptiontokenNodeList->getLength == 1)
               {
                  my $resumptiontoken = $resumptiontokenNodeList->item(0)->getFirstChild->getNodeValue;
                  $resumptiontoken =~ s/^([\s\n\r\t]*)([^\s\n\r\t]*)([\s\n\r\t]*)$/$2/;
                  $gotresumptiontoken = 1;
                  sleep ($archiveinterrequestgap);
                  $request = $archiveurl;
                  if ($#archivemetadataPrefixes == 0)
                  {
                     $request .= "?verb=ListRecords";
                  }
                  else
                  {
                     $request .= "?verb=ListIdentifiers";
                  }
                  $request .= "&resumptionToken=".$resumptiontoken;

                  $res = $self->getHTTP ($request);
                  
                  # halt on errors
                  if ($res->code != 200)
                  {
                     $ts->clear;
                     warn "REQUEST:" . $request;
                     warn "HTTP Error connecting to OAI data provider $archiveidentifier/$archivemetadataPrefix\n".
                         $res->code.' '.$res->message;
                     goto BREAK;
                  }
               }
               else
               {
                  $gotresumptiontoken = 0;
               }
         
               $doc->dispose;
            } while ($gotresumptiontoken > 0);
            
            # save current date
            open (FILE, ">$self->{directory}/data/$archiveidentifier.$archivemetadataPrefix.date");
            print FILE "$untildate\n";
            close (FILE);
BREAK:
         }

         $ts->clear;
      }
   
      if ($outputheader == 1)
      {
         $self->processHarvestEnd;
      }
   }
}

sub processHarvestStart
{
   my ($self, $archiveidentifier, $archiveurl, $archiveinterval, 
       $archivemetadataPrefixes, $archiveset, $archivedaysoverlap,
       $archiveinterrequestgap) = @_;
   print "\nHarvesting:\n";
   print "  archive         = $archiveidentifier\n";
   print "  url             = $archiveurl\n";
   print "  interval        = $archiveinterval days\n";
   foreach my $archivemetadataPrefix (@$archivemetadataPrefixes)
   {
      print "  metadataPrefix  = $archivemetadataPrefix\n";
   }
   print "  set             = $archiveset\n";
   print "  daysoverlap     = $archivedaysoverlap\n";
   print "  interrequestgap = $archiveinterrequestgap\n\n";
}

sub processHarvestEnd
{
   print "\ndone.\n";
}

sub processIdStart
{
   my ($self, $identifier, $status) = @_;
   
   print "$identifier, $status\n";
}

sub processIdEnd
{
   my ($self, $identifier) = @_;
   
   print "/$identifier\n";
}

sub processRecord
{
   my ($self, $xml, $date, $metadataPrefix, $set, $archiveid) = @_;
   
   my $identifier = $xml->getElementsByTagName ("header")
                        ->item(0)->getElementsByTagName ("identifier")
                        ->item(0)->getFirstChild->getNodeValue;
   $identifier =~ s/^([\s\n\r\t]*)([^\s\n\r\t]*)([\s\n\r\t]*)$/$2/g;

   print "$identifier in $metadataPrefix on ".$self->toISO8601 ($date)."\n";
}

1;



=head1 NAME

Harvester - Multi-purpose OAI Harvester

=head1 SYNOPSIS

  use Harvester;
 
  my $h = new Harvester ('configfile');
  
  $h->harvest;

=head1 DESCRIPTION

Harvest data periodically from an OAI data source. The 
harvester ought to be called periodically using a scheduler 
such as I<cron>.

The configuration file contains an XML description of the 
harvesting schedule such as the following:

  <?xml version="1.0" encoding="utf-8" ?>

  <config>

   <archive>
      <identifier>TEST</identifier>
      <url>http://www.test.org/cgi-bin/OAI.pl</url>
      <metadataPrefix>oai_dc</metadataPrefix>
      <interval>0.5</interval>
      <set>All</set>
      <daysoverlap>2</daysoverlap>
      <interrequestgap>10</interrequestgap>
   </archive>
   
  </config>
  
The above example will get Dublin Core metadata from the 
TEST archive at the most every 0.5 days (depending on how 
often harvesting is scheduled).

I<archive> is a repeatable element. I<set> specifies a set 
to harvest from. I<daysoverlap> indicates the number of 
overlapping days for harvesting and defaults to 2. 
I<interrequestgap> specifies the number of seconds between 
resumption requests and defaults to 600. These three 
parameters are optional but the rest are required.

I<metadataPrefix> is repeatable within a single I<archive>
element. If there is more than one entry, the Harvester will
request the identifiers and then obtain all metadata for
each record in turn. With a single I<metadataPrefix> the
Harvester uses the more efficient I<ListRecords> service
request to get metadata for multiple records in each request.
For greater speed and lower network usage, it is better to
have two I<archive> sections for different metadata formats
rather than include them in a single I<archive> section 
(the latter leads to finer granularity of consistency if this 
is the overriding factor).

The name I<config> is ignored so can be changed if desired.

The harvester works by calling five functions that are meant 
to be overridden in a descendent class: I<processHarvestStart>
is called at the beginning of harvesting a set of records and
I<processHarvestEnd> is called at the end of a harvest;
I<processIdStart> is called before any identifier is 
processed and I<processIdEnd> is called afterwards; and 
I<processRecord> is called once for each metadata record.
 
In the last case, an I<XML::DOM::Node> "record" subtree is 
passed in for processing.

The Harvester uses the I<data> subdirectory to store dates
for each archive being harvested as well as lock files. These
lock files will prevent overlapped harvesting of the same
archive, and if something goes wrong and the program
crashes, will prevent recurrences until the lock file
is manually removed.

=head1 METHODS

=over 4

=item new (config_filename)

Creates a new harvester using the specified filename as a 
schedule configuration.

=item harvest ()

Harvest metadata from all archives as specified in the 
configuration file. If this function is called many times 
by different instances, locking of individual archives 
allows different instances to work on different archives.

=item processHarvestStart (identifer,url,interval,
metadataPrefixes,set,daysoverlap,interrequestgap)

Callback function to handle configuration information for 
archive being harvested (by default this is output to 
STDOUT). The parameters correspond to an entry in the 
configuration file - all are strings except 
I<metadataPrefixes> which is a reference to a list of 
strings.

=item processHarvestEnd ()

Callback function called after harvesting has completed.

=item processIdStart (identifier,status)

Callback function called just before metadata for a record
is processed.

=item processIdEnd (identifier)

Callback function called after all metadata for a record
has been processed.

=item processRecord (xml,date,metadataPrefix,set,archiveid)

Callback function to handle "record" XML fragment, passed in 
as an I<XML::DOM::Node>. The I<date> refers to the date of 
harvesting and the I<metadataPrefix> and I<set> are the 
values sent to the data provider. I<archiveid> is a unique 
identifier for the archive.

=back

=head1 NOTES

This is part of the larger effort to build componentized digital libraries.

=head1 CAVEATS

Of course this is largely  untested :)

=head1 BUGS

None that I found yet.

=head1 AUTHOR

Hussein Suleman <hussein@vt.edu>

=head1 HISTORY

This is the first release version.

=cut

