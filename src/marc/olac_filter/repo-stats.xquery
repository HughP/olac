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

declare function local:uses-report($label, $uses, $total-records) {
     <tr><td>{$label}</td>
           <td align="center">{count($uses)}</td>
           <td align="center">{round(count($uses) div $total-records * 100) div 100}</td>
           <td align="center">{count(fn:distinct-values($uses))}</td>
     </tr> };
     
declare function local:precision-report($label, $recs, $total-records) {
     <tr><td>{$label}</td>
           <td align="center">{count($recs)}</td>
           <td align="center">{round(count($recs) div $total-records * 100)}%</td>
     </tr> };
     
let $repo := doc('/db/olac/gial09.olac.xml')
let $repo-name := $repo/*/sr:Identify/oai:repositoryName/text()
let $recs := $repo//oai:record
let $total := count($recs)

let $cont-langs := $recs//dc:language[@xsi:type='olac:language']/@olac:code
let $subj-langs := $recs//dc:subject[@xsi:type='olac:language']/@olac:code
let $ling-types := $recs//dc:type[@xsi:type='olac:linguistic-type']/@olac:code
let $ling-fields := $recs//dc:subject[@xsi:type='olac:linguistic-field']/@olac:code
let $part-roles := $recs//*[@xsi:type='olac:role']/@olac:code
let $disc-types := $recs//dc:type[@xsi:type='olac:discourse-type']/@olac:code

let $cont-lang-recs := $recs//olac:olac[dc:language[@olac:code]]
let $subj-lang-recs := $recs//olac:olac[dc:subject[@xsi:type='olac:language']]
let $ling-type-recs := $recs//olac:olac[dc:type[@xsi:type='olac:linguistic-type']]
let $ling-field-recs := $recs//olac:olac[dc:subject[@xsi:type='olac:linguistic-field']]
let $part-role-recs := $recs//olac:olac[*[@xsi:type='olac:role']]
let $disc-type-recs := $recs//olac:olac[dc:type[@xsi:type='olac:discourse-type']]

return
  <xhtml>
  <head>
  <title>{$repo-name}</title>
  </head>
  <body>
     <hr/>
     <i>Metadata enrichment report for:</i><br/>
     <h1>{$repo-name}</h1>
     <hr/>
     <p align="center">Total records: {$total}</p>
     <h3>Use of OLAC controlled vocabularies</h3>
     <blockquote>
     <table cellpadding="6">
     <tr><th align="left">Vocabulary</th><th>Total uses</th><th>Per record</th><th>Distinct values</th></tr>
     {local:uses-report("Content language", $cont-langs, $total)}
     {local:uses-report("Subject language", $subj-langs, $total)}
     {local:uses-report("Resource types", $ling-types, $total)}
     {local:uses-report("Linguistic fields", $ling-fields, $total)}
     {local:uses-report("Participant roles", $part-roles, $total)}
     {local:uses-report("Discourse types", $disc-types, $total)}
     </table>
     </blockquote>
     <h3>Precision of records</h3>
     <blockquote>
     <table cellpadding="6">
     <tr><th align="left">Vocabulary</th><th>Records</th><th>Per cent</th></tr>
     {local:precision-report("Content language", $cont-lang-recs, $total)}
     {local:precision-report("Subject language", $subj-lang-recs, $total)}
     {local:precision-report("Resource types", $ling-type-recs, $total)}
     {local:precision-report("Linguistic fields", $ling-field-recs, $total)}
     {local:precision-report("Participant roles", $part-role-recs, $total)}
     {local:precision-report("Discourse types", $disc-type-recs, $total)}
     </table>
     </blockquote>
  </body>
  </xhtml>
  
  

