### _OLAC Metadata Version 1.1_ ###

# Call for Implementation #

As a result of the [Metadata Quality activity](Metadata.md) of the research project on [Accessing the World's Language Resources](Home.md), a set of new documents is now ready for testing by the participating archives. In accordance with the [OLAC Process](http://www.language-archives.org/OLAC/process.html), these documents have gone through community review and have now been promoted to Candidate status by the OLAC Council. These involve changes to the OLAC standards that define a new version 1.1 of the OLAC metadata and repository schemas. A call for implementation is now issued during which all participating archives are asked to implement the changes.

The implementation period will close on _**1 October 2008.**_ Post all feedback to the [OLAC-IMPLEMENTERS](http://lists.linguistlist.org/archives/olac-implementers.html) list, or if you want to communicate privately, to [olac\_project@gial.edu](mailto:olac_project@gial.edu).

Once we have your feedback, we will revise the documents as necessary, and then put the revised documents to the OLAC Council for final approval, at which point the documents will change to "Adopted" status.

The updates to the OLAC schemas and infrastructure being tested in this candidate release involve three main areas:
  * Updating to version 1.1 of the metadata and repository schemas
  * Updating the OLAC-Language vocabulary
  * Improving metadata quality

### Updating to version 1.1 ###

The candidate documents related to this change are:
  * [OLAC Metadata](http://www.language-archives.org/OLAC/metadata-20080531.html) standard
  * [OLAC Repositories](http://olac.svn.sourceforge.net/viewvc/olac/web/OLAC/repositories-new.html) standard

You must make the following changes to your repository in order to update it to version 1.1:
# Change every instance of "OLAC/1.0" to "OLAC/1.1" in the namespace names and schema locations.
# Make the following changes in the `<olac-archive>` description within the `<Identify>` response (see [Section 3](http://www.language-archives.org/OLAC/repositories-20080531.html#OLAC%20archive%20description) of OLAC Repositories for fuller documentation):
> (a) An obligatory attribute for _currentAsOf_ is added so that data providers can supply the date on which they last verified that the information is up-to-date. Set this attribute to the date you make the upgrade, e.g. currentAsOf="2008-06-21"<br>
<blockquote>(b) The elements for <code>&lt;curator&gt;</code>, <code>&lt;curatorTitle&gt;</code>, and <code>&lt;curatorEmail&gt;</code> are replaced by a single and repeatable <code>&lt;participant&gt;</code> element with attributes for <i>name, role,</i> and <i>email</i>. In addition to reformatting the existing information about the curator to be an instance of the new <code>&lt;participant&gt;</code> element, you may add additional <code>&lt;participant&gt;</code> elements for any people from your institution who would like to receive the new report on usage and quality metrics for your repository (which will be emailed quarterly). There should be a <code>&lt;participant&gt;</code> element giving fuller contact information for the person whose email address is given as <code>&lt;oai:adminEmail&gt;</code> elsewhere in the Identify response.<br>
(c) If your repository is the catalog of an archive that receives submissions of language resources for long-term preservation, then add an instance of the new <code>&lt;archivalSubmissionPolicy&gt;</code> element to describe your policy on receiving archival submissions.<br>
# The biggest change in version 1.1 is to upgrade from the x-sil-abc and x-ll-abc style of language codes used in OLAC version 1.0 to the ISO 639-3 code set formally adopted by ISO in February of 2007. If you have not made that upgrade yet, you will need to do so now. See the next section of this note.</blockquote>

<h3>Updating language codes</h3>

The candidate document related to this change is:<br>
<ul><li><a href='http://www.language-archives.org/REC/language.html'>OLAC Language Extension</a> recommendation</li></ul>

This document explains the new version of the OLAC-Language vocabulary, which is now based on ISO 639. The original version of this recommendation was based on the three-letter identifiers used in the 14th edition of the Ethnologue. The 15th edition made a one-time reassignment of approximately 10% of the identifiers in order to align with the new ISO 639-3 standard. If you have not yet updated the language codes in your catalog database accordingly, you will need to do so now. The following page gives code conversion tables and instructions on how to use them: <a href='http://www.ethnologue.com/codes/updating_codes.asp'>http://www.ethnologue.com/codes/updating_codes.asp</a>

With the language vocabulary now promoted to candidate status, the first document listed below is now able to be promoted to candidate status. The other four metadata vocabularies defined by OLAC have been waiting in candidate status for the past two years. They are also included in this call for implementation so that they can be fully adopted at the conclusion of the review process:<br>
<ul><li><a href='http://www.language-archives.org/REC/olac-extensions.html'>Recommended metadata extensions</a> recommendation<br>
</li><li><a href='http://www.language-archives.org/REC/discourse.html'>OLAC Discourse Type Vocabulary</a> recommendation<br>
</li><li><a href='http://www.language-archives.org/REC/type.html'>OLAC Linguistic Data Type Vocabulary</a> recommendation<br>
</li><li><a href='http://www.language-archives.org/REC/field.html'>OLAC Linguistic Subject Vocabulary</a> recommendation<br>
</li><li><a href='http://www.language-archives.org/REC/role.html'>OLAC Role Vocabulary</a> recommendation</li></ul>

<h3>Improving metadata quality</h3>

The candidate documents related to this are:<br>
<ul><li><a href='http://www.language-archives.org/REC/bpr.html'>Best Practice Recommendations for Language Resource Description</a> recommendation<br>
</li><li><a href='http://www.language-archives.org/NOTE/usage.html'>OLAC Metadata Usage Guidelines</a> informational note<br>
</li><li><a href='http://www.language-archives.org/NOTE/metrics.html'>OLAC Metadata Metrics</a> informational note</li></ul>

The first phase of the current research project focuses on improving metadata quality as a prerequisite to improving the quality of search. To that end we have developed the above three documents that can serve as a basis for improving and measuring metadata quality within our community:<br>
<br>
The OLAC Metadata Standard defines the constraints on validity for a metadata record, but it gives no advice about what a high quality metadata record is like. The first two documents listed above address this issue. In keeping with the OLAC core value of "Peer Review", we are instituting a service that measures conformance to the recommendations for which automatic tests can be constructed. That is the subject addressed by the third document listed above.<br>
<br>
The proposed Metadata Quality Score and other metrics are now implemented and ready for testing as part of this call for implementation. The metadata quality analysis is accessible from a test version of the Participating Archives page. The site has no links to this test page; it is accessed by entering this URL in a browser:<br>
<br>
<a href='http://www.language-archives.org/archives-new.php'>http://www.language-archives.org/archives-new.php</a>

Follow the "Sample Record" link for your archive to see the quality score for the sample record named in your Identify response, along with comments on what can be done to improve the score. Follow the "Metrics" link to see the average quality score for the records you are currently providing. Click the "Comparative Archive Metrics" tab to see how your archive compares with others.<br>
<br>
It is possible to use the <a href='http://www.language-archives.org/tools/metadata/freestanding.html'>Freestanding Metadata Service</a> to perform a metadata quality analysis on any OLAC metadata record. Simply paste the record into the text box and click the "Analyze" button. Before implementing changes to improve quality, you may test the impact of the proposed changes by editing a sample record in the Freestanding Metadata Service.<br>
<br>
The full set of Candidate documents being tested during this Call for Implementation can be found at:<br>
<a href='http://www.language-archives.org/documents_by_status.html#Candidate'>http://www.language-archives.org/documents_by_status.html#Candidate</a>

At the close of the implementation period on <b><i>1 October 2008</i></b>, all feedback concerning the documents and current implementation will be processed by the Coordinators and Council to arrive at final adopted versions, or if necessary, further Candidate versions will be prepared for review. The new version of the Participating Archives page and the metrics pages will be released to the public site when all of these documents achieve Adopted status.<br>
<br>
Post all feedback concerning the documents to the <a href='http://lists.linguistlist.org/archives/olac-implementers.html'>OLAC-IMPLEMENTERS</a> list. If you would appreciate consulting help in figuring out how to improve the quality of your metadata records or have any other questions specific to your situation, you may follow up with an email to <a href='mailto:olac_project@gial.edu'>olac_project@gial.edu</a> (which is monitored by Debbie Chang who is the research assistant for the project).