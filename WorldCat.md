#WorldCat  
Specification for a metasearch data provider based on WorldCat Updated Jan 8, 2010 by garyfsim...@gmail.com
Introduction
WorldCat (http://www.worldcat.org/) provides web search access to OCLC's union catalog containing over 1.4 billion items from over 10,000 libraries worldwide. The terms of use (http://www.oclc.org/worldcat/policies/terms/) prohibit the "use of bots ... to mine or harvest material amounts of Data" and thus we may not offer a metadata service like the typical OLAC data provider.

Rather, we propose to develop a "metasearch" service. Our service would create a static repository with a name like "WorldCat Language Resource Search". Each record would include a URL in a dc:description element that encodes a search query for a particular kind of language resource in a particular language. Thus a user who queries OLAC about that language will be presented with the link to a WorldCat search that will retrieve results about that language. The service would test queries in advance so that only queries that are known to return results will be cataloged within OLAC records.

Query construction
The WorldCat advanced search page (http://www.worldcat.org/advancedsearch) permits searching by subject. We can find resources about a particular language by searching specifically for its standardized Library of Congress Subject Heading. Furthermore, standard subject headings have subfields that designate the type of resource. Thus, the following three subject headings for the Lau language of Solomon Islands (ISO639-3 code: llu) correspond to the three OLAC linguistic types (primary_text, lexicon, langauge_description):

Lau language--Texts
Lau language--Dictionaries
Lau language--Grammar
Searching for these with the advanced search page reveals that a prefix of "su:" is appended to indicate subject search. Also, the subject heading must be placed in quotes to ensure that the exact sequence is matched in a single subject heading. Otherwise, each of the words need only occur somewhere in one of the subject headings. After URL encoding the colon, space, and quotes, the following ends up being the URL to search for the first subject heading listed above:

http://www.worldcat.org/search?q=su%3A%22Lau+language--Texts%22

Clicking the above link reveals that WorldCat retrieves 14 items with that subject heading. Clicking on any one item generates a report showing all the metadata for the item plus a list of libraries that have the item (listed in order of increasing distance from the user's location).

In fact there are multiple subfields that could be relevant to a particular data type. For instance, the following have been observed as candidates for the OLAC type "lexicon":

Dictionaries
Glossaries, Vocabularies, etc.
Terms and Phrases
Vocabulary
Metadata records
Give specifications for the records to be generated for the static repository

Implementation
Give other specifications for the program that implements the service

Resources
Documentation on the WorldCat search API:

http://worldcat.org/devnet/wiki/SearchAPIDetails
Documentation on the indexes on the WorldCat database for Z39.50 searching:

http://www.oclc.org/support/documentation/firstsearch/z3950/z3950_databases/specs/worldcat.htm
