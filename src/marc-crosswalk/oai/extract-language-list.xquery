xquery version "1.0";  
   
(:    extract-language-list.xquery 
      G. Simons, 4 June 2011

Extracts a list of all the dc:language elements in the accepted
records. 

N.B>: Use text output method and explicit output of new lines


:)
         
declare namespace dc="http://purl.org/dc/elements/1.1/";
declare namespace marc="http://www.loc.gov/MARC21/slim";
declare namespace sr="http://www.openarchives.org/OAI/2.0/static-repository";
declare namespace oai="http://www.openarchives.org/OAI/2.0/";
declare namespace olac="http://www.language-archives.org/OLAC/1.1/";
declare namespace xsi="http://www.w3.org/2001/XMLSchema-instance";
declare namespace dcterms="http://purl.org/dc/terms/";
declare namespace fn="http://www.w3.org/2005/xpath-functions";
declare namespace xsl="http://www.w3.org/1999/XSL/Transform";

declare option saxon:output "method=text";

      
let $repo := doc('file:repository.xml')
let $langs := $repo//oai:record//dc:language

for $lang in $langs
return
          ($lang/text(), '
')


  
  

