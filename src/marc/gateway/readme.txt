
An XSLT compiler for the abstract <gateway> specification
G. Simons, 4 Feb 2009

The <gateway> language is specified in gateway.rnc
Only the two filter stages are defined and implemented.

There are two sample instances of gateway specifications:
filter-minimal.xml  Passes everything through both stages
filter-sample.xml   Has a few tests in both stages

test.bat is a batch file that compiles a gateway spec and runs it on ..\sample.xml. It uses the MS XML package for the XSLT processor.  msxsl.exe is a little driver that can be downloaded from Microsoft; I just put it in my root folder, then the command is \msxsl

Two batch files are set up to run the two samples:

test-minimal.bat    
   Compiles filter-minimal.xml to generate the two stages of the filter (filter-minimal-stage1.xsl and filter-minimal-stage2.xsl) and then applies these in succession to ..\sample.xml to produce filter-minimal-out.xml

test-sample.bat
   Compiles filter-sample.xml and runs it on ..\sample.xml to produce filter-sample-out.xml


To create a real example, create a new gateway specification file that conforms to gateway.rnc and make a batch file for it by copying test-sample.bat, renaming it, and editing the contents to name your new gateway file and the input file you want to use.
 

15 Apr 2009

Added compilation of the inverse of the stage 1 and 2 filters.

filter.bat is the batch file that compiles the two filters and their two inverses and then runs them all on a test data file to produce four output files.  The doc in the file is:

rem Syntax: filter gateway-spec input
rem    where "gateway-spec" is without the .xml extention,
rem    but "input" does include the extension
rem
rem The outputs are:
rem    stage1-yes.xml  Records accepted by stage 1 filter
rem    stage1-no.xml   Records rejeted by stage 1 filter
rem    stage2-yes.xml  Records accepted by stage 2 filter
rem    stage2-no.xml   Records rejeted by stage 2 filter

filter-sample.bat calls the above on filter-sample.xml and ..\sample.xml


4 May 2009

Added generation of XSLT 2.0 version of the "yes" filters for use in
Python app.  The result is two additional outputs:

rem    %1-stage1.xsl   The final stage 1 filter (in XLST 2.0)
rem    %1-stage2.xsl   The final stage 2 filter (in XLST 2.0)
