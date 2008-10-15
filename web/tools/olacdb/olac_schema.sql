##################################################################
#   MySQL Schema for database used by OLAC metadata harvester    #
#   Open Language Archives Community                             #
#   http://www.language-archives.org/tools/olac_schema.sql       #
##################################################################


##################################################################
# Table               : OLAC_ARCHIVE
# Description         : 
# Archive_ID          : 
# RepositoryName      : Human readable name of the archive 
# RepositoryIdentifier : The unique identifier for the archive used in oai identifiers 
# SampleIdentifier
# BaseURL             : The base URL of the data provider 
# OaiVersion          : The version of the OAI protocol that is supported 
# FirstHarvested      : Date of first successful harvest 
# LastHarvested       : Date of last successful harvest 
# Curator
# CuratorTitle
# CuratorEmail
# Institution
# InstitutionURL
# ShortLocation
# Location
# Synopsis
# Access
# Copyright
##################################################################

create table OLAC_ARCHIVE (
	Archive_ID		int auto_increment not null,
	ArchiveURL		varchar(255),
	AdminEmail		varchar(255),
	Curator			varchar(255),
	CuratorTitle		varchar(255),
	CuratorEmail		varchar(255),
	Institution		varchar(255) not null,
	InstitutionURL		varchar(255),
	ShortLocation		varchar(50) not null,
	Location		text,
	Synopsis		text,
	Access			text,
	ArchivalSubmissionPolicy	text,
	Copyright		varchar(255),
	RepositoryName		varchar(255) not null,
	RepositoryIdentifier	varchar(50) not null unique,
	SampleIdentifier	varchar(255),
	BaseURL			varchar(255) not null,
	OaiVersion		varchar(10) not null,
	FirstHarvested		date,
	LastHarvested		date,
	ArchiveType		varchar(64),
	CurrentAsOf		date,
	ts			timestamp default current_timestamp on update current_timestamp,
	primary key (Archive_ID)
) engine=innodb, charset=utf8;
 

##################################################################
# Table               : ARCHIVE_PARTICIPANT
#
# Name
# Role
# Email
##################################################################

create table ARCHIVE_PARTICIPANT (
	Archive_ID		int,
	Name			varchar(64),
	Role			varchar(32),
	Email			varchar(128),
	primary key (Archive_ID, Role, Email),
	foreign key (Archive_ID) references OLAC_ARCHIVE (Archive_ID)
) engine=innodb, charset=utf8;

##################################################################
# Table               : SCHEMA_VERSION
# Description         : 
# Schema_ID           : 
# Xmlns               : The xmlns for the schema version 
# SchemaURL           : The URL for the schema version 
#
##################################################################


create table SCHEMA_VERSION (
	Schema_ID		int auto_increment primary key,
	SchemaName		varchar(10),
	Xmlns			varchar(255) not null,
	SchemaURL		varchar(255) not null
) engine=innodb, charset=utf8;

insert into SCHEMA_VERSION values ('',
  '1.0',
  'http://www.language-archives.org/OLAC/1.0/',
  'http://www.language-archives.org/OLAC/1.0/olac.xsd');

insert into SCHEMA_VERSION values('',
  '1.1',
  'http://www.language-archives.org/OLAC/1.1/',
  'http://www.language-archives.org/OLAC/1.1/olac.xsd');


##################################################################
# Table               : ARCHIVED_ITEM
# Description         : 
# Item_ID             : 
# OaiIdentifier       : The OAI identifier for the item 
# DateStamp           : The datestamp from the header of the harvested record 
# Archive_ID          : (Foreign Key)
# Schema_ID           : (Foreign Key)
##################################################################

create table ARCHIVED_ITEM (
	Item_ID			int auto_increment not null,
	OaiIdentifier		varchar(255) not null,
	DateStamp		date not null,
	Archive_ID		int,
	Schema_ID		int,
	ts			timestamp default current_timestamp on update current_timestamp,
	primary key (Item_ID),
	foreign key (Archive_ID) references OLAC_ARCHIVE (Archive_ID)
        on delete set null
        on update cascade,
	foreign key (Schema_ID) references SCHEMA_VERSION (Schema_ID)
        on delete set null
        on update cascade
) engine=innodb, charset=utf8;
 
