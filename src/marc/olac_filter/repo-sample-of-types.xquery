xquery version "1.0";  
   
declare namespace dc="http://purl.org/dc/elements/1.1/";
declare namespace marc="http://www.loc.gov/MARC21/slim";
declare namespace sr="http://www.openarchives.org/OAI/2.0/static-repository";
declare namespace oai="http://www.openarchives.org/OAI/2.0/";
declare namespace olac="http://www.language-archives.org/OLAC/1.1/";
declare namespace xsi="http://www.w3.org/2001/XMLSchema-instance";
declare namespace dcterms="http://purl.org/dc/terms/";
declare namespace fn="http://www.w3.org/2005/xpath-functions";
declare namespace xsl="http://www.w3.org/1999/XSL/Transform";

declare function local:vocab-report($label, $uses, $recs, $total-records) {
     <tr><td>{$label}</td>
           <td align="center">{count(fn:distinct-values($uses))}</td>
           <td align="center">{count($uses)}</td>
           <td align="center">{round-half-to-even(count($uses) div $total-records, 2)}</td>
           <td align="center">{count($recs)}</td>
           <td align="center">{round(count($recs) div $total-records * 100)}%</td>
     </tr> };
     
      
(: let $repo := doc('file:scriblio_repository_part1.xml') :)
let $repo := doc('file:gial09.olac.xml') 

let $target := 100

return
  <sr:Repository>
  <oai:repositoryName>{$target} records of each type</oai:repositoryName>
  {
   let $types :=
fn:distinct-values($repo//oai:record/*/*/dc:type[@xsi:type='olac:linguistic-type']/@olac:code)
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
  </sr:Repository>
  
  

