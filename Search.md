[1.1 Metadata](Metadata.md) | [1.2 Participation](Participation.md) | [1.3 Curation](Curation.md) | [2.1 Crosswalking](Crosswalking.md) | [2.2 Mining](Mining.md) | [2.3 Search](Search.md)

### Outcome 2.3: Web search engines are indexing all OLAC records, so that users who discover language resources using a web search quickly find OLAC records and are drawn to the OLAC site for more precise searching. ###

2.3a _Crawlable HTML:_ Generate an HTML page for each OLAC metadata record and make them accessible to web crawlers.

  * **Deliverable:** Add a new module to the OLAC aggregator to generate an HTML page for every record in the catalog.<br>
<ul><li><b>Status:</b> Completed; see <a href='http://www.language-archives.org/item/oai:clal.cornell.edu:clal1'>example</a>.<br>
</li><li><b>Deliverable:</b> Add a dynamic page for each archive which lists a hyperlink to the HTML pages for all the records in the archive's catalog.<br>
</li><li><b>Status:</b> Completed; see <a href='http://www.language-archives.org/archive_records/'>/archive_records/archive-id</a>.<br></li></ul>

2.3b <i>Synonyms:</i> Add synonyms for all identified linguistic terminology to static HTML pages, so that these pages are more likely to be found in conventional web searches.<br>
<br>
<ul><li><b>Deliverable:</b> Add a dynamically generated page for every ISO 639 language code which contains all known alternate names and dialect names for the language so there is an OLAC page for web searches on these terms to find.<br>
</li><li><b>Status:</b> Completed.<br>
</li><li><b>Deliverable:</b> Add a dynamically generated page for every linguistic data type that contains all known synonyms so there is an OLAC page for web searches on these terms to find.<br>
</li><li><b>Status:</b> Found not to be needed after completing the following deliverable.<br>
</li><li><b>Deliverable:</b> To the language pages, add all known synonyms for the linguistic data types that OLAC has indexed for the particular language so that web searches including a language name and a data type will find these pages.<br>
</li><li><b>Status:</b> Completed.<br></li></ul>

2.3c <i>Embedded queries:</i> Enrich metadata record pages with OLAC query links, so that users who discover OLAC records via a Google search result are encouraged to remain on the OLAC site for more precise searching.<br>
<br>
<ul><li><b>Deliverable:</b> The language pages list links to relevant metadata record pages (grouped by linguistic data type) and the metadata record pages treat ISO 630 codes as links to the relevant language page.<br>
</li><li><b>Status:</b> Completed.<br>
</li><li><b>Deliverable:</b> The linguistic data type pages list links to language pages containing that kind of resource and the metadata record pages treat linguistic data type codes as links to the relevant data type page.<br>
</li><li><b>Status:</b> Pages found not to be needed as explained above.<br></li></ul>

2.3d <i>OAI search services:</i> OLAC is being harvested by major OAI search services (like OAIster and DRIVER) and the simple DC record has a <code>&lt;dc:description&gt;</code> element linking back to the OLAC metadata record page so that users looking for language resources can be drawn into the richer OLAC search environment.<br>
<br>
<ul><li><b>Deliverable:</b> Support the oai_dc format in the data provider side of the OLAC Aggregator; see separate <a href='DisplayFormatAndDCCrosswalk.md'>specification</a>.<br>
</li><li><b>Status:</b> Implementation completed and documented in an <a href='http://www.language-archives.org/NOTE/olac_display.html'>informational note</a>.<br>
</li><li><b>Deliverable:</b> Get harvested by OAIster (union catalog of over 20 million OAI records, <a href='http://www.oaister.org/'>http://www.oaister.org/</a>).<br>
</li><li><b>Status:</b> OAIster has been absorbed into WorldCat, and WorldCat is now harvesting the complete OLAC catalog.<br>
</li><li><b>Deliverable:</b> Get harvested by DRIVER.<br>
</li><li><b>Status:</b> Not started.<br></li></ul>

2.3e <i>OLAC search service:</i> Develop a search service that takes advantage of  OLAC’s metadata standards to provide easy-to-use precise search over the complete OLAC catalog.<br>
<ul><li><b>Deliverable:</b> Collaborate with the Digital Library Architecture group in the University of Pennsylvania library to implement a faceted search service for OLAC.<br>
</li><li><b>Status:</b> Completed; see <a href='http://search.language-archives.org/'>http://search.language-archives.org/</a> which redirects to the service hosted at the Penn library.<br>
</li><li><b>Deliverable:</b> Report on the OLAC search service at the 2011 LSA symposium on <a href='http://www.hrelp.org/events/external/lsa2011/'>Metadata in Language Documentation and Description</a>.<br>
</li><li><b>Status:</b> Presented as a <a href='http://www.hrelp.org/events/external/lsa2011/assets/LSA2011_BirdSimons_poster.pdf'>poster</a>.