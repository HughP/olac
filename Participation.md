[1.1 Metadata](Metadata.md) | [1.2 Participation](Participation.md) | [1.3 Curation](Curation.md) | [2.1 Crosswalking](Crosswalking.md) | [2.2 Mining](Mining.md) | [2.3 Search](Search.md)

### Outcome 1.2: All major language archives have been encouraged to participate in OLAC. ###

1.2a _Non-participating archives:_ Compile a list of all known non-participating language archives.

  * **Deliverable:** A means of listing potential participants and tracking progress.<br>
<ul><li><b>Status:</b> A <a href='Bookmarking.md'>social bookmarking</a> approach to maintaining the list was devised and more than 200 web pages were tagged as of interest, including archives and web sites. This task is now moved into the Google Code issue tracker. For each potential provider, we create an issue of Type-Provider and track progress until it is Done or Dropped.<br>
</li><li><b>Indicator:</b> Number of archives that have been identified but not yet contacted or agreed to join (<a href='http://code.google.com/p/olac/issues/list?can=2&q=label%3AType-Provider%20status%3ANew'>Type-Provider with status=New</a>).<br>
</li><li><b>Status:</b> 29<br></li></ul>

1.2b <i>Collaboration:</i> Contact all identified archives and consult with them to develop best strategy for generating their metadata.<br>
<br>
<ul><li><b>Indicator:</b> Number of archives that have been contacted and agreed to join (<a href='http://code.google.com/p/olac/issues/list?can=2&q=label%3AType-Provider+status%3AAccepted'>Type-Provider with status=Accepted</a>).<br>
</li><li><b>Status:</b> 8<br>
</li><li><b>Indicator:</b> Number of archives that have declined or repeatedly failed to respond (<a href='http://code.google.com/p/olac/issues/list?can=1&q=label%3AType-Provider+status%3ADropped'>Type-Provider with status=Dropped</a>).<br>
</li><li><b>Status:</b> 0<br></li></ul>

1.2c <i>Scraping:</i> Do automatic scraping of the HTML metadata already published on archive sites to achieve a quick low-accuracy conversion to OLAC metadata.<br>
<ul><li><b>Deliverable:</b> Respond as needed to scrape identified sites.<br></li></ul>

1.2d <i>OLAC export:</i> Work with archives that have a catalog database to expose their catalog in OLAC format.<br>
<ul><li><b>Deliverable:</b> Implement a MARC-to-OLAC crosswalk for use by institutions with MARC catalogs and document it with an OLAC Note.<br>
</li><li><b>Status:</b> This has been implemented and used to prepare the catalog for one participant. Two others are in progress.<br>
</li><li><b>Deliverable:</b> Develop a reference implementation of a MySQL + PHP static repository generator and document with an OLAC Note.<br>
</li><li><b>Status:</b> Source code is available, but a document has not been written.<br></li></ul>

1.2e <i>Repository editor:</i> Configure an open source XML editor (like XMLmind) to create a static repository editor suitable for use by small archives.<br>
<br>
<ul><li><b>Deliverable:</b> An OLAC Note on using <code>&lt;oXygen/&gt;</code> XML editor to create and maintain a static repository.<br>
</li><li><b>Status:</b> In progress; see <a href='http://olac.googlecode.com/svn/web/NOTE/oxygen.html'>http://olac.googlecode.com/svn/web/NOTE/oxygen.html</a>.<br></li></ul>

<ul><li><b>NB:</b> Another implementation possibility would use a Google Form: <a href='http://code.google.com/p/olac/issues/detail?id=169'>http://code.google.com/p/olac/issues/detail?id=169</a></li></ul>

<ul><li><b>Indicator for 1.2c to 1.2e:</b> Number of archives that have newly joined using whatever means (<a href='http://code.google.com/p/olac/issues/list?can=1&q=label%3AType-Provider+status%3AVerified'>Type-Provider with status=Verified</a>).<br>
</li><li><b>Status:</b> 3<br></li></ul>

1.2.f <i>Documentation:</i> Improve the documentation and tools on the OLAC web site for helping new participants to share their metadata with the community.<br>
<br>
<ul><li><b>Deliverable:</b> An FAQ for OLAC Implementers.<br>
</li><li><b>Status:</b> Completed; see <a href='http://www.language-archives.org/tools/faq.html'>http://www.language-archives.org/tools/faq.html</a>.<br>
</li><li><b>Deliverable:</b> Redesign OLAC home page to clearly communicate to two separate audience groups--individuals looking for language resources or advise about archiving versus institutions who want to add their holdings to the aggregated catalog.<br>
</li><li><b>Status:</b> We decided against a wholesale redesign. Instead, there is a prominent world map graphic and like to the new search service at <a href='http://search.language-archives.org/'>http://search.language-archives.org/</a> for those who are looking for resources.<br>
</li><li><b>Deliverable:</b> Redesign OLAC Tools page to clearly communicate to would-be implementers.<br>
</li><li><b>Status:</b> Reorganized, but not wholesale redesign.<br>