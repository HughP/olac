/**
*
*	- Archive Report Cards
*
*/

-----------
I. OVERVIEW
-----------

This package contains a tool to create report cards on the quality of 
metadata on a per archive basis.

It requires the creation of additional tables in the OLAC database containing
record scores and metadata element usage.  The instructions for installation 
describe how to set up the report cards. 

----------------
II. REQUIREMENTS
----------------

The system uses MySQL and PHP technologies.  It is assumed that the OLAC 
Harvester and Aggregator (available from olac.sf.net) are installed to harvest
OLAC metadata into a MySQL database.

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

Once the archive report cards are generated (as in step 6 in the INSTALL
document) reports are viewed using reports/archiveReportCard.php. If not
not generated, they can be created dynamically using archiveReport.php