create index ARCHIVED_ITEM_INDEX on ARCHIVED_ITEM (Archive_ID, Schema_ID);


##################################################################
# Table               : ELEMENT_DEFN
# Description         : 
# Tag_ID              : 
# DcElement           :
# InverseElement      :
# Rank                : A number that encodes the relative order of presentation (lowest first) 
# TagName             : The generic identifier for the tag 
# Label               : A presentation label for the element 
# Display             : A flag indicating whether it should be included
#                       in the Element Usage histogram of OLAC Metics
#                       (http://www.language-archives.org/metrics)
#
##################################################################

create table ELEMENT_DEFN (
	Tag_ID			smallint not null,
        DcElement               smallint not null,
        InverseElement          smallint not null,
	Rank			smallint not null,
	TagName			varchar(255) not null,
	Label			varchar(255) not null,
	Display			bool default true,
	primary key (Tag_ID)
) engine=innodb, charset=utf8;
 

insert into ELEMENT_DEFN values ( 100, 100,   0, 100, 'contributor', 'Contributor',	1);
insert into ELEMENT_DEFN values ( 200, 200,   0, 200, 'coverage',    'Coverage',	1);
insert into ELEMENT_DEFN values ( 300, 300,   0, 300, 'creator',     'Creator',		1);
insert into ELEMENT_DEFN values ( 400, 400,   0, 400, 'date',        'Date',		1);
insert into ELEMENT_DEFN values ( 500, 500,   0, 500, 'description', 'Description',	1);
insert into ELEMENT_DEFN values ( 600, 600,   0, 600, 'format',      'Format',		1);
insert into ELEMENT_DEFN values ( 700, 700,   0, 700, 'identifier',  'Identifier',	1);
insert into ELEMENT_DEFN values ( 800, 800,   0, 800, 'language',    'Language',	1);
insert into ELEMENT_DEFN values ( 900, 900,   0, 900, 'publisher',   'Publisher',	1);
insert into ELEMENT_DEFN values (1000,1000,1000,1000, 'relation',    'Relation',	1);
insert into ELEMENT_DEFN values (1100,1100,   0,1100, 'rights',      'Rights',		1);
insert into ELEMENT_DEFN values (1200,1200,   0,1200, 'source',      'Source',		1);
insert into ELEMENT_DEFN values (1300,1300,   0,1300, 'subject',     'Subject',		1);
insert into ELEMENT_DEFN values (1400,1400,   0,   0, 'title',       'Title',		1);
insert into ELEMENT_DEFN values (1500,1500,   0,1500, 'type',        'Type',		1);

