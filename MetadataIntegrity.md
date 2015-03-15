# Metadata Integrity Report #

A remaining piece of our implementation to support metadata quality is a metadata integrity report. This has been added as a third deliverable under task 1.1f-Metrics in the project plan.

The integrity report should be a page that reports any errors in metadata that we can detect automatically. This will include:
  * Missing sample record
  * Every broken URL
  * Every reference to a non-existent oai: identifier
  * Every invalid value for a controlled vocabulary

The report will also give warnings about uses that are known to be less than best practice. These include:
  * Every use of a retired, collective, or macro language code

This specification describes the implementation in three subsections in terms of the underlying data model, the processing model, and the reporting formats.

## Data model ##

A possible model would be to do all checking dynamically, but the checks (like valid link checking) take enough time and the data is static enough, that it makes more sense to store the results of checking in the database. There are two types of checks: checks on Archived Items and checks on individual Metadata Elements. The basic data model is that these two entities in the SQL database will add a pair of columns:

```
IntegrityChecked date,
Problem_Code char(3) null,
foreign key (Problem_Code) references INTEGRITY_PROBLEM (Problem_Code)
```

Where `IntegrityChecked` is the date of the last time the integrity was checked and `Problem_Code` stores the outcome of the check: NULL if there was no problem, and a three-letter code for the discovered Integrity Problem if a problem was detected. A three-letter code is used as the problem identifier rather than an autoincremented integer because the code that implements the integrity checks must poke the identifiers into the records that have problems. The integrity checking code will be more transparent if the problems are represented by mnemonic codes rather than integers.

This design depends on the creation of a new database entity that lists the integrity problems that our process checks for:

```
create table INTEGRITY_PROBLEM (
Problem_Code char(3) not null,
Applies_To char(1) not null, # 'I' for Archived Item, 'E' for Metadata Element
Severity char(1) not null, # 'E' for Error, 'W' for Warning
Label varchar(40) not null,
Description varchar(255) not null,
primary key (Problem_Code) );
```

_`Applies_To`_ indicates whether the integrity check is performed against an instance of `Archived_Item` or of `Metadata_Elem`. _Severity_ indicates whether the problem is counted against the archive as an error, or is just something that deserves a warning. _Label_ is a short phrase that serves as the name of the problem in reports, whereas _Description_ is a longer definition of the problem and its remedy.

The following table lists problems for which we can implement tests (with the five columns corresponding to the table specification above):

| RNF | E | E | Resource Not Found | An attempt to follow the link yields a 404 (Resource not found) error. |
|:----|:--|:--|:-------------------|:-----------------------------------------------------------------------|
| RNA | E | W | Resource Not Available | An attempt to follow the link failed for a reason other than a 404 (Resource not found) error. |
| NSI | E | E | No Such Item | The combined OLAC catalog does not contain an entry with the given OAI identifier. |
| BSI | I | E | Bad Sample Identifier | The sampleIdentifier specified in the Indentify response is not present in the repository |
| BLT | E | E | Bad Linguistic Type | The value supplied for olac:linguistic-type is not defined in the vocabulary. |
| BDT | E | E | Bad DCMI Type | The value supplied for dcterms:DCMIType is not defined in the vocabulary. |
| BLC | E | E | Bad Language Code | The value supplied for olac:language is not defined in the ISO 639 code set. |
| SLC | E | W | Suboptimal Language Code | The value supplied for olac:language is a recognized code from ISO 639, but it is not best practice since it is retired or represents a collection of languages. |

And so on for the other vocabularies, e.g. BLF 'Bad Linguisitic Field', BCR 'Bad Contributor Role', BDT 'Bad Discourse Type'. BCC 'Bad Country Code' (ISO 3066).

Are the EXTENSION and CODE\_DEFN tables populated? If so, the implementation of these controlled vocabulary checks can be based on that. Should we add a foreign key for Extension\_ID? Would need to add another column to CODE\_DEFN to mark a code as suboptimal (esp. retired). Need a process for annual updates of the ISO 639 code table. Perhaps it should be its own table so that we can just replace wholesale each year.

## Processing model ##

These errors do not block registration or harvesting. As long as the records are syntactically well-formed, they are harvested. Integrity checking is a subsequent process that detects errors and reports the number as part of the public reporting of metadata quality for a participating archive. Thus our philosophy is not to block participation when there are errors, but to encourage participants to maintain as high a level of quality as possible.

Another factor here is that it is not sufficient to make the integrity checks when a record is first harvested, since the validity of metadata values may change over time. The is most particularly the case for URLs which are notorious for having a very short (in archival terms) half life. But it is also true for values from controlled vocabularies which may be retired from active use as time goes by.

What is the best design for the timing of processing?
  * Check everything new at the end of harvesting?
  * Less frequent cron job to check everything?
  * An interface that allows archives to check their archive on demand?
  * An interface that allows coordinators to launch a check on an archive, or just everything?
  * Should all checks be built into one large process, or should there be separate processes for different kinds? Not that all of the checks except checking http: links are matters of internal integrity within the database, and thus can be implemented with SQL. However, link checking requies a completely different kind of process.

## Reporting formats ##

The report on metadata integrity checks for each archive will be on a dynamically generated page with the following URL:
`http://www.language-archives.org/checks/<archiveId>`<br>
Some requirements for the page:<br>
<ul><li>It should list the errors first, with an explanation like, "The following errors have been detected in the metadata for this archive. Their presence counts against the Overall Rating for the archive."<br>
</li><li>The warnings should be listed second and separately with an explanation like, "The following potential problems have been detected and should be looked into. They are not severe enough to count against the archive's Overall Rating."<br>
</li><li>Each report of an item should give the error label, the offending value, and the record identifier.<br>
</li><li>There should be a link to download the complete set of reported problems as a single CSV file (like at the Google Webmaster stie). The columns should be: Problem, Severity, Value, Record.</li></ul>

The link to this page will be from the Archive Details page (e.g. /archive/<code>&lt;archiveId&gt;</code>). The bottom line of that page (which is currently Metrics:) could be changed to a line with two links:<br>
<br>
<blockquote>Reports: Archive Metrics and Integrity Checks<br></blockquote>

Changes to Archive Metrics report:<br>
<ul><li>Add a new row to the bottom of the Summary Statistics table, Known Integrity Problems, which reports a count of the total number of Errors from the integrity checks. (Do this both for ALL archives and for individual archives.)<br>
</li><li>For an individual archive (but not the ALL archives option), add a new final row for Overall Rating. Here we want to see a string of 0 to 5 stars. Calculate the number of stars by dividing the Average Metadata Quality by 2 and rounding to the nearest integer, and then subtract one star if the count of known integrity problems is greater than 0. (See /web/tools/scores/ in SVN repository for files star0.gif through star5.gif.)</li></ul>

Changes to Comparative Metrics page:<br>
<ul><li>Add a column at end for Known Integrity Problems.<br>
</li><li>Do we also want to add a column (perhaps first) for overall rating that shows the stars?</li></ul>

Changes to Quarterly Email Report:<br>
<ul><li>See the newly added [[QReport#Checks|INTEGRITY PROBLEMS]] section in the specification of the Quarterly Report.