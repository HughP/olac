
MARC-to-OLAC CROSSWALK

Last updated: 20 March 2009


This workbench for testing the MARC-to-OLAC crosswalk is implemented as a set of XSLT transformations driven by a Cocoon sitemap. To run the workbench, access the following URL in a browser:

    http://localhost:8080/{cocoon-mount-folder}/crosswalk/

Simply click on the links to exercise all of the functionality supported in the workbench.


1. Adding a new data set

A data set must be a MARC XML Collection.  That is, the root element is <collection xmlns="http://www.loc.gov/MARC21/slim"> and contains a set of <record> elements.

To add a new data set to the workbench, simply place the XML file in the /MARC_data/ folder.  Refresh the home page and it will add a link for the new data set.


2. Adding a new data filter

The crosswalk system supports a two-stage filter for reducing the original MARC collection to exactly the set of records that are language resources for export to an OLAC repository.  To create a new filter, make a copy of crosswalk/filter-sample.xml in the same folder. When you rename it, the name must begin with "filter-" in order to be recognized as a filter by the sitemap.

The workbench does not yet automatically detect filters, so in order to show up in the workbench, your new filter must be added explicitly to crosswalk/index2.xhtm. Open that file with an editor and make a copy of the <tr> at the end of the page, and then modify it to match the name of the filter you have created.


3. Installing the crosswalk

If Cocoon is already installed, simply copy the complete crosswalk folder into the mount folder.

Then create a /MARC_data folder at the root level. This is where all the MARC XML data sets will be placed. There are two small examples in the crosswalk/data folder that you can copy into the /MARC_data folder to get things started.

If Cocoon is not installed, first install Apache Tomcat.  Test http://localhost:8080/ make sure Tomcat is running. Then install Apache Cocoon in the webapps folder. Test http://localhost:8080/cocoon-2.1.11/ to make sure Cocoon is running. Then copy the crosswalk folder in the mount folder.  The following URL should then run the workbench:

    http://localhost:8080/cocoon-2.1.11/mount/crosswalk/

There may be other mysteries involved in getting the XSLT2 processor to be configured correctly. Another approach to installation is to copy the complete Tomcat installation (with Cocoon embedded) from another machine that has a working installation.