insert into ELEMENT_DEFN values ( 201, 200,   0, 201, 'spatial',         'Spatial Coverage',	1);
insert into ELEMENT_DEFN values ( 202, 200,   0, 202, 'temporal',        'Temporal Coverage',	1);
insert into ELEMENT_DEFN values ( 401, 400,   0, 401, 'created',         'Created',		1);
insert into ELEMENT_DEFN values ( 402, 400,   0, 402, 'valid',           'Valid',		1);
insert into ELEMENT_DEFN values ( 403, 400,   0, 403, 'available',       'Available',		1);
insert into ELEMENT_DEFN values ( 404, 400,   0, 404, 'issued',          'Issued',		1);
insert into ELEMENT_DEFN values ( 405, 400,   0, 405, 'modified',        'Modified',		1);
insert into ELEMENT_DEFN values ( 406, 400,   0, 406, 'dateAccepted',    'Date Accepted',	1);
insert into ELEMENT_DEFN values ( 407, 400,   0, 407, 'dateCopyrighted', 'Date Copyrighted',	1);
insert into ELEMENT_DEFN values ( 408, 400,   0, 408, 'dateSubmitted',   'Date Submitted',	1);
insert into ELEMENT_DEFN values ( 501, 500,   0, 501, 'tableOfContents', 'Table Of Contents',	1);
insert into ELEMENT_DEFN values ( 502, 500,   0, 502, 'abstract',        'Abstract',		1);
insert into ELEMENT_DEFN values ( 601, 600,   0, 601, 'extent',          'Extent',		1);
insert into ELEMENT_DEFN values ( 602, 600,   0, 602, 'medium',          'Medium',		1);
insert into ELEMENT_DEFN values (1001,1000,1002,1001, 'isVersionOf',     'Is Version Of',	1);
insert into ELEMENT_DEFN values (1002,1000,1001,1002, 'hasVersion',      'Has Version',		1);
insert into ELEMENT_DEFN values (1003,1000,1004,1003, 'isReplacedBy',    'Is Replaced By',	1);
insert into ELEMENT_DEFN values (1004,1000,1003,1004, 'replaces',        'Replaces',		1);
insert into ELEMENT_DEFN values (1005,1000,1006,1005, 'isRequiredBy',    'Is Required By',	1);
insert into ELEMENT_DEFN values (1006,1000,1005,1006, 'requires',        'Requires',		1);
insert into ELEMENT_DEFN values (1007,1000,1008,1007, 'isPartOf',        'Is Part Of',		1);
insert into ELEMENT_DEFN values (1008,1000,1007,1008, 'hasPart',         'Has Part',		1);
insert into ELEMENT_DEFN values (1009,1000,1010,1009, 'isReferencedBy',  'Is Referenced By',	1);
insert into ELEMENT_DEFN values (1010,1000,1009,1010, 'references',      'References',		1);
insert into ELEMENT_DEFN values (1011,1000,1012,1011, 'isFormatOf',      'Is Format Of',	1);
insert into ELEMENT_DEFN values (1012,1000,1011,1012, 'hasFormat',       'Has Format',		1);
insert into ELEMENT_DEFN values (1013,1000,1000,1013, 'conformsTo',      'Conforms To',		1);
insert into ELEMENT_DEFN values (1401,1400,   0,   1, 'alternative',     'Alternative Title',	1);

# Added 2006-03-31

insert into ELEMENT_DEFN values (1600,1600,   0,1600, 'accrualMethod',   	'Accrual Method',	0);
insert into ELEMENT_DEFN values (1610,1610,   0,1610, 'accrualPolicy',   	'Accrual Policy',	0);
insert into ELEMENT_DEFN values (1620,1620,   0,1620, 'accrualPeriodicity',	'Accrual Periodicity',	0);
insert into ELEMENT_DEFN values (1700,1700,   0,  50, 'audience',        	'Audience',		0);
insert into ELEMENT_DEFN values (1800,1800,   0, 750, 'instructionalMethod',	'Instructional Method',	0);
insert into ELEMENT_DEFN values (1900,1900,   0,1900, 'provenance',		'Provenance',		1);
insert into ELEMENT_DEFN values (2000,2000,   0,1150, 'rightsHolder',		'Rights Holder',	1);

insert into ELEMENT_DEFN values (1101,1100,   0,1101, 'accessRights',		'Access Rights',	1);
insert into ELEMENT_DEFN values ( 701, 700,   0, 701, 'bibliographicCitation',	'Bibliographic Citation',	1);
insert into ELEMENT_DEFN values (1701,1700,   0,  51, 'educationLevel',		'Audience Education Level',	0);
insert into ELEMENT_DEFN values (1102,1100,   0,1102, 'license',		'License',		1);
insert into ELEMENT_DEFN values (1702,1700,   0,  52, 'mediator',		'Mediator',		0);


