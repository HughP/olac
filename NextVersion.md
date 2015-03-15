# Next versions of OLAC metadata standard #

In the very near term we need to produce a version 1.1 update of our metadata schema in order to accommodate the major change in the OLAC-Language vocabulary. Bigger changes can be addressed in a longer term version 2.0 update. Here is a summary of objectives for the two versions.

## Version 1.1 ##

Now that ISO 639-3 has been formally adopted, we need to change the olac-language vocabulary extension to accept ISO 639 codes (both 2- and 3-letter) rather than the x-sil- and x-ll- codes used in the 1.0 version.

The other major change in version 1.1 is to implement a few changes in the `<olac-archive>` description that is part of the Identify response:
  * Combine curator, curatorTitle, and curatorEmail as attributes of new `<participant>` element. The element should be obligatory (since we need at least one contact person) and repeatable (so that any number at an institution can subscribe to the [quarterly report](QuarterlyReport.md) for the archive). Note that adminEmail is repeatable in the OAI spec, but we can leave it single in our implementation once we have a repeatable participant element in `<olac-archive>`. We should require that the person identified in adminEmail is also recorded as a participant so that we get the additional information of name and title.
  * Add something like `<archivalSubmissionPolicy>` to be used by actual archives to describe their policy on what kinds of materials they accept from whom under what terms.
  * Add an attribute for currentAsOf so that we can keep track of when the archive description was last updated.
See [Implementation To-Do List](ToDo.md) for a list of implementation steps.

## Version 2.0 ##

The basic theme of the changes is to position ourselves more in the mainstream of the DCMI's current best practices (in which the DCMI is in turn placing themselves in the mainstream of the Semantic Web). This involves: (1) moving from our own vocabularies (olac:language and olac:role) to library community vocabularies (dcterms:ISO639-3 and MARC relator codes), (2) using URIs for terms and vocabulary items, and (3) defining an application profile to express our guidelines and constraints. By focusing the application profile on the general concept of language resources, we would create something that catalogers outside our specific community could also follow.

More specifically, these changes would be involved:
  * Put our terms and vocabularies into our own namespaces
  * Add needed refinements (e.g. isTranscriptOf and hasTranscript) by adding terms in our namespace
  * Replace our Role vocabulary with MARC Relator from its namespace (with possible additions)
  * Use ISO639-3 from its namespace
  * Change Linguistic Data Type to Language Resource Type
  * Establish a DC application profile for Language Resources
  * Create a new metadata format that follows the forthcoming DC recommendation on expressing DC in XML
  * Add a controlled vocabulary to Rights (cf. Creative Commons URIs, Eprint application profile, Google advance search feature on [Usage Rights](http://www.google.com/support/bin/answer.py?answer=29508))