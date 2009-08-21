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


let $repo := doc('file:scriblio_repository.xml')
let $tab := "&#9;"
let $nl := "&#10;"

  for $rec at $pos in $repo//oai:record
   where $rec[oai:metadata/olac:olac/dc:type[@xsi:type='olac:resource-type']]
  
  return
     ($pos, $tab, "id", $tab, $rec/oai:header/oai:identifier/text(),
     $nl,

   for $type in
   $rec//olac:olac/dc:type[@xsi:type='olac:resource-type']/@olac:code
   return
     ($pos, $tab, "target", $tab, $type, $nl),

   for $field in $rec//olac:olac/*
   return
     ($pos, $tab, $field/local-name(), $tab, $field/text(), $nl)

  
  )