##################################################################
# Table               : EXTENSION
# Description         : 
#
# Extension_ID        : 
# Type                : The name of the controlled vocabulary
#                       (<olac-extension><shortName>)
# DefiningSchema      : The location of the XML Schema for the vocabulary
# NS                  : The XML namespace for this vocabulary
# NSPresix            : A namespace prefix for the namespace
# NSSchema            : XML Schema URL for the namespace
# Label               : A label for Type
# LongName            : The long of the controlled vocabulary 
# VersionDate         : The version date
# Description         : A prose description of the vocabulary
# AppliesTo           : A list of DC Elements this extension applies to
# Documentation       : URL for the documentation
# 
# This table will be populated by reading the <extension> elements
# from http://www.language-archives.org/REC/olac-extensions.xml
# to discover the schema location, then reading the schema and
# parsing the <olac-extension> element.
#
# !!! PROBLEM - appliesTo is a repeatable XML element
#     SOLUTION 1. use comma-separated string
#
# !!! PROBLEM - the schema does not provide labels for Type
#     SOLUTION 1. Label <- Type
#
##################################################################

create table EXTENSION (
	Extension_ID		int auto_increment not null,

	Type			varchar(20) not null,
	DefiningSchema		varchar(255),
	NS			varchar(255) not null,
	NSPrefix		varchar(20),
	NSSchema		varchar(255),

	Label			varchar(50),
	LongName		varchar(50),
        VersionDate             date,
        Description             varchar(255),
        AppliesTo               varchar(255),
        Documentation           varchar(255),

	Display			bool,

	primary key (Extension_ID)
) engine=innodb, charset=utf8;

insert into EXTENSION (Type,NS,Display) values ('','',false);
update EXTENSION set Extension_ID=0;
insert into EXTENSION (Type,NS,NSPrefix,NSSchema,Display) values ('Box','http://purl.org/dc/terms/','dcterms','http://www.language-archives.org/OLAC/1.0/dcterms.xsd',true);
insert into EXTENSION (Type,NS,NSPrefix,NSSchema,Display) values ('DCMIType','http://purl.org/dc/terms/','dcterms','http://www.language-archives.org/OLAC/1.0/dcterms.xsd',true);
insert into EXTENSION (Type,NS,NSPrefix,NSSchema,Display) values ('IMT','http://purl.org/dc/terms/','dcterms','http://www.language-archives.org/OLAC/1.0/dcterms.xsd',true);
insert into EXTENSION (Type,NS,NSPrefix,NSSchema,Display) values ('ISO3166','http://purl.org/dc/terms/','dcterms','http://www.language-archives.org/OLAC/1.0/dcterms.xsd',true);
insert into EXTENSION (Type,NS,NSPrefix,NSSchema,Display) values ('LCSH','http://purl.org/dc/terms/','dcterms','http://www.language-archives.org/OLAC/1.0/dcterms.xsd',true);
insert into EXTENSION (Type,NS,NSPrefix,NSSchema,Display) values ('Period','http://purl.org/dc/terms/','dcterms','http://www.language-archives.org/OLAC/1.0/dcterms.xsd',true);
insert into EXTENSION (Type,NS,NSPrefix,NSSchema,Display) values ('Point','http://purl.org/dc/terms/','dcterms','http://www.language-archives.org/OLAC/1.0/dcterms.xsd',true);
insert into EXTENSION (Type,NS,NSPrefix,NSSchema,Display) values ('TGN','http://purl.org/dc/terms/','dcterms','http://www.language-archives.org/OLAC/1.0/dcterms.xsd',true);
insert into EXTENSION (Type,NS,NSPrefix,NSSchema,Display) values ('URI','http://purl.org/dc/terms/','dcterms','http://www.language-archives.org/OLAC/1.0/dcterms.xsd',true);
insert into EXTENSION (Type,NS,NSPrefix,NSSchema,Display) values ('W3CDTF','http://purl.org/dc/terms/','dcterms','http://www.language-archives.org/OLAC/1.0/dcterms.xsd',true);

##################################################################
# Table               : METADATA_ELEM
# Description         : 
# Element_ID          : 
# TagName             : The tag for the metadata element 
# Lang                : The value of the lang attribute 
# Type                : The type of extension (value of <shortName>)
# Code                : The value of the code attribute 
# Content             : The content of the metadata element 
#				MEDIUMTEXT: max 16777215 (2^24 - 1) characters. 
#				LONGTEXT: max 4294967295 (2^32 - 1) characters.
#
# Extension_ID        : (Foreign Key)
# Item_ID             : (Foreign Key)
# Tag_ID              : (Foreign Key)
##################################################################


