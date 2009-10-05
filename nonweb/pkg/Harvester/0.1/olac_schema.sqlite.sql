

create table OLAC_ARCHIVE (
	Archive_ID		int auto_increment ,
	ArchiveURL		varchar(255),
	AdminEmail		varchar(255),
	Curator			varchar(255) ,
	CuratorTitle		varchar(255),
	CuratorEmail		varchar(255),
	Institution		varchar(255) ,
	InstitutionURL		varchar(255),
	ShortLocation		varchar(50) ,
	Location		text,
	Synopsis		text,
	Access			text,
	ArchivalSubmissionPolicy	text,
	Copyright		varchar(255),
	RepositoryName		varchar(255) ,
	RepositoryIdentifier	varchar(50),
	SampleIdentifier	varchar(255),
	BaseURL			varchar(255) ,
	OaiVersion		varchar(10) ,
	FirstHarvested		date,
	LastHarvested		date,
	LastFullHarvest		date,
	ArchiveType		varchar(64),
	CurrentAsOf		date,
	ts			datetime,
	primary key (Archive_ID));
 



create table SCHEMA_VERSION (
	Schema_ID		int auto_increment primary key,
	SchemaName		varchar(10),
	Xmlns			varchar(255) ,
	SchemaURL		varchar(255) 
	);


create table ARCHIVED_ITEM (
	Item_ID			int auto_increment ,
	OaiIdentifier		varchar(255) ,
	DateStamp		date ,
	Archive_ID		int,
	Schema_ID		int,
	ts			datetime,
	primary key (Item_ID),
	foreign key (Archive_ID) references OLAC_ARCHIVE (Archive_ID)
        on delete set null
        on update cascade,
	foreign key (Schema_ID) references SCHEMA_VERSION (Schema_ID)
        on delete set null
        on update cascade);
 
create index ARCHIVED_ITEM_INDEX on ARCHIVED_ITEM (Archive_ID, Schema_ID);



create table ELEMENT_DEFN (
	Tag_ID			smallint ,
        DcElement               smallint ,
        InverseElement          smallint ,
	Rank			smallint ,
	TagName			varchar(255) ,
	Label			varchar(255) ,
	Display			tinyint(1) ,
	primary key (Tag_ID));
 

create table METADATA_ELEM (
    Element_ID      int auto_increment ,
    TagName         varchar(255) ,
    Lang            varchar(255),
    Content         text,
    Extension_ID    int default 0,
    Type            varchar(20),
    Code            varchar(255) default '',
    Item_ID         int,
    Tag_ID          int,
	primary key (Element_ID),
	foreign key (Extension_ID) references EXTENSION (Extension_ID)
        on delete set null 
        on update cascade,
	foreign key (Item_ID) references ARCHIVED_ITEM (Item_ID)
        on delete set null
        on update cascade,
	foreign key (Tag_ID) references ELEMENT_DEFN (Tag_ID)
        on delete set null
        on update cascade);

create index METADATA_ELEM_INDEX on METADATA_ELEM (Item_ID, Tag_ID);


create table CODE_DEFN (
	Extension_ID    int ,
	Code            varchar(255) ,
	Label           varchar(255),
        primary key (Extension_ID, Code),
	foreign key (Extension_ID) references EXTENSION (Extension_ID)
        on delete set null
        on update cascade);


create table EXTENSION (
	Extension_ID		int auto_increment ,

	Type			varchar(20) ,
	DefiningSchema		varchar(255),
	NS			varchar(255) ,
	NSPrefix		varchar(20),
	NSSchema		varchar(255),

	Label			varchar(50),
	LongName		varchar(50),
        VersionDate             date,
        Description             varchar(255),
        AppliesTo               varchar(255),
        Documentation           varchar(255),
	Display			tinyint(1),

	primary key (Extension_ID)
);

