xquery version "1.0";  
   
(:    count-records.xquery 
      G. Simons, 4 June 2011

Counts the records in repository.xml. 

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
let $recs := count($repo//oai:record)

return
          ($recs, ' of 71,238 = ', $recs div 71238)


  
  