create table METADATA_ELEM (
	Element_ID      int auto_increment not null,
	TagName         varchar(255) not null,
	Lang            varchar(255),
	Content         text,
	Extension_ID    int default 0,
	Type            varchar(20),
	Code            varchar(255) default '',
	Item_ID         int,
	Tag_ID          smallint,

	primary key (Element_ID),
	foreign key (Extension_ID) references EXTENSION (Extension_ID) on delete set null on update cascade,
	foreign key (Item_ID) references ARCHIVED_ITEM (Item_ID) on delete set null on update cascade,
	foreign key (Tag_ID) references ELEMENT_DEFN (Tag_ID) on delete set null on update cascade,
	key (TagName),
	key (Type),
	key (Code)
) engine=innodb, charset=utf8;

create index METADATA_ELEM_INDEX on METADATA_ELEM (Item_ID, Tag_ID);


##################################################################
# Table               : OLAC_EXTENSION
# Description         : 
# Extension_ID        : 
# ShortName           : The name of the controlled vocabulary 
# LongName            : The long of the controlled vocabulary 
# VersionDate         : The version date
# Description         : A prose description of the vocabulary
# AppliesTo           : A list of DC Elements this extension applies to
# Documentation       : URL for the documentation
# SchemaURL           : The location of the XML Schema for the vocabulary
# 
# This table will be populated by reading the <extension> elements
# from http://www.language-archives.org/REC/olac-extensions.xml
# to discover the schema location, then reading the schema and
# parsing the <olac-extension> element.
#
# !!! PROBLEM - appliesTo is a repeatable XML element
#
##################################################################

#create table OLAC_EXTENSION (
#	Extension_ID		int not null,
#	ShortName		varchar(20) not null,
#	LongName		varchar(50) not null,
#        VersionDate             date not null,
#        Description             varchar(255) not null,
#        AppliesTo               varchar(255) not null,
#        Documentation           varchar(255) not null,
#	SchemaURL		varchar(255) not null,
#	primary key (Extension_ID));


##################################################################
# Table               : CODE_DEFN
# Description         : 
# Code                : The coded value for a term 
# Label               : A presentation form of the term 
# Vocab_ID            : (Foreign Key)
#
# This table will be populated by reading the schema for the OLAC
# vocabulary
#
# !!! PROBLEM - the schema does not give us labels for the codes
#     Solution 1. Label <- Code
#
##################################################################


create table CODE_DEFN (
	Extension_ID    int not null,
	Code            varchar(255) not null,
	Label           varchar(255),
        primary key (Extension_ID, Code),
	foreign key (Extension_ID) references EXTENSION (Extension_ID)
        on update cascade
) engine=innodb, charset=utf8;

insert into CODE_DEFN (Extension_ID, Code, Label) values (0, '', '');

##################################################################
# Table                : INTEGRITY_PROBLEM
# Description of table : List of possible integrity problems.
#
# Problem_Code         : 3-letter code for a problem
# Applies_To           : 'I' for Archive Item, 'E' for Metadata Element
# Severity             : 'E' for Error, 'W' for Warning
# Label
# Description
##################################################################

create table INTEGRITY_PROBLEM (
	Problem_Code		char(3) not null,
	Applies_To		char(1) not null,
	Severity		char(1) not null,
	Label			varchar(40) not null,
	Description		varchar(255) not null,

	primary key (Problem_Code)
) engine=innodb, charset=utf8;

