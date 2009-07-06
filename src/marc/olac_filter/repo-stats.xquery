xquery version "1.0";  
  
declare namespace dc="http://purl.org/dc/elements/1.1/";
declare namespace marc="http://www.loc.gov/MARC21/slim";
declare namespace sr="http://www.openarchives.org/OAI/2.0/static-repository";
declare namespace oai="http://www.openarchives.org/OAI/2.0/";
declare namespace olac="http://www.language-archives.org/OLAC/1.1/";
declare namespace xsi="http://www.w3.org/2001/XMLSchema-instance";
declare namespace dcterms="http://purl.org/dc/terms/";

let $repo := doc('/db/olac/naa.olac.xml')
let $recs := $repo//oai:record
return
  <summary>
     <records>{count($recs)}</records>
     <content-language>{count($recs//olac:olac[dc:language[@olac:code]])}</content-language>
     <subject-language>{count($recs//olac:olac[dc:subject[@xsi:type='olac:language']])}</subject-language>
     <linguistic-field>{count($recs//olac:olac[dc:subject[@xsi:type='olac:linguistic-field']])}</linguistic-field>
     <resource-type>{count($recs//olac:olac[dc:type[@xsi:type='olac:linguistic-type']])}</resource-type>
     <discourse-type>{count($recs//olac:olac[dc:type[@xsi:type='olac:discourse-type']])}</discourse-type>
  </summary>
  

