# The Quarterly Report to OLAC participants #

Objective 1.1e of the project plan is, "_Quarterly reporting:_ Develop an automated quarterly report to be emailed to curators to inform them of their metadata quality and currency and their usage statistics." It is an email version of the current metrics for the repository sent out to all of the participants registered for this service by means of the participant declarations in the `<olac-archive>` description. The email is meant to serve two key functions:
  * Provide usage statistics that will encourage the participants about the impact of their participation in OLAC and which they can use within their institution to report to others about the value of their OLAC participation
  * Provide an impetus to improve the quality and currency of the metadata they are providing when either is lacking in a significant way

### Process model ###
What process model do we want for initiating mailing of the report?
  * Cron job: Is quarterly the right frequency? The first day of each quarter?
  * On demand: Do we also need a button somewhere that the Coordinators can push to launch the mailing? Or should we always do it that way rather than by cron job?
  * One off: Do we need a way to generate the report on demand for just one repository?

### Recipients ###
For test purposes, we can direct the report to the `<curatorEmail>` from the `<olac-archive>` description. In generating the recipient output both the name and the address, e.g. "curatorName" `<curatorEmail>`

When the 1.1 schema is finalized, we expect to have a repeating element for `<participant>` and the email report for an archive will be sent to all its registered participants. The 1.1 standard will direct that the person identified in `<oai:adminEmail>` should also be listed as a `<participant>`, since that gives us a name and a title as well. Therefore, we can ignore the adminEmail. When the 1.1 update is implemented, we will want to send one report per archive with all `<participants>` in a single recipient list. In that way, the recipients will be reminded of who the other participants at their institution are.

### Email content ###
Here is a draft of the content of the email (where `<dataField>` represents the substitution of the value of a field from the database):

`Dear OLAC participant,`<br>

<code>You are receiving this email by virtue of your association with the following archive that participates in OLAC:</code><br>

<code>&lt;Name of archive&gt;`</code><br>

(If you do not wish to receive these emails, please notify <code>your OLAC system administrator, &lt;oai:adminEmail&gt;`.)</code><br>

<code>USAGE</code><br>
<code>These are the latest statistics on the usage of your metadata records on the OLAC site:</code><br>

<i>To be determined. Usage metrics not yet implemented.</i><br>

<code>QUALITY METRICS</code><br>
<code>OLAC tracks two metrics as primary indicators of overall metadata quality in its aggregated catalog: number of archives with fresh catalogs (that is, updated within the last 12 months) and number of archives with five-star metadata (that is, fully conforming to best practice as agreed on by the community). See http:_www.language-archives.org/metrics/ for the current values of the metrics and a link to the document that explains them. The currency and quality scores for your archive are:</code><br>

<code>Last Updated: &lt;lastUpdated&gt;`</code><br>
<code>Average Metadata Quality: &lt;round(score/2)&gt;`-stars (&lt;score&gt;` on a 10 point scale)</code><br>

<i>Generate a paragraph of feedback by assembling the following sentences as applicable:</i><br>

<i>If "Last updated" is within last 12 months and quality score is 9.0 or higher:</i><br>
<code>These metrics indicate that your archive is an exemplary member of the community. Congratulations!</code><br>

<i>If "Last updated" is more than 12 months ago and quality score is 9.0 or higher:</i><br>
<code>The quality of your metadata is exemplary. Congratulations!</code><br>

If "Quality score" is less than 7:<br>
<code>Your average metadata quality could be improved.</code><br>

If "Quality score" is between 7 and 9:<br>
<code>Your average metadata quality is good, but could still be improved.</code><br>

When "Quality score" is less than 9, add this as well:<br>
<code>See the metadata quality analysis of your sample record at the following URL for ideas on what could be done to improve the quality of your metadata.</code><br>

<code>http:/www.language-archives.org/sample/&lt;archiveId&gt;`</code><br>

<i>If "Last updated" is greater than 12 months ago:</i><br>
<code>Note that it is more than one year since your metadata repository was last updated; please update your repository at your earliest convenience.</code><br>

<i>If "Last updated" is less than 12 months ago, but greater than 9 months:</i><br>
<code>Note that it will soon be one year since your metadata repository was last updated; please update it by &lt;lastUpdated + one year&gt;`.</code><br>

[<a href='#Checks.md'>#Checks</a>]<br>
<code>INTEGRITY PROBLEMS</code><br>
<i>If "Problem count" <code>`=</code><code> 0 AND "Warning count" </code><code>=</code>` 0:</i><br>
<code>Congratulations, there are no known integrity problems in your metadata.</code><br>

<i>If "Problem count" >` 0:</i><br>
<code>Automated checking has detected problems in your metadata such as broken links or invalid vocabulary terms. The presence of these problems is causing one star to be subtracted from your overall quality rating. Visit the following link to see a listing of the problems that need to be fixed:</code><br>

<code>http:/www.language-archives.org/checks/&lt;archiveId&gt;`</code><br>

<i>If "Problem count" = 0 AND "Warning count" >` 0:</i><br>
<code>Automated checking has detected some potential problems in your metadata. They are not severe enough to count against your overall quality rating. Nevertheless, you are advised to Visit the following link to see a listing of the potential problems:</code><br>

<code>http:/www.language-archives.org/checks/&lt;archiveId&gt;`</code><br>

<code>COLLECTION METRICS</code><br>
<code>The following table reports the current metrics for the size, coverage, and cataloging of your collection. The final column reports the rank of your repository in comparison to all participants (where 1 is highest and &lt;numberOfArchives&gt;` is lowest):</code><br>

<table><thead><th> Metric </th><th> Value </th><th> Rank </th></thead><tbody>
<tr><td> Number of Resources </td><td> 3280 </td><td> 4 </td></tr>
<tr><td> Number of Resources Online </td><td> 3280 </td><td> 2 </td></tr>
<tr><td> Distinct Languages </td><td> 0 </td><td> 7 </td></tr>
<tr><td> Distinct Linguistic Subfields </td><td> 0 </td><td> 5 </td></tr>
<tr><td> Distinct Linguistic Types </td><td> 0 </td><td> 10 </td></tr>
<tr><td> Distinct DCMI Types </td><td> 0 </td><td> 9 </td></tr>
<tr><td> Average Elements Per Record </td><td> 5 </td><td> 36 </td></tr>
<tr><td> Average Encoding Schemes Per Record </td><td> 1.5 </td><td> 27 </td></tr></tbody></table>

<i>Implementation notes: Format table for a monospace font using spaces to make the columns of numbers right align. For the ranks, report the highest applicable rank in the case of a tie.</i><br>

<i>Implementation notes: Format table for a monospace font using spaces to make the columns of numbers right align. For the ranks, report the highest applicable rank in the case of a tie.</i><br>

<code>ARCHIVE DESCRIPTION</code><br>
<code>Please review your archive description at the following URL to ensure that all of the information you are supplying is up to date. Contact your OLAC system administrator (&lt;oai:adminEmail&gt;`) if you spot anything that should be changed:</code><br>

<code>http:/www.language-archives.org/archive/&lt;archiveId&gt;`</code><br>

<code>Thank you for your participation.</code><br>

<code>Best wishes,</code><br>
<code>Steven &amp; Gary</code><br>

<code>___</code><br>
<code>Steven Bird, University of Melbourne and University of Pennsylvania</code><br>
<code>Gary Simons, SIL International and GIAL</code><br>
<code>OLAC Coordinators (www.language-archives.org)</code><br>