insert into INTEGRITY_PROBLEM values ('RNF','E','E','Resource Not Found','An attempt to follow the link yields a 404 (Resource not found) error.');
insert into INTEGRITY_PROBLEM values ('RNA','E','W','Resource Not Available','An attempt to follow the link failed for a reason other than a 404 (Resource not found) error.');
insert into INTEGRITY_PROBLEM values ('NSI','E','E','No Such Item','The combined OLAC catalog does not contain an entry with the given OAI identifier.');
insert into INTEGRITY_PROBLEM values ('BSI','A','E','Bad Sample Identifier','The sampleIdentifier specified in the Identify response is not present in the repository.');
insert into INTEGRITY_PROBLEM values ('BLT','E','E','Bad Linguistic Type','The value supplied for olac:linguistic-type is not defined in the vocabulary.');
insert into INTEGRITY_PROBLEM values ('BDT','E','E','Bad DCMI Type','The value supplied for dcterms:DCMIType is not defined in the vocabulary.');
insert into INTEGRITY_PROBLEM values ('BLC','E','E','Bad Language Code','The value supplied for olac:language is not defined in the ISO 639 code set.');
insert into INTEGRITY_PROBLEM values ('RLC','E','W','Retired Language Code','The supplied value is a recognized code from ISO 639, but it is not best practice since it is retired.');
insert into INTEGRITY_PROBLEM values ('SIL','E','W','Should be Individual Language','The value supplied for olac:language is a recognized code from ISO 639, but it is not best practice since it resents a collection of languages.');
insert into INTEGRITY_PROBLEM values ('MLC','E','W','Missing Language Code','The element uses olac:language extension but no olac:code is given.');
insert into INTEGRITY_PROBLEM values ('BLF','E','E','Bad Linguistic Field','The value supplied for olac:linguistic-field is not defined in the vocabulary.');
insert into INTEGRITY_PROBLEM values ('BCR','E','E','Bad Contributor Role','The value supplied for olac:role is not defined in the vocabulary.');
insert into INTEGRITY_PROBLEM values ('BDI','E','E','Bad Discourse Type','The value supplied for olac:discourse-type is not defined in the vocabulary.');
insert into INTEGRITY_PROBLEM values ('BCC','E','E','Bad Country Code','The value supplied for dcterms:ISO3166 is not defined in the ISO 3166 code set.');
insert into INTEGRITY_PROBLEM values ('RNC','A','E','Repository Not Found','The CurrentAsOf date is more than 12 months old.');
insert into INTEGRITY_PROBLEM values ('HFC','A','W','Harvesting Fails to Complete','Some records are being harvested, but an integrity issues in the data or a bug in the repository software is causing premature termination.');
insert into INTEGRITY_PROBLEM values ('SNV','A','W','Static Repository Not Valid','The retrieved static repository file is not valid.');
insert into INTEGRITY_PROBLEM values ('ANF','A','W','Repository Not Found','Accessing the static repository URL or the dynamic base URL generates a 404 error.');

##################################################################
# Table                : INTEGRITY_CHECK
# Description of table : Result of integrity checks
#
# Object_ID            : Archive ID, Archived Item ID or Metadata Element ID
# Problem_Code         : 3-letter code from INTEGRITY_PROBLEM
# IntigrityChecked     : The last date when the problem was recorded
##################################################################

create table INTEGRITY_CHECK (
	Object_ID		int,
	Value			varchar(255),
	Problem_Code		char(3),
	IntegrityChecked	date,

	primary key (Object_ID, Problem_Code),
	foreign key (Problem_Code) references INTEGRITY_PROBLEM (Problem_Code),
	key (Problem_Code)
) engine=innodb, charset=utf8;

##################################################################
# Table                : ARCHIVES
#
# Archive_ID           : A unique ID.
#                        NOTE: This field has nothing to do with the
#                        Archive_ID of the OLAC_ARCHIVE table.
# type                 : Dynamic | Gateway | ...
# ID                   : OAI repository identifier
##################################################################

create table ARCHIVES (
	Archive_ID		int(11) auto_increment,
	type			varchar(20),
	ID			varchar(50) not null,
	BASEURL			varchar(255) not null,
	contactEmail		varchar(255),
	dateApproved		date,
	primary key (Archive_ID)
) engine=innodb, charset=utf8;

