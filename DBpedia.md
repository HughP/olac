# Introduction #

This page gives specifications for developing an OLAC data provider that provides an index by language code to all of the Wikipedia articles about languages.  This will be fairly straightforward since Wikipedia already uses its Infobox technology to identify any article that is about a language and to assign the corresponding ISO 639-3 code. Here is the spec for the language infobox template:

> http://en.wikipedia.org/wiki/Template:Infobox_Language

One way to harvest these is through the DBpedia which has built a huge Linked Data (i.e. RDF) data set based on all the structured information in infoboxes.  "Language" is a top-level concept in the DBpedia ontology:

> http://dbpedia.org/ontology/Language

For instance, the following SPARQL query (at http://dbpedia.org/sparql) lists the language concept URIs with their Wikipedia page URL and ISO code:

```
select ?language, ?page, ?code
where {
   ?language a dbpedia-owl:Language.
   ?language foaf:page ?page.
   ?language dbpprop:iso ?code.
}
```

Still to be solved: Why aren't we seeing property names that distinguish part 1, 2, and 3 codes? This query only returns 1000 hits (as can be seen by returning a spreadsheet).  How do we get them all?

# Deliverable #

A process that can be periodically rerun to create a static repository that is an index of Wikipedia articles about languages.  Each record will have a 

&lt;dc:identifier&gt;

 with the URL of the Wikipedia article, and a 

&lt;dc:subject&gt;

 with the three-letter language code. There could also be a 

&lt;dc:identifier&gt;

 with the corresponding !DBpedia resource URL. As many other metadata elements as can be supplied should also be included.

# A scraping approach #

Rather than harvesting triples from DBpedia, another possible approach could be to scrape the Wikipedia site beginning with the page:

> http://en.wikipedia.org/wiki/Category:Languages_by_country

We could recursively follow links and make records for pages that have a Language Infobox on them.