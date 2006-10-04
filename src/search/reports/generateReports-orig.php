<?

####
#
# Synopsis: Generates archive report cards as created by archiveReport.php
#	for all archives. Report cards are viewed using archiveReportCard.php
#
# Written by: Amol Kamat <amol@students.cs.mu.oz.au>
#
# CVS Info: $Header: /cvsroot/olac/olac_suite/mu_tools/reports/generateReports-orig.php,v 1.1 2004/12/06 00:22:11 badenh Exp $
####

include "reportInclude.php";
require_once(LIB . "olacdb.php");
$DB=new OLACDB();

global $URLBASE;
$DEBUG=0;

$allArchivesQuery = "select Archive_ID from OLAC_ARCHIVE";

$allArchives = $DB->sql($allArchivesQuery);

# Form where no archive selected

    if ($DEBUG)
    {
	echo "Form: {$reportdir}{$prefix}.html\n";
    }
$filename="{$reportdir}{$prefix}.html";
$infile=fopen("{$URLBASE}reports/archiveReport.php", 'r');
$outfile=fopen($filename, 'w');
copyFile($infile, $outfile);

# Archive reports for all archives

foreach($allArchives as $archive)
{

    if ($DEBUG)
    {
	echo "Archive ID: $archive[Archive_ID] "
		. "- {$reportdir}{$prefix}{$archive[Archive_ID]}.html\n";
    }
$filename="{$reportdir}{$prefix}{$archive[Archive_ID]}.html";

$infile=fopen(
    "{$URLBASE}reports/archiveReport.php?archive=$archive[Archive_ID]", 'r');
$outfile=fopen($filename, 'w');

copyFile($infile, $outfile);
}

# Report for all archives

    if ($DEBUG)
    {
	echo "All archives: {$reportdir}{$prefix}all.html\n";
    }

$filename="{$reportdir}{$prefix}all.html";
$infile=fopen("{$URLBASE}reports/archiveReport.php?archive=all", 'r');
$outfile=fopen($filename, 'w');
copyFile($infile, $outfile);


function copyFile($infile, $outfile)
{

while ( $string = fgets($infile) )
{
    fwrite( $outfile, $string );
}
}

?>
