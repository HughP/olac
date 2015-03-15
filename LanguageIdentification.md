#LanguageIdentification  
##2.1a Language identification Updated Sep 30, 2009 by haepal
Implementation notes for task 2.1a, "Language identification"
Develop an automated procedure for finding language identification in a catalog record and translating it to an appropriate ISO 639-3 code.
The following are rough notes. Eventually this needs to be developed into a full specification:

store a table that maps record identifiers to 3-letter codes
use an outer join with a fixed value field so we know the code was guessed, and show this on the item page
for oai_dc output include a provenance note indicating both sources (provider, OLAC) and specify the vocabularies where we're inferring the coded value (but don't try to communicate this information inside the DC record itself)
link to the item from the OLAC page for this language there should be an indication of uncertainty