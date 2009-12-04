/* This is sample syntax to completely remove an archive from the olac/oai db
    TODO: Make a script that can automate this and accept either the archive ID or the BaseURL of the archive as the identifier
*/

delete from METADATA_ELEM using METADATA_ELEM,ARCHIVED_ITEM where ARCHIVED_ITEM.Item_ID = METADATA_ELEM.Item_ID and ARCHIVED_ITEM.Archive_ID = 471;
delete from ARCHIVED_ITEM where Archive_ID = 471;
delete from OLAC_ARCHIVE where Archive_ID = 471;