##################################################################
# Table                : Metrics
#
##################################################################

create table Metrics (
	archive_id		int(11),
	num_resources		int(11),
	num_online_resources	int(11),
	num_languages		int(11),
	num_linguistic_fields	int(11),
	num_linguistic_types	int(11),
	num_dcmi_types		int(11),
	metadata_quality	float,
	avg_num_elements	float,
	std_num_elements	float,
	avg_xsi_types		float,
	last_updated		date,
	integrity_problems	int(11),
	primary key  (archive_id)
) engine=innodb, charset=utf8;

##################################################################
# Table                : MetricsElementUsage
#
##################################################################

create table MetricsElementUsage (
	archive_id		int(11),
	tag_id			int(11),
	cnt			int(11),
	primary key (archive_id, tag_id),
	key tag_id (tag_id)
) engine=innodb, charset=utf8;

##################################################################
# Table                : MetricsElementUsage
#
##################################################################

create table MetricsEncodingSchemes (
	Archive_ID		int(11),
	Type			varchar(20),
	Count			int(11)
) engine=innodb, charset=utf8;

##################################################################
# Table                : MetricsQualityScore
#
##################################################################

create table MetricsQualityScore (
	Item_ID			int(11),
	title			float,
	date			float,
	agent			float,
	about			float,
	depth			float,
	content_language	float,
	linguistic_type		float,
	subject_language	float,
	dcmi_type		float,
	prec			float,
	primary key (Item_ID)
) engine=innodb, charset=utf8;


##################################################################
# Table                : MetricsArchive
#
##################################################################

create table MetricsArchive (
        archive_id              int(11),
        num_resources           int(11),
        num_online_resources    int(11),
        num_languages           int(11),
        num_linguistic_fields   int(11),
        num_linguistic_types    int(11),
        num_dcmi_types          int(11),
        metadata_quality        float,
        avg_num_elements        float,
        std_num_elements        float,
        avg_xsi_types           float,
        last_updated            date,
        integrity_problems      int(11),
	ts			timestamp,
        primary key  (archive_id),
	index(ts)
) engine=innodb, charset=utf8;


##################################################################
# Table                : GoogleAnalyticsReports
# Description          : Used to archive google analytics reports.
##################################################################

create table GoogleAnalyticsReports (
	id			int auto_increment,
	type			varchar(16),
	repoid			varchar(50),
	start_date		date,
	end_date		date,
	pageviews		int,
	unique_pageviews	int,
	time_on_page		float,
	bounce_rate		float,
	percent_exit		float,
	value_index		float,
	primary key (id),
	unique (type, repoid, start_date),
	key(type),
	key (repoid),
	key (start_date),
	key (end_date)
) engine=Innodb charset=utf8;


##################################################################
# Table                : LanguageCodes
# Description          : Ethnologue 15th Ed.  This is slightly different
#                        from ISO 639-3 in the sense that ISO 639-3 is
#                        more complete.  The table data can be downloaded
#                        from the Ethnologue web site.
##################################################################

create table LanguageCodes (
	LangID			char(3),
	CountryID		char(2),
	LangStatus		char(1),
	Name			varchar(75),
	KEY (LangID),
	KEY (Name)
) engine=innodb, charset=utf8;

# This command can be modified and used to populate the LanguageCodes table
# from the data file downloaded from the Ethnologue web site. Make sure that
# the character encoding of the data file is UTF-8. Also check what kind of
# newline character(s) is being used in the data file.
#
#   load data infile "LanguageCodes.tab" into table LanguageCodes
#        fields terminated by '\t' ignore 14 lines;
#


##################################################################
# Table                : ISO_639_3
# Description          : ISO 639-3 code table downloaded from sil.org
#
# Id                   : The three-letter 639-3 identifier
# Part2B               : Equivalent 639-2 identifier of the bibliographic applications code set, if there is one
# Part2T               : Equivalent 639-2 identifier of the terminology applications code set, if there is one
# Part1                : Equivalent 639-1 identifier, if there is one
# Scope                : I(ndividual), M(acrolanguage), S(pecial)
# Type                 : A(ncient), C(onstructed), E(xtinct), H(istorical), L(iving), S(pecial)
# Ref_Name             : Reference language name
# Comment              : Comment relating to one or more of the columns
##################################################################

