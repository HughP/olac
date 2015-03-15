#Metadata  
1.1 Metadata Updated Sep 30, 2011 by garyfsim...@gmail.com
1.1 Metadata | 1.2 Participation | 1.3 Curation | 2.1 Crosswalking | 2.2 Mining | 2.3 Search

##Outcome 1.1: All OLAC repositories should have up-to-date catalogs that contain metadata conforming to best practice.
1.1a Best practice document: Prepare and adopt an OLAC recommendation on metadata best practice, adapting the DC Usage Guidelines and fleshing out published recommendations.

Deliverables: Two OLAC documents
Recommendation: Best Practice Recommendations for Language Resource Description (see http://www.language-archives.org/REC/bpr.html)
Informational Note: OLAC Metadata Usage Guidelines (see http://www.language-archives.org/NOTE/usage.html)
Status: Completed.
1.1b Score cards: Update the automated score card system to conform to best practice recommendations.

Deliverable: An informational note that describes the automated quality score; see http://www.language-archives.org/NOTE/metrics.html
Status: Completed. The quality score has been integrated into the metrics page (deliverable 1.1f below), so that the metrics page for an archive functions as its score card.
1.1c Metadata quality: Identify low-scoring archives and work with them to improve the quality of their metadata.

Deliverable: A page that ranks all participating archives by average metadata quality score.
Status: Completed; the new Comparative Metrics page allows archives to be ranked by average metadata quality: http://www.language-archives.org/metrics/compare.
Deliverable: An automated metadata quality advisor that tells an archive what they need to do to achieve a five-star rating.
Status: Completed; there is a new Analyze button on the Free-Standing OLAC Metadata Service (http://www.language-archives.org/tools/metadata/freestanding.html) which computes the quality score of a record and advises how to improve it. The same analysis is invoked for the Sample Record for each participating archive at http://www.language-archives.org/archives.php
Target: Every archive publishes five-star metadata. (For the present, we must lower the goal to a four-star score since this is the maximum that many archives can receive until the new language resource type vocabulary is implement; see 1.1g below.)
Status: At present, 20 of 40 archives (or 50%) have reached the target level. These account for 68,000 of the 104,000 archived items (or 65%). As the baseline, one archive had four-star metadata and none had five-star.
1.1d Updating archives: Identify OLAC archives whose metadata records have gone stale, and work with them to bring their catalogs up-to-date.

Target: Every archive updates at least once a year.
Status: At present, 23 of 40 archives (or 58%) have updated within the last 12 months. The baseline was 5 of 36.
Deliverable: In version 1.1 of the repositories standard, add a currentAsOf attribute to the olac-archive description of the Identify response and update harvester to read it.
Status: Completed. The reporting of date of last update is implemented in 1.1e and 1.1f as the later of the latest datestamp or currentAsOf.
Target: Every archive has upgraded to version 1.1. (This is actually a prerequisite to achieving the target of every archive updating once a year, since without the currentAsOf attribute they cannot indicate that they are up-to-date when no records have been updated.)
Status: 16 still need to be upgraded. (All pending upgrades are tracked in Google Code as Open issues of Type-Repository.)
1.1e Quarterly reporting: Develop an automated quarterly report to be emailed to curators to inform them of their metadata quality and currency and their usage statistics.

Deliverable: Cron job that emails a quarterly report to each curator and archive admin
Status: Completed; see [specifications](https://github.com/HughP/olac/blob/master/QuarterlyReport.md) for the email report on separate page.
Deliverable: Version 1.1 of repositories standard to add multiple archive participants to the description of the Identify response, in place of the single curator, so that any number of participants from an institution can subscribe to the quarterly report on its archive.
Status: Completed.
1.1f Metrics: Develop metrics for monitoring the size, coverage, quality, and use of the OLAC metadata catalog, and report them on the web site.

Deliverable: Dynamic page that reports metrics on entire collection by default (or on a selected archive). See specifications on separate page.
Status: Completed for all metrics except usage statistics; see http://www.language-archives.org/metrics/
Deliverable: Dynamic page that lists participating archives ranked (from highest to lowest) on the selected metric
Status: Completed; see http://www.language-archives.org/metrics/compare
Deliverable: Dynamic page that lists outstanding integrity problems (especially broken links and invalid metadata values) in the metadata records of a given archive. See specifications on separate page.
Status: Completed; see http://www.language-archives.org/checks
1.1g Language Resource Type: Develop a language resource type vocabulary to replace the linguistic data type vocabulary so that every language resource will have a relevant type category.

Deliverable: A new draft recommendation document.
Status: Thus far, there are only rough notes.

#Participation  
1.2 Participation

##Outcome 1.2: All major language archives have been encouraged to participate in OLAC.
1.2a Non-participating archives: Compile a list of all known non-participating language archives.

Deliverable: A means of listing potential participants and tracking progress.
Status: A social bookmarking approach to maintaining the list was devised and more than 200 web pages were tagged as of interest, including archives and web sites. This task is now moved into the Google Code issue tracker. For each potential provider, we create an issue of Type-Provider and track progress until it is Done or Dropped.
Indicator: Number of archives that have been identified but not yet contacted or agreed to join (Type-Provider with status=New).
Status: 29
1.2b Collaboration: Contact all identified archives and consult with them to develop best strategy for generating their metadata.

Indicator: Number of archives that have been contacted and agreed to join (Type-Provider with status=Accepted).
Status: 8
Indicator: Number of archives that have declined or repeatedly failed to respond (Type-Provider with status=Dropped).
Status: 0
1.2c Scraping: Do automatic scraping of the HTML metadata already published on archive sites to achieve a quick low-accuracy conversion to OLAC metadata.

Deliverable: Respond as needed to scrape identified sites.
1.2d OLAC export: Work with archives that have a catalog database to expose their catalog in OLAC format.

Deliverable: Implement a MARC-to-OLAC crosswalk for use by institutions with MARC catalogs and document it with an OLAC Note.
Status: This has been implemented and used to prepare the catalog for one participant. Two others are in progress.
Deliverable: Develop a reference implementation of a MySQL + PHP static repository generator and document with an OLAC Note.
Status: Source code is available, but a document has not been written.
1.2e Repository editor: Configure an open source XML editor (like XMLmind) to create a static repository editor suitable for use by small archives.

Deliverable: An OLAC Note on using <oXygen/> XML editor to create and maintain a static repository.
Status: In progress; see http://olac.googlecode.com/svn/web/NOTE/oxygen.html.
NB: Another implementation possibility would use a Google Form: http://code.google.com/p/olac/issues/detail?id=169
Indicator for 1.2c to 1.2e: Number of archives that have newly joined using whatever means (Type-Provider with status=Verified).
Status: 3
1.2.f Documentation: Improve the documentation and tools on the OLAC web site for helping new participants to share their metadata with the community.

Deliverable: An FAQ for OLAC Implementers.
Status: Completed; see http://www.language-archives.org/tools/faq.html.
Deliverable: Redesign OLAC home page to clearly communicate to two separate audience groups--individuals looking for language resources or advise about archiving versus institutions who want to add their holdings to the aggregated catalog.
Status: We decided against a wholesale redesign. Instead, there is a prominent world map graphic and like to the new search service at http://search.language-archives.org/ for those who are looking for resources.
Deliverable: Redesign OLAC Tools page to clearly communicate to would-be implementers.
Status: Reorganized, but not wholesale redesign.

#Curation  
1.3 Curation Updated Aug 14, 2011 by garyfsim...@gmail.com
1.1 Metadata | 1.2 Participation | 1.3 Curation | 2.1 Crosswalking | 2.2 Mining | 2.3 Search

##Outcome 1.3: All OLAC repositories conform to current best practices for the long-term curation of their holdings.
1.3a Recommendation: Develop an OLAC recommendation document on best practices for the long-term curation of language archive holdings.

Deliverable: A recommendation aimed at digital language archives. The approach should not be to develop best practice recommendations about archiving practices since professional archiving groups are doing that. Our approach should be to refer our community to that work by others, and then to develop a recommended means of reporting to prospective users a self-assessment of conformance to best practices.
Status: Completed as TAPS: Checklist for Responsible Archiving of Digital Language Resources, an MA thesis by Debbie Chang (Graduate Institute of Applied Linguistics, 2010). It is based on best practice statements by archives community, e.g. [Core Requirements](http://www.crl.edu/?l1=13&l2=58&l3=162%20&l4=92), [TRAC](http://www.crl.edu/?l1=13&l2=58&l3=162&l4=91), [DAF](http://www.dcc.ac.uk/resources/repository-audit-and-assessment/data-asset-framework), [DRAMBORA](http://www.dcc.ac.uk/resources/repository-audit-and-assessment/drambora), [NESTOR](http://nestor.cms.hu-berlin.de/moinwiki/WG_Trusted_Repositories_-_Certification), [Data Seal of Approval](http://www.datasealofapproval.org/en/)
Deliverable: An informational note aimed at individuals who have language resources that need to be archived that advises them on what practices to look for when identified a place to archive their work.
Status: This has taken the form of the TAPS checklist which is part of the above thesis.
1.3b Archive categories: Refine the <olac-archive> description to include more fine-grained categorization of participating "archives" to distinguish those that curate resources from those that do not.

Deliverable: Add an optional <archivalSubmisionPolicy> element to the <olac-archive> description so that participants who are truly archives (as opposed to aggregators or indexers) can identify themselves and describe what they can offer to would-be submitters.
Status: Completed in version 1.1.
Deliverable: A new page on the OLAC site listing all of the actual archives with their submission policies. This page is aimed at individuals who are looking for a place to archive language resources they have created.
Status: Completed, posted at http://www.language-archives.org/submission-policies.html.
Indicator: Number of OLAC participants that have documented their submission policy.
Status: 7.
1.3c Score cards: Incorporate curation practices into OLAC's score card system.

Deliverable: Develop a self assessment tool that will allow archives to report where they are with respect to best practice recommendations.
Status: Completed as the TAPS checklist (see 1.3a above).
Indicator: Number of OLAC participants that have posted a self assessment.
Status: At this point, we have decided against going through with the idea of posting self assessments.
1.3d State-of-the-art assessment: Assess the state of the art with respect to the archival curation of language resources.

Deliverable: A report on the state of the art of language archiving, highlighting what is at risk and offering recommendations.
Status: Incorporated into the thesis listed above under 1.3a, and presented as a [poster](http://www.hrelp.org/events/external/lsa2011/assets/LSA2011_Chang_poster.pdf) at the 2011 LSA symposium on [Metadata in Language Documentation and Description](http://www.hrelp.org/events/external/lsa2011/).

#Crosswalking  
2.1 Crosswalking Updated Sep 30, 2011 by garyfsim...@gmail.com
1.1 Metadata | 1.2 Participation | 1.3 Curation | 2.1 Crosswalking | 2.2 Mining | 2.3 Search

##Outcome 2.1: OLAC is indexing all major repository and library holdings relevant to language documentation and description by crosswalking and enriching existing catalog records.
2.1a Language identification: Develop an automated procedure for finding language names in a catalog record and translating them to an appropriate ISO 639-3 code.

Deliverable: A trained classifier that can classify a metadata record as to ISO 639-3 codes that appear to be relevant to it. See implementation notes.
Status: A rule-based classifier has been implemented.
Deliverable: A data set for training the language classifier, containing alternate names, dialect names, geographic information, and language classification.
Status: A set of data files for training the classifier has been developed. Results are reported in a [conference presentation](http://www.sil.org/~simonsg/presentation/DH%202011.pdf).
2.1b Data type identification: Develop an automated procedure for finding linguistic data type information in a catalog record and translating it to an appropriate OLAC linguistic data type code.

Deliverable: A binary classifier that can classify a metadata record as to whether or not it is a language resource.
Status: Training data has been created based on titles and subject headings of 5 million Library of Congress catalog records (using call numbers to divide them into language resources versus non-language resources). This data has been used to train a maximum entropy classifier (using the MALLET package). Results are reported in a conference presentation.
Deliverable: A multi-way classifier that can classify a metadata record known to be a language resource as to the linguistic data types that appear to be relevant to it.
Status: Training data has been created based on titles, descriptions, and subject headings of 80,000 Library of Congress catalog records of known language resources(using subject headings to sort them into six language resource types). This data has been used to train a maximum entropy classifier (using the MALLET package). Evaluation has shown that the results achieved by this classifier are not yet satisfactory.
2.1c MARC Crosswalk: Develop a crosswalk that transforms a set of MARC catalog records for language resources into an OLAC static repository.

Deliverable: A processor (see specification) that transforms a set of MARC catalog records supplied by a participating archive to OLAC format, and which uses the classifiers developed in 2.1a and 2.1b to add language codes and linguistic data types when they are not available in the original data.
Status: A rule-based crosswalk has been implemented in Python and XSLT; see abstract and poster. The classifiers developed in 2.1a and 2.1b have been integrated.
Deliverable: A static repository for language resources in the GIAL library built from the MARC dataset they have provided.
Status: The rule-based crosswalk gave satisfactory results for this collection and it is now operational; see http://www.language-archives.org/archive/gial.edu.
Deliverable: A static repository for language resources in the National Anthropological Archive built from the MARC dataset they have provided.
Status: The results achieved initially were disappointing in that only 59% of the records had specific language identification in subject headings. It remains to rerun the crosswalk using the newly integrated language identification classifier over titles and evaluate again..
Deliverable: All crosswalk code is in the Subversion repository with an OLAC Note documenting the system so that participating institutions would be able to run it themselves.
Status: The code is in the repository at http://code.google.com/p/olac/source/browse/#svn/src/marc-crosswalk. The document remains to be completed.
2.1d OAI Crosswalk: Develop an OLAC data provider that is a crosswalk for language resource records discovered in all known OAI repositories (over 2400 are registered at http://gita.grainger.uiuc.edu/registry/searchform.asp).

Deliverable: A gateway service that harvests all registered OAI data providers and uses the classifiers developed in 2.1a and 2.1b to identify language resources and crosswalk them to OLAC with metadata enriched to add language codes and linguistic data types.
Status: A version of the OLAC harvester has been created to harvest oai_dc, and 5 million records have been harvested from about 450 repositories. Approximately 22,000 presumed language resources have been identified as reported in a conference presentation.
2.1e Z39.50 Crosswalk: Develop an OLAC data provider that is a crosswalk for language resource records discovered in leading Z39.50 library gateways.

Deliverable: As an alternate strategy we are going to try to give access to library collections through WorldCat..
Status: A proof of concept implementation has been done, because OCLC will not permit WorldCat to be used for discovery purposes.
NB. there is a duplication issue if we actually harvest from multiple libraries; pick a small number of libraries with SRU support. Separate task: can we harvest a listing of books in print? http://code.google.com/p/olac/issues/detail?id=74

#Mining  
2.2 Mining Updated Aug 14, 2011 by garyfsim...@gmail.com
1.1 Metadata | 1.2 Participation | 1.3 Curation | 2.1 Crosswalking | 2.2 Mining | 2.3 Search

##Outcome 2.2: Linguistic web mining services are discovering low density language materials and reliably categorizing it with OLAC vocabularies (out of scope).
(The amount of the grant award was less than the original project budget. In the statement of impact for the reduced award, this task was dropped from the project with the following explanation: With the reduced award we propose to scale back the project by eliminating work on Outcome 2.2. Omitting this task will not jeopardize the success of the other tasks. In the event that progress on other tasks is ahead of schedule we will conduct preliminary experiments in the area of Outcome 2.2.)

2.2a Language identification: Develop an automated procedure for finding low-density language identification from an arbitrary web document, and translating this to an appropriate ISO 639-3 code.

2.2b Language resource type identification: Develop an automated procedure for identifying the language resource type of an arbitrary web document and translating this to an appropriate OLAC linguistic data type code.

work on a definition of language resource
work on a vocabulary of resource types
2.2c Web mining: Generate OLAC metadata records for low-density language resources discovered by linguistic web-mining projects, such as Hughes’ collection of 600,000 low-density language URLs.

#Search  
2.3 Search Updated Aug 14, 2011 by garyfsim...@gmail.com
1.1 Metadata | 1.2 Participation | 1.3 Curation | 2.1 Crosswalking | 2.2 Mining | 2.3 Search

##Outcome 2.3: Web search engines are indexing all OLAC records, so that users who discover language resources using a web search quickly find OLAC records and are drawn to the OLAC site for more precise searching.
2.3a Crawlable HTML: Generate an HTML page for each OLAC metadata record and make them accessible to web crawlers.

Deliverable: Add a new module to the OLAC aggregator to generate an HTML page for every record in the catalog.
Status: Completed; see example.
Deliverable: Add a dynamic page for each archive which lists a hyperlink to the HTML pages for all the records in the archive's catalog.
Status: Completed; see /archive_records/archive-id.
2.3b Synonyms: Add synonyms for all identified linguistic terminology to static HTML pages, so that these pages are more likely to be found in conventional web searches.

Deliverable: Add a dynamically generated page for every ISO 639 language code which contains all known alternate names and dialect names for the language so there is an OLAC page for web searches on these terms to find.
Status: Completed.
Deliverable: Add a dynamically generated page for every linguistic data type that contains all known synonyms so there is an OLAC page for web searches on these terms to find.
Status: Found not to be needed after completing the following deliverable.
Deliverable: To the language pages, add all known synonyms for the linguistic data types that OLAC has indexed for the particular language so that web searches including a language name and a data type will find these pages.
Status: Completed.
2.3c Embedded queries: Enrich metadata record pages with OLAC query links, so that users who discover OLAC records via a Google search result are encouraged to remain on the OLAC site for more precise searching.

Deliverable: The language pages list links to relevant metadata record pages (grouped by linguistic data type) and the metadata record pages treat ISO 630 codes as links to the relevant language page.
Status: Completed.
Deliverable: The linguistic data type pages list links to language pages containing that kind of resource and the metadata record pages treat linguistic data type codes as links to the relevant data type page.
Status: Pages found not to be needed as explained above.
2.3d OAI search services: OLAC is being harvested by major OAI search services (like OAIster and DRIVER) and the simple DC record has a <dc:description> element linking back to the OLAC metadata record page so that users looking for language resources can be drawn into the richer OLAC search environment.

Deliverable: Support the oai_dc format in the data provider side of the OLAC Aggregator; see separate specification.
Status: Implementation completed and documented in an informational note.
Deliverable: Get harvested by OAIster (union catalog of over 20 million OAI records, http://www.oaister.org/).
Status: OAIster has been absorbed into WorldCat, and WorldCat is now harvesting the complete OLAC catalog.
Deliverable: Get harvested by DRIVER.
Status: Not started.
2.3e OLAC search service: Develop a search service that takes advantage of OLAC’s metadata standards to provide easy-to-use precise search over the complete OLAC catalog.

Deliverable: Collaborate with the Digital Library Architecture group in the University of Pennsylvania library to implement a faceted search service for OLAC.
Status: Completed; see http://search.language-archives.org/ which redirects to the service hosted at the Penn library.
Deliverable: Report on the OLAC search service at the 2011 LSA symposium on Metadata in Language Documentation and Description.
Status: Presented as a [poster](http://www.hrelp.org/events/external/lsa2011/assets/LSA2011_BirdSimons_poster.pdf).
