Purpose: this collection of scripts is used to scrape worldcat search result pages with the intent of determining whether a subject search for a particular language has results in worldcat or not.  The results of this scrape, including the number of results for each search are used to create an OLAC static repository of worldcat search results, with the number of hits being the dc:extent of the item (search results page).

Steps:

1) Export out of Joan's Access DB a two column tab-delimited file of 1) language name (usually without appending the word "language") and 2) the ISO639-3 language code, one language per line.  The file should be named lcsh_map.tab

A sample line might look like this (replace the <tab> with an actual tab):
Abo (Cameroon) <tab> abb

Note: when I exported from Access, the encoding was set to latin-1, although I wish it were set to UTF-8.

2) run wc_grab.py
This script assumes the existence of the lcsh_map.tab file and produces a similar file called lcsh_hits_map.tab, a tab-delimited file with 4 column output:
- subject heading
- iso code
- number of hits for that search
- query string

3) run wc_tab2repository.py
This script assumes the existence of the lcsh_hit_map.tab file and produces a file called olac_recs.xml, which is the body of an OLAC static repository.  The OLAC record can be customized in the wc_olac_record.tmpl file.

4) concat the repository pieces together
on the command line:
cat wc_olac_header.xml olac_recs.xml wc_olac_footer.xml > wcrepository.xml
