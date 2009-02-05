
An XSLT compiler for the abstract <gateway> specification
G. Simons, 4 Feb 2009

The <gateway> language is specified in gateway.rnc
Only the two filter stages and defined and implemented.

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
 

