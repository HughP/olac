/**
*
* 	- Keyword Search of OLAC Records
*	- Archive Report Cards
*
*/

-----------
I. OVERVIEW
-----------

This package contains a search engine over OLAC records and a service to
create report cards on the quality of metadata on a per archive basis.

Both require the creation of additional tables in the OLAC database containing
record scores and metadata element usage. In addition, the search engine
requires tables containing Google search terms, soundex data and Ethnologue
data. The instructions for installation describe how to set up both
the search engine and the report card services.

----------------
II. REQUIREMENTS
----------------

The search engine and the archive report cards use MySQL and PHP technologies.
It is assumed that there the OLAC Harvester and Aggregator (available from
olac.sf.net) are installed to harvest OLAC metadata into a MySQL database.

The display of archive report cards used the GD libraries, which require that
PHP is configured using the --with-gd option. If the GD libraries are not
installed, the report card display graphs using simple HTML tables.

----------------
III. INSTALLATION
----------------

See INSTALL for details on installation.

---------
IV. USAGE
---------

The interface to searching the OLAC database is in 
search/search.php.

Once the archive report cards are generated (as in step 7 in the INSTALL
document) reports are viewed using reports/archiveReportCard.php. If not
not generated, they can be created dynamically using archiveReport.php

