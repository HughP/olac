[1.1 Metadata](Metadata.md) | [1.2 Participation](Participation.md) | [1.3 Curation](Curation.md) | [2.1 Crosswalking](Crosswalking.md) | [2.2 Mining](Mining.md) | [2.3 Search](Search.md)

### Outcome 2.1: OLAC is indexing all major repository and library holdings relevant to language documentation and description by crosswalking and enriching existing catalog records. ###

2.1a _Language identification:_ Develop an automated procedure for finding language names in a catalog record and translating them to an appropriate ISO 639-3 code.

  * **Deliverable:** A trained classifier that can classify a metadata record as to ISO 639-3 codes that appear to be relevant to it. See [implementation notes](LanguageIdentification.md).<br>
<ul><li><b>Status:</b> A rule-based classifier has been implemented.<br>
</li><li><b>Deliverable:</b> A data set for training the language classifier, containing alternate names, dialect names, geographic information, and language classification.<br>
</li><li><b>Status:</b> A set of data files for training the classifier has been developed. Results are reported in a <a href='http://www.sil.org/~simonsg/presentation/DH%202011.pdf'>conference presentation</a>.<br></li></ul>

2.1b <i>Data type identification:</i> Develop an automated procedure for finding linguistic data type information in a catalog record and translating it to an appropriate OLAC linguistic data type code.<br>
<br>
<ul><li><b>Deliverable:</b> A binary classifier that can classify a metadata record as to whether or not it is a language resource.<br>
</li><li><b>Status:</b> Training data has been created based on titles and subject headings of 5 million Library of Congress catalog records (using call numbers to divide them into language resources versus non-language resources). This data has been used to train a maximum entropy classifier (using the MALLET package). Results are reported in a <a href='http://www.sil.org/~simonsg/presentation/DH%202011.pdf'>conference presentation</a>.<br>
</li><li><b>Deliverable:</b> A multi-way classifier that can classify a metadata record known to be a language resource as to the linguistic data types that appear to be relevant to it.<br>
</li><li><b>Status:</b> Training data has been created based on titles, descriptions, and subject headings of 80,000 Library of Congress catalog records of known language resources(using subject headings to sort them into six language resource types). This data has been used to train a maximum entropy classifier (using the MALLET package). Evaluation has shown that the results achieved by this classifier are not yet satisfactory.<br></li></ul>

2.1c <i>MARC Crosswalk:</i> Develop a crosswalk that transforms a set of MARC catalog records for language resources into an OLAC static repository.<br>
<br>
<ul><li><b>Deliverable:</b> A processor (see <a href='http://code.google.com/p/olac/wiki/MARC'>specification</a>) that transforms a set of MARC catalog records supplied by a participating archive to OLAC format, and which uses the classifiers developed in 2.1a and 2.1b to add language codes and linguistic data types when they are not available in the original data.<br>
</li><li><b>Status:</b> A rule-based crosswalk has been implemented in Python and XSLT; see <a href='http://www.sil.org/~simonsg/reprint/jcdl2009.pdf'>abstract</a> and <a href='http://www.sil.org/~simonsg/poster/MARC-to-OLAC.pdf'>poster</a>. The classifiers developed in 2.1a and 2.1b have been integrated.<br>
</li><li><b>Deliverable:</b> A static repository for language resources in the GIAL library built from the MARC dataset they have provided.<br>
</li><li><b>Status:</b> The rule-based crosswalk gave satisfactory results for this collection and it is now operational; see <a href='http://www.language-archives.org/archive/gial.edu'>http://www.language-archives.org/archive/gial.edu</a>.<br>
</li><li><b>Deliverable:</b> A static repository for language resources in the National Anthropological Archive built from the MARC dataset they have provided.<br>
</li><li><b>Status:</b> The results achieved initially were disappointing in that only 59% of the records had specific language identification in subject headings. It remains to rerun the crosswalk using the newly integrated language identification classifier over titles and evaluate again..<br>
</li><li><b>Deliverable:</b> All crosswalk code is in the Subversion repository with an OLAC Note documenting the system so that participating institutions would be able to run it themselves.<br>
</li><li><b>Status:</b> The code is in the repository at <a href='http://code.google.com/p/olac/source/browse/#svn/src/marc-crosswalk'>http://code.google.com/p/olac/source/browse/#svn/src/marc-crosswalk</a>. The document remains to be completed.<br></li></ul>

2.1d <i>OAI Crosswalk:</i> Develop an OLAC data provider that is a crosswalk for language resource records discovered in all known OAI repositories (over 2400 are registered at <a href='http://gita.grainger.uiuc.edu/registry/searchform.asp'>http://gita.grainger.uiuc.edu/registry/searchform.asp</a>).<br>
<br>
<ul><li><b>Deliverable:</b> A gateway service that harvests all registered OAI data providers and uses the classifiers developed in 2.1a and 2.1b to identify language resources and crosswalk them to OLAC with metadata enriched to add language codes and linguistic data types.<br>
</li><li><b>Status:</b> A version of the OLAC harvester has been created to harvest oai_dc, and 5 million records have been harvested from about 450 repositories. Approximately 22,000 presumed language resources have been identified as reported in a <a href='http://www.sil.org/~simonsg/presentation/DH%202011.pdf'>conference presentation</a>.<br></li></ul>

2.1e <i>Z39.50 Crosswalk:</i> Develop an OLAC data provider that is a crosswalk for language resource records discovered in leading Z39.50 library gateways.<br>
<br>
<ul><li><b>Deliverable:</b> As an alternate strategy we are going to try to give access to library collections through WorldCat..<br>
</li><li><b>Status:</b> A proof of concept implementation has been done, because OCLC will not permit WorldCat to be used for discovery purposes.<br>
</li><li>
NB. there is a duplication issue if we actually harvest from multiple libraries; pick a small number of libraries with SRU support. Separate task: can we harvest a listing of books in print? <a href='http://code.google.com/p/olac/issues/detail?id=74'>http://code.google.com/p/olac/issues/detail?id=74</a>