create table ISO_639_3 (
	Id			char(3) not null,
	Part2B			char(3),
	Part2T			char(3),
	Part1			char(2),
	Scope			char(1) not null,
	Type			char(1) not null,
	Ref_Name		varchar(150) not null,
	Comment			varchar(150),
	key (Id),
	key (Part2B),
	key (Part2T),
	key (Part1),
	key (Scope),
	key (Type),
	key (Ref_Name)
) engine=innodb, charset=utf8;


##################################################################
# Table                : ISO_639_3_Names
# Description          : Language names index downloaded from sil.org
#
# Id                   : The three-letter 639-3 identifier
# Print_Name           : One of the names associated with this identifier 
# Inverted_Name        : The inverted form of this Print_Name form
##################################################################

create table ISO_639_3_Names (
	Id			char(3) not null,
	Print_Name		varchar(75) not null,
	Inverted_Name		varchar(75) not null,
	key (Id),
	Key (Print_Name),
	key (Inverted_Name)
) engine=innodb, charset=utf8;


##################################################################
# Table                : ISO_639_3_Macrolanguages
# Description          : Macrolanguage mappings downloaded from sil.org
#
# M_Id                 : The identifier for a macrolanguage
# I_Id                 : The identifier for an individual language that is a member of the macrolanguage
# I_Status             : A (active) or R (retired) indicating the status of the individual code element
##################################################################

create table ISO_639_3_Macrolanguages (
	M_Id			char(3) not null,
	I_Id			char(3) not null,
	I_Status		char(1) not null,
	key (M_Id),
	key (I_Id),
	key (I_Status)
) engine=innodb, charset=utf8;


##################################################################
# Table                : ISO_639_3_Retirements
# Description          : Retired code elements mappings downloaded from sil.org
#
# Id                   : The three-letter 639-3 identifier
# Ref_Name             : reference name of language
# Ret_Reason           : code for retirement: C (change), D (duplicate), N (non-existent), S (split), M (merge)
# Change_To            : in the cases of C, D, and M, the identifier to which all instances of this Id should be changed
# Ret_Remedy           : The instructions for updating an instance of the retired (split) identifier
# Effective            : The date the retirement became effective
##################################################################

create table ISO_639_3_Retirements (
	Id			char(3) not null,
	Ref_Name		varchar(150) not null,
	Ret_Reason		char(1) not null,
	Change_To		char(3),
	Ret_Remedy		varchar(300),
	Effective		date not null,
	key (Id),
	key (Ref_Name),
	key (Ret_Reason),
	key (Change_To),
	key (Effective)
) engine=innodb, charset=utf8;


##################################################################
# Table                : PendingConfirmation
# Description          : Used by the registration script.
#   When someone requests a change of repository URL, we send an email to the
#   admin with a URL which confirms the change request when clicked.
# magic_string         : a 40-char string to identify the confirmation request
# repository_id        : oai repository identifier
# repository_type      : Dynamic | Static
# new_url              : new url
# ts                   : time of data entry
##################################################################

create table PendingConfirmation (
	magic_string		char(40),
	repository_id		varchar(50),
	new_url			varchar(255),
	ts			timestamp default current_timestamp,
	primary key (magic_string)
) engine=innodb;

##################################################################
# Table                : DCMITypeVocabulary
# Code                 : DCMIType vocabulary
##################################################################
create table DCMITypeVocabulary (
Code		varchar(64) unique
) engine=innodb, charset=utf8;

insert into DCMITypeVocabulary (Code) values ('Collection'),('Dataset'),('Event'),('Image'),('InteractiveResource'),('MovingImage'),('PhysicalObject'),('Service'),('Software'),('Sound'),('StillImage'),('Text');

