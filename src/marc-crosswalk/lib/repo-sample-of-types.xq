xquery version "1.0";  
   
   (: repo-sample-of-types.xq
         G. Simons, Aug 2009
      Extracts a subset of records of each olac:resource-type  
      from a repository for evaluation purposes.
      Parameters:
         Set $repo to the file path for the repository to sample
         Set $target to the number of records to extract per type
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

      
let $repo := doc('file:../scriblio07/scriblio_repository.xml')
(: let $repo := doc('file:../gial_sample/repository.xml')  :)

let $target := 100

return
  <sr:Repository>
  <oai:repositoryName>{$repo/*/sr:Identify/oai:repositoryName/text()}:
  Sample of types</oai:repositoryName>
  {
   let $types :=
fn:distinct-values($repo//oai:record/*/*/dc:type[@xsi:type='olac:resource-type']/@olac:code)
   for $type in $types
   return
   
     <sr:ListRecords metadataPrefix="{$type}">
     {
         let $recs := $repo//oai:record[*/*/dc:type[@olac:code=$type]]
         let $total := count($recs)
         let $skip := if ($total > $target)
             then floor($total div $target)
             else 1

         for $rec at $pos in $recs
         where $pos mod $skip = 0

          return
          ($rec)
     }
     </sr:ListRecords>
  }
     <sr:ListRecords metadataPrefix="No_type">
     {
         let $recs :=
         $repo//oai:record[*/olac:olac[not(dc:type[@olac:code])]]
         let $total := count($recs)
         let $skip := if ($total > $target)
             then floor($total div $target)
             else 1

         for $rec at $pos in $recs
         where $pos mod $skip = 0

          return
          ($rec)
     }
     </sr:ListRecords>
  </sr:Repository>
  
  

