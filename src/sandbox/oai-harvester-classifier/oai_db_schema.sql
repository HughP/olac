-- MySQL dump 10.11
--
-- Host: localhost    Database: oai
-- ------------------------------------------------------
-- Server version	5.0.51a-3ubuntu5.4

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `ARCHIVED_ITEM`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `ARCHIVED_ITEM` (
  `Item_ID` int(11) NOT NULL auto_increment,
  `OaiIdentifier` varchar(255) NOT NULL,
  `DateStamp` date NOT NULL,
  `Archive_ID` int(11) default NULL,
  `Schema_ID` int(11) default NULL,
  `ts` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  `SubjectClassifiedDate` date default NULL,
  `TypeClassifiedDate` date default NULL,
  PRIMARY KEY  (`Item_ID`),
  KEY `Schema_ID` (`Schema_ID`),
  KEY `ARCHIVED_ITEM_INDEX` (`Archive_ID`,`Schema_ID`),
  KEY `OaiIdentifier` (`OaiIdentifier`),
  KEY `TypeClassifiedDate` (`TypeClassifiedDate`),
  KEY `SubjectClassifiedDate` (`SubjectClassifiedDate`),
  KEY `DateStamp` (`DateStamp`),
  CONSTRAINT `ARCHIVED_ITEM_ibfk_1` FOREIGN KEY (`Archive_ID`) REFERENCES `OLAC_ARCHIVE` (`Archive_ID`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `ARCHIVED_ITEM_ibfk_2` FOREIGN KEY (`Schema_ID`) REFERENCES `SCHEMA_VERSION` (`Schema_ID`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4601540 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `ARCHIVED_ITEM_FILTERED`
--

/*!50001 CREATE TABLE `ARCHIVED_ITEM_FILTERED` (
  `Item_ID` int(11),
  `OaiIdentifier` varchar(255),
  `DateStamp` date,
  `Archive_ID` int(11),
  `Schema_ID` int(11),
  `ts` timestamp,
  `SubjectClassifiedDate` date,
  `TypeClassifiedDate` date
) */;

--
-- Table structure for table `ARCHIVES`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `ARCHIVES` (
  `Archive_ID` int(11) NOT NULL auto_increment,
  `type` varchar(20) default NULL,
  `ID` varchar(50) NOT NULL,
  `BASEURL` varchar(255) NOT NULL,
  `contactEmail` varchar(255) default NULL,
  `dateApproved` date default NULL,
  PRIMARY KEY  (`Archive_ID`),
  UNIQUE KEY `BASEURL` (`BASEURL`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `ARCHIVE_PARTICIPANT`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `ARCHIVE_PARTICIPANT` (
  `Archive_ID` int(11) NOT NULL default '0',
  `Name` varchar(64) default NULL,
  `Role` varchar(32) NOT NULL default '',
  `Email` varchar(128) NOT NULL default '',
  PRIMARY KEY  (`Archive_ID`,`Role`,`Email`),
  CONSTRAINT `ARCHIVE_PARTICIPANT_ibfk_1` FOREIGN KEY (`Archive_ID`) REFERENCES `OLAC_ARCHIVE` (`Archive_ID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `CODE_DEFN`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `CODE_DEFN` (
  `Extension_ID` int(11) NOT NULL,
  `Code` varchar(255) NOT NULL,
  `Label` varchar(255) default NULL,
  PRIMARY KEY  (`Extension_ID`,`Code`),
  CONSTRAINT `CODE_DEFN_ibfk_1` FOREIGN KEY (`Extension_ID`) REFERENCES `EXTENSION` (`Extension_ID`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `DCMITypeVocabulary`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `DCMITypeVocabulary` (
  `Code` varchar(64) default NULL,
  UNIQUE KEY `Code` (`Code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `ELEMENT_DEFN`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `ELEMENT_DEFN` (
  `Tag_ID` smallint(6) NOT NULL,
  `DcElement` smallint(6) NOT NULL,
  `InverseElement` smallint(6) NOT NULL,
  `Rank` smallint(6) NOT NULL,
  `TagName` varchar(255) NOT NULL,
  `Label` varchar(255) NOT NULL,
  `Display` tinyint(1) default '1',
  PRIMARY KEY  (`Tag_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `EXTENSION`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `EXTENSION` (
  `Extension_ID` int(11) NOT NULL auto_increment,
  `Type` varchar(20) NOT NULL,
  `DefiningSchema` varchar(255) default NULL,
  `NS` varchar(255) NOT NULL,
  `NSPrefix` varchar(20) default NULL,
  `NSSchema` varchar(255) default NULL,
  `Label` varchar(50) default NULL,
  `LongName` varchar(50) default NULL,
  `VersionDate` date default NULL,
  `Description` varchar(255) default NULL,
  `AppliesTo` varchar(255) default NULL,
  `Documentation` varchar(255) default NULL,
  `Display` tinyint(1) default NULL,
  PRIMARY KEY  (`Extension_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `GoogleAnalyticsReports`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `GoogleAnalyticsReports` (
  `id` int(11) NOT NULL auto_increment,
  `type` varchar(16) default NULL,
  `repoid` varchar(50) default NULL,
  `start_date` date default NULL,
  `end_date` date default NULL,
  `pageviews` int(11) default NULL,
  `unique_pageviews` int(11) default NULL,
  `time_on_page` float default NULL,
  `bounce_rate` float default NULL,
  `percent_exit` float default NULL,
  `value_index` float default NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `type` (`type`,`repoid`,`start_date`),
  KEY `type_2` (`type`),
  KEY `repoid` (`repoid`),
  KEY `start_date` (`start_date`),
  KEY `end_date` (`end_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `INTEGRITY_CHECK`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `INTEGRITY_CHECK` (
  `Object_ID` int(11) NOT NULL default '0',
  `Value` varchar(255) default NULL,
  `Problem_Code` char(3) NOT NULL default '',
  `IntegrityChecked` date default NULL,
  PRIMARY KEY  (`Object_ID`,`Problem_Code`),
  KEY `Problem_Code` (`Problem_Code`),
  CONSTRAINT `INTEGRITY_CHECK_ibfk_1` FOREIGN KEY (`Problem_Code`) REFERENCES `INTEGRITY_PROBLEM` (`Problem_Code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `INTEGRITY_PROBLEM`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `INTEGRITY_PROBLEM` (
  `Problem_Code` char(3) NOT NULL,
  `Applies_To` char(1) NOT NULL,
  `Severity` char(1) NOT NULL,
  `Label` varchar(40) NOT NULL,
  `Description` varchar(255) NOT NULL,
  PRIMARY KEY  (`Problem_Code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `ISO_639_3`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `ISO_639_3` (
  `Id` char(3) NOT NULL,
  `Part2B` char(3) default NULL,
  `Part2T` char(3) default NULL,
  `Part1` char(2) default NULL,
  `Scope` char(1) NOT NULL,
  `Type` char(1) NOT NULL,
  `Ref_Name` varchar(150) NOT NULL,
  `Comment` varchar(150) default NULL,
  KEY `Id` (`Id`),
  KEY `Part2B` (`Part2B`),
  KEY `Part2T` (`Part2T`),
  KEY `Part1` (`Part1`),
  KEY `Scope` (`Scope`),
  KEY `Type` (`Type`),
  KEY `Ref_Name` (`Ref_Name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `ISO_639_3_Macrolanguages`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `ISO_639_3_Macrolanguages` (
  `M_Id` char(3) NOT NULL,
  `I_Id` char(3) NOT NULL,
  `I_Status` char(1) NOT NULL,
  KEY `M_Id` (`M_Id`),
  KEY `I_Id` (`I_Id`),
  KEY `I_Status` (`I_Status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `ISO_639_3_Names`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `ISO_639_3_Names` (
  `Id` char(3) NOT NULL,
  `Print_Name` varchar(75) NOT NULL,
  `Inverted_Name` varchar(75) NOT NULL,
  KEY `Id` (`Id`),
  KEY `Print_Name` (`Print_Name`),
  KEY `Inverted_Name` (`Inverted_Name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `ISO_639_3_Retirements`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `ISO_639_3_Retirements` (
  `Id` char(3) NOT NULL,
  `Ref_Name` varchar(150) NOT NULL,
  `Ret_Reason` char(1) NOT NULL,
  `Change_To` char(3) default NULL,
  `Ret_Remedy` varchar(300) default NULL,
  `Effective` date NOT NULL,
  KEY `Id` (`Id`),
  KEY `Ref_Name` (`Ref_Name`),
  KEY `Ret_Reason` (`Ret_Reason`),
  KEY `Change_To` (`Change_To`),
  KEY `Effective` (`Effective`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `LanguageCodes`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `LanguageCodes` (
  `LangID` char(3) default NULL,
  `CountryID` char(2) default NULL,
  `LangStatus` char(1) default NULL,
  `Name` varchar(75) default NULL,
  KEY `LangID` (`LangID`),
  KEY `Name` (`Name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `LanguageIndex`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `LanguageIndex` (
  `LangID` char(3) default NULL,
  `CountryID` char(2) default NULL,
  `NameType` char(2) default NULL,
  `Name` varchar(75) default NULL,
  KEY `LanguageIndex_LangID` (`LangID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `METADATA_ELEM`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `METADATA_ELEM` (
  `Element_ID` int(11) NOT NULL auto_increment,
  `TagName` varchar(255) NOT NULL,
  `Lang` varchar(255) default NULL,
  `Content` text,
  `Extension_ID` int(11) default '0',
  `Type` varchar(20) default NULL,
  `Code` varchar(255) default '',
  `Item_ID` int(11) default NULL,
  `Tag_ID` smallint(6) default NULL,
  PRIMARY KEY  (`Element_ID`),
  KEY `Extension_ID` (`Extension_ID`),
  KEY `Tag_ID` (`Tag_ID`),
  KEY `TagName` (`TagName`),
  KEY `Type` (`Type`),
  KEY `Code` (`Code`),
  KEY `METADATA_ELEM_INDEX` (`Item_ID`,`Tag_ID`),
  CONSTRAINT `METADATA_ELEM_ibfk_1` FOREIGN KEY (`Extension_ID`) REFERENCES `EXTENSION` (`Extension_ID`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `METADATA_ELEM_ibfk_2` FOREIGN KEY (`Item_ID`) REFERENCES `ARCHIVED_ITEM` (`Item_ID`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `METADATA_ELEM_ibfk_3` FOREIGN KEY (`Tag_ID`) REFERENCES `ELEMENT_DEFN` (`Tag_ID`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=70634526 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `Metrics`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `Metrics` (
  `archive_id` int(11) NOT NULL default '0',
  `num_resources` int(11) default NULL,
  `num_online_resources` int(11) default NULL,
  `num_languages` int(11) default NULL,
  `num_linguistic_fields` int(11) default NULL,
  `num_linguistic_types` int(11) default NULL,
  `num_dcmi_types` int(11) default NULL,
  `metadata_quality` float default NULL,
  `avg_num_elements` float default NULL,
  `std_num_elements` float default NULL,
  `avg_xsi_types` float default NULL,
  `last_updated` date default NULL,
  `integrity_problems` int(11) default NULL,
  PRIMARY KEY  (`archive_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `MetricsArchive`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `MetricsArchive` (
  `archive_id` int(11) NOT NULL default '0',
  `num_resources` int(11) default NULL,
  `num_online_resources` int(11) default NULL,
  `num_languages` int(11) default NULL,
  `num_linguistic_fields` int(11) default NULL,
  `num_linguistic_types` int(11) default NULL,
  `num_dcmi_types` int(11) default NULL,
  `metadata_quality` float default NULL,
  `avg_num_elements` float default NULL,
  `std_num_elements` float default NULL,
  `avg_xsi_types` float default NULL,
  `last_updated` date default NULL,
  `integrity_problems` int(11) default NULL,
  `ts` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  PRIMARY KEY  (`archive_id`),
  KEY `ts` (`ts`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `MetricsElementUsage`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `MetricsElementUsage` (
  `archive_id` int(11) NOT NULL default '0',
  `tag_id` int(11) NOT NULL default '0',
  `cnt` int(11) default NULL,
  PRIMARY KEY  (`archive_id`,`tag_id`),
  KEY `tag_id` (`tag_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `MetricsEncodingSchemes`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `MetricsEncodingSchemes` (
  `Archive_ID` int(11) default NULL,
  `Type` varchar(20) default NULL,
  `Count` int(11) default NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `MetricsQualityScore`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `MetricsQualityScore` (
  `Item_ID` int(11) NOT NULL default '0',
  `title` float default NULL,
  `date` float default NULL,
  `agent` float default NULL,
  `about` float default NULL,
  `depth` float default NULL,
  `content_language` float default NULL,
  `linguistic_type` float default NULL,
  `subject_language` float default NULL,
  `dcmi_type` float default NULL,
  `prec` float default NULL,
  PRIMARY KEY  (`Item_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `OLAC_ARCHIVE`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `OLAC_ARCHIVE` (
  `Archive_ID` int(11) NOT NULL auto_increment,
  `ArchiveURL` varchar(255) default NULL,
  `AdminEmail` varchar(255) default NULL,
  `Curator` varchar(255) default NULL,
  `CuratorTitle` varchar(255) default NULL,
  `CuratorEmail` varchar(255) default NULL,
  `Institution` varchar(255) default NULL,
  `InstitutionURL` varchar(255) default NULL,
  `ShortLocation` varchar(50) default NULL,
  `Location` text,
  `Synopsis` text,
  `Access` text,
  `ArchivalSubmissionPolicy` text,
  `Copyright` varchar(255) default NULL,
  `RepositoryName` varchar(255) default NULL,
  `RepositoryIdentifier` varchar(50) default NULL,
  `SampleIdentifier` varchar(255) default NULL,
  `BaseURL` varchar(255) default NULL,
  `OaiVersion` varchar(10) default NULL,
  `FirstHarvested` date default NULL,
  `LastHarvested` date default NULL,
  `LastFullHarvest` date default NULL,
  `ArchiveType` varchar(64) default NULL,
  `CurrentAsOf` date default NULL,
  `ts` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  PRIMARY KEY  (`Archive_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=470 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `PendingConfirmation`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `PendingConfirmation` (
  `magic_string` char(40) NOT NULL default '',
  `repository_id` varchar(50) default NULL,
  `new_url` varchar(255) default NULL,
  `ctype` char(1) default NULL,
  `ts` timestamp NOT NULL default CURRENT_TIMESTAMP,
  PRIMARY KEY  (`magic_string`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `SCHEMA_VERSION`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `SCHEMA_VERSION` (
  `Schema_ID` int(11) NOT NULL auto_increment,
  `SchemaName` varchar(10) default NULL,
  `Xmlns` varchar(255) NOT NULL,
  `SchemaURL` varchar(255) NOT NULL,
  PRIMARY KEY  (`Schema_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `SERVICES`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `SERVICES` (
  `Service_ID` int(11) NOT NULL auto_increment,
  `serviceName` varchar(255) default NULL,
  `serviceURL` varchar(255) default NULL,
  `institution` varchar(255) default NULL,
  `institutionURL` varchar(255) default NULL,
  `contactPerson` varchar(255) default NULL,
  `contactEmail` varchar(255) default NULL,
  `description` text,
  `dateApproved` date default NULL,
  PRIMARY KEY  (`Service_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `SOUNDEX_TABLE`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `SOUNDEX_TABLE` (
  `SoundexValue` char(4) NOT NULL default '',
  `Word` varchar(128) NOT NULL default '',
  PRIMARY KEY  (`SoundexValue`,`Word`),
  KEY `SoundexValue` (`SoundexValue`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Final view structure for view `ARCHIVED_ITEM_FILTERED`
--

/*!50001 DROP TABLE `ARCHIVED_ITEM_FILTERED`*/;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`olac`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `ARCHIVED_ITEM_FILTERED` AS select distinct `ARCHIVED_ITEM`.`Item_ID` AS `Item_ID`,`ARCHIVED_ITEM`.`OaiIdentifier` AS `OaiIdentifier`,`ARCHIVED_ITEM`.`DateStamp` AS `DateStamp`,`ARCHIVED_ITEM`.`Archive_ID` AS `Archive_ID`,`ARCHIVED_ITEM`.`Schema_ID` AS `Schema_ID`,`ARCHIVED_ITEM`.`ts` AS `ts`,`ARCHIVED_ITEM`.`SubjectClassifiedDate` AS `SubjectClassifiedDate`,`ARCHIVED_ITEM`.`TypeClassifiedDate` AS `TypeClassifiedDate` from (`ARCHIVED_ITEM` join `METADATA_ELEM` on((`ARCHIVED_ITEM`.`Item_ID` = `METADATA_ELEM`.`Item_ID`))) where (`METADATA_ELEM`.`Code` is not null) */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2009-12-02 14:52:13
