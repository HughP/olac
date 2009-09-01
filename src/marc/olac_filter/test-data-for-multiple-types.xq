xquery version "1.0";  

(: test-data-for-multiple-types.xq
       G. Simons, 31 Aug 2009
   Test data for records with multiple resource types.
   ID, tab, space separated types, tab, space separated fields
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


let $repo := doc('file:scriblio_repository.xml')
let $tab := "&#9;"
let $nl := "&#10;"

let $recs :=
$repo//oai:record[oai:metadata/olac:olac[count(dc:type[@xsi:type='olac:resource-type']) > 1]]
for $rec in $recs
  
  return
     ($rec/oai:header/oai:identifier/text(),
      $tab,
      
      for $type in
      $rec//olac:olac/dc:type[@xsi:type='olac:resource-type']/string(@olac:code)
      order by $type
      return
     ($type), (: this inherently gets a space after it :)
      $tab,

   for $field in $rec//olac:olac/*[. != '']
   where contains('contributor creator 
  coverage spatial temporal
  description abstract tableOfContents
  publisher source  
  title alternative', local-name($field) )
  or $field/self::dc:subject[@xsi:type != 'dcterms:DDC' and @xsi:type != 'dcterms:LCC']
    
   return
     ($field/text(), " "), $nl

  
  )

