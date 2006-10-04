#
# CVS Info: $Header: /cvsroot/olac/olac_suite/mu_tools/lib/searchTables.sql,v 1.2 2004/12/06 00:22:11 badenh Exp $
#


CREATE TABLE TAG_USAGE (
	Tag_ID int(11) not null,
	Percent double(3,2) default null,
	Rank int(2) not null,
	PRIMARY KEY(Tag_ID)
);

CREATE TABLE ITEM_SCORES
(
	Item_ID int(11) not null,
	Item_Score int(1) default '0',
	PRIMARY KEY (Item_ID)
);

CREATE TABLE SOUNDEX_TABLE (
   SoundexValue varchar(25) NOT NULL,
   Word varchar(40) NOT NULL,
   PRIMARY KEY (SoundexValue, Word)
);


CREATE INDEX SOUNDEX_INDEX ON SOUNDEX_TABLE(SoundexValue);

CREATE TABLE LanguageSoundex 
SELECT li.*, SUBSTRING(SOUNDEX(li.Name) , 1, 4) as SoundexValue
FROM LanguageIndex li;

CREATE INDEX LangSoundexIndex on LanguageSoundex(SoundexValue);

ALTER TABLE METADATA_ELEM ADD FULLTEXT metadataContentIndex (Content);

ALTER TABLE LanguageSoundex ADD FULLTEXT langSoundexNameIndex (Name);
