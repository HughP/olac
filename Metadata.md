[1.1 Metadata](Metadata.md) | [1.2 Participation](Participation.md) | [1.3 Curation](Curation.md) | [2.1 Crosswalking](Crosswalking.md) | [2.2 Mining](Mining.md) | [2.3 Search](Search.md)

### Outcome 1.1: All OLAC repositories should have up-to-date catalogs that contain metadata conforming to best practice. ###

1.1a _Best practice document:_ Prepare and adopt an OLAC recommendation on metadata best practice, adapting the DC Usage Guidelines and fleshing out published recommendations.

  * **Deliverables:** Two OLAC documents<br>
<ul><li><i>Recommendation:</i> Best Practice Recommendations for Language Resource Description (see <a href='http://www.language-archives.org/REC/bpr.html'>http://www.language-archives.org/REC/bpr.html</a>)<br>
</li><li><i>Informational Note:</i> OLAC Metadata Usage Guidelines (see <a href='http://www.language-archives.org/NOTE/usage.html'>http://www.language-archives.org/NOTE/usage.html</a>)<br>
</li></ul><ul><li><b>Status:</b> Completed.<br></li></ul>

1.1b <i>Score cards:</i> Update the automated score card system to conform to best practice recommendations.<br>
<br>
<ul><li><b>Deliverable:</b> An informational note that describes the automated quality score; see <a href='http://www.language-archives.org/NOTE/metrics.html'>http://www.language-archives.org/NOTE/metrics.html</a><br>
</li><li><b>Status:</b> Completed. The quality score has been integrated into the metrics page (deliverable 1.1f below), so that the metrics page for an archive functions as its score card.<br></li></ul>

1.1c <i>Metadata quality:</i> Identify low-scoring archives and work with them to improve the quality of their metadata.<br>
<br>
<ul><li><b>Deliverable:</b> A page that ranks all participating archives by average metadata quality score.<br>
</li><li><b>Status:</b> Completed; the new Comparative Metrics page allows archives to be ranked by average metadata quality: <a href='http://www.language-archives.org/metrics/compare'>http://www.language-archives.org/metrics/compare</a>.<br>
</li><li><b>Deliverable:</b> An automated metadata quality advisor that tells an archive what they need to do to achieve a five-star rating.<br>
</li><li><b>Status:</b> Completed; there is a new Analyze button on the Free-Standing OLAC Metadata Service (<a href='http://www.language-archives.org/tools/metadata/freestanding.html'>http://www.language-archives.org/tools/metadata/freestanding.html</a>) which computes the quality score of a record and advises how to improve it. The same analysis is invoked for the Sample Record for each participating archive at <a href='http://www.language-archives.org/archives.php'>http://www.language-archives.org/archives.php</a><br>
</li><li><b>Target:</b> Every archive publishes five-star metadata. (For the present, we must lower the goal to a four-star score since this is the maximum that many archives can receive until the new language resource type vocabulary is implement; see 1.1g below.)<br>
</li><li><b>Status:</b> At present, 20 of 40 archives (or 50%) have reached the target level. These account for 68,000 of the 104,000 archived items (or 65%).  As the baseline, one archive had four-star metadata and none had five-star.<br></li></ul>

1.1d <i>Updating archives:</i> Identify OLAC archives whose metadata records have gone stale, and work with them to bring their catalogs up-to-date.<br>
<br>
<ul><li><b>Target:</b> Every archive updates at least once a year.<br>
</li><li><b>Status:</b> At present, 23 of 40 archives (or 58%) have updated within the last 12 months. The baseline was 5 of 36.<br>
</li><li><b>Deliverable:</b> In version 1.1 of the repositories standard, add a <code>currentAsOf</code> attribute to the <code>olac-archive</code> description of the Identify response and update harvester to read it.<br>
</li><li><b>Status:</b> Completed. The reporting of date of last update is implemented in 1.1e and 1.1f as the later of the latest datestamp or <code>currentAsOf.</code><br>
</li><li><b>Target:</b> Every archive has upgraded to version 1.1. (This is actually a prerequisite to achieving the target of every archive updating once a year, since without the <code>currentAsOf</code> attribute they cannot indicate that they are up-to-date when no records have been updated.)<br>
</li><li><b>Status:</b> 16 still need to be upgraded. (All pending upgrades are tracked in Google Code as <a href='http://code.google.com/p/olac/issues/list?q=label:Type-Repository'>Open issues of Type-Repository</a>.)<br></li></ul>

1.1e <i>Quarterly reporting:</i> Develop an automated quarterly report to be emailed to curators to inform them of their metadata quality and currency and their usage statistics.<br>
<br>
<ul><li><b>Deliverable:</b> Cron job that emails a quarterly report to each curator and archive admin<br>
</li><li><b>Status:</b> Completed; see <a href='QuarterlyReport.md'>specifications</a> for the email report on separate page.<br>
</li><li><b>Deliverable:</b> Version 1.1 of repositories standard to add multiple archive participants to the <code> </code> description of the Identify response, in place of the single curator, so that any number of participants from an institution can subscribe to the quarterly report on its archive.<br>
</li><li><b>Status:</b> Completed.<br></li></ul>

1.1f <i>Metrics:</i> Develop metrics for monitoring the size, coverage, quality, and use of the OLAC metadata catalog, and report them on the web site.<br>
<br>
<ul><li><b>Deliverable:</b> Dynamic page that reports metrics on entire collection by default (or on a selected archive). See <a href='Metrics.md'>specifications</a> on separate page.<br>
</li><li><b>Status:</b> Completed for all metrics except usage statistics; see <a href='http://www.language-archives.org/metrics/'>http://www.language-archives.org/metrics/</a><br>
</li><li><b>Deliverable:</b> Dynamic page that lists participating archives ranked (from highest to lowest) on the selected metric<br>
</li><li><b>Status:</b> Completed; see <a href='http://www.language-archives.org/metrics/compare'>http://www.language-archives.org/metrics/compare</a><br>
</li><li><b>Deliverable:</b> Dynamic page that lists outstanding integrity problems (especially broken links and invalid metadata values) in the metadata records of a given archive. See <a href='MetadataIntegrity.md'>specifications</a> on separate page.<br>
</li><li><b>Status:</b> Completed; see <a href='http://www.language-archives.org/checks'>http://www.language-archives.org/checks</a><br></li></ul>

1.1g <i>Language Resource Type:</i> Develop a language resource type vocabulary to replace the linguistic data type vocabulary so that every language resource will have a relevant type category.<br>
<br>
<ul><li><b>Deliverable:</b> A new draft recommendation document.<br>
</li><li><b>Status:</b> Thus far, there are only rough notes.<br>