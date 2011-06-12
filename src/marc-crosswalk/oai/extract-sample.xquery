xquery version "1.0";  
   
(:    extract-sample.xquery 
      G. Simons, 4 June 2011

Extracts a "random" sample of classification results by taking
every nth item. 

It takes $target1 items from repository.xml (positive results)
and $target2 items from repository-inverse.xml (negative results).

You must first figure out the target number of positive and negative
results needed by computing the total sample size needed and
multiplying that by the known proportion positive and negative
results.  For sample size, use:

http://www.surveysystem.com/sscalc.htm

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

declare function local:vocab-report($label, $uses, $recs, $total-records) {
     <tr><td>{$label}</td>
           <td align="center">{count(fn:distinct-values($uses))}</td>
           <td align="center">{count($uses)}</td>
           <td align="center">{round-half-to-even(count($uses) div $total-records, 2)}</td>
           <td align="center">{count($recs)}</td>
           <td align="center">{round(count($recs) div $total-records * 100)}%</td>
     </tr> };
     
      
let $repo1 := doc('file:repository.xml')
let $repo2 := doc('file:repository-inverse.xml')

         let $recs1 := $repo1//oai:record
         let $total1 := count($recs1)

         let $recs2 := $repo2//oai:record
         let $total2 := count($recs2)

let $target1 := 246
let $target2 := 466

return
  <sr:Repository>
  <oai:repositoryName>{$repo1/*/sr:Identify/oai:repositoryName/text()}:
  Sample of {$target1},{$target2} from {$total1},{$total2}</oai:repositoryName>
   
     <sr:ListRecords metadataPrefix="positive">
     {
         let $skip := if ($total1 > $target1)
             then floor($total1 div $target1)
             else 1
             
             for $rec at $pos in $recs1
         where $pos mod $skip = 0

          return
          ($rec)
          
     (:    return (<counts>{$total}, {$skip}</counts>)   :)
         
     } 
     </sr:ListRecords>
     
     
     <sr:ListRecords metadataPrefix="negative">
     {
        let $skip := if ($total2 > $target2)
             then floor($total2 div $target2)
             else 1

         for $rec at $pos in $recs2
         where $pos mod $skip = 0

          return
          ($rec)
     }
     </sr:ListRecords>
  </sr:Repository>
  
  

