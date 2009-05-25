<?php
    header("content-type: text/xml"); 
/*
 *    OLAC static repository output script for a metadata catalogue
 *
 *     by Matthew Baxter for OLAC (employed by UniMelb)
 *    Last edited on 24/05/2009
 */

    $cachefile = 'cache.xml';
    $cachetime = 7200; // Number of seconds to cache this script for.
    
    if(file_exists($cachefile) && time() - $cachetime < filemtime($cachefile))
    {
        readfile($cachefile);
        exit();
    }

    ob_start();
    echo '<?xml version="1.0" encoding="iso-8859-1"?>';
?>


<Repository
     xmlns="http://www.openarchives.org/OAI/2.0/static-repository"
     xmlns:oai="http://www.openarchives.org/OAI/2.0/"
     xmlns:olac="http://www.language-archives.org/OLAC/1.1/"
     xmlns:dc="http://purl.org/dc/elements/1.1/"
     xmlns:dcterms="http://purl.org/dc/terms/"
     xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
     xsi:schemaLocation="
      http://www.openarchives.org/OAI/2.0/static-repository
      http://www.language-archives.org/OLAC/1.1/static-repository.xsd
      http://www.language-archives.org/OLAC/1.1/
      http://www.language-archives.org/OLAC/1.1/olac.xsd
      http://purl.org/dc/elements/1.1/
      http://dublincore.org/schemas/xmls/qdc/2006/01/06/dc.xsd
      http://purl.org/dc/terms/
      http://dublincore.org/schemas/xmls/qdc/2006/01/06/dcterms.xsd
    ">
    <Identify>
     <oai:repositoryName>ARCHIVE NAME</oai:repositoryName>
     <oai:baseURL>URL OF THIS FILE</oai:baseURL>
     <oai:protocolVersion>2.0</oai:protocolVersion>
     <oai:adminEmail>EMAIL ADDRESS OF MAINTAINER OF THIS FILE</oai:adminEmail>
     <oai:earliestDatestamp>ENTER DATE USING FORMAT YYYY-MM-DD</oai:earliestDatestamp>
     <oai:deletedRecord>no</oai:deletedRecord>
     <oai:granularity>YYYY-MM-DD</oai:granularity>
     <oai:description>
      <oai-identifier
        xmlns="http://www.openarchives.org/OAI/2.0/oai-identifier"
        xsi:schemaLocation="
         http://www.openarchives.org/OAI/2.0/oai-identifier
         http://www.openarchives.org/OAI/2.0/oai-identifier.xsd
       ">
       <scheme>oai</scheme>
       <repositoryIdentifier>DOMAIN-NAME</repositoryIdentifier>
       <delimiter>:</delimiter>
       <sampleIdentifier>oai:DOMAIN-NAME:ITEM-IDENTIFIER</sampleIdentifier>
      </oai-identifier>
     </oai:description>
     <oai:description>
      <olac-archive
      currentAsOf="<?php echo(strftime('%Y-%m-%d')); ?>"
       type="institutional"
       xmlns="http://www.language-archives.org/OLAC/1.1/olac-archive"
       xsi:schemaLocation="
        http://www.language-archives.org/OLAC/1.1/olac-archive
        http://www.language-archives.org/OLAC/1.1/olac-archive.xsd
      ">
      <archiveURL>WEBSITE OF ARCHIVE</archiveURL>
      <participant name="NAME" role="ROLE" email="EMAIL"/>
      <institution>INSTITUTION NAME</institution>
      <institutionURL>INSTITUTION URL</institutionURL>
      <shortLocation>CITY, COUNTRY</shortLocation>
      <location>POSTAL-ADDRESS</location>
      <synopsis>SYNOPSIS</synopsis>
      <access>ACCESS</access>
     </olac-archive>
     </oai:description>
    </Identify>
    <ListMetadataFormats>
     <oai:metadataFormat>
      <oai:metadataPrefix>olac</oai:metadataPrefix>
      <oai:schema>http://www.language-archives.org/OLAC/1.1/olac.xsd</oai:schema>
     <oai:metadataNamespace>http://www.language-archives.org/OLAC/1.1/</oai:metadataNamespace>
    </oai:metadataFormat>
    </ListMetadataFormats>
    <ListRecords metadataPrefix="olac">

<?php
define("safe_include", TRUE);
require("conn.php");
require("htmlToXmlEntities.php");

/*****************************
 * MAIN CODE
 * Establishes a database connection & loops through items.
 */

// Initialise a database connection
$conn = new DbConn;
$conn->conn();

//Import small tables
$smallTables = $conn->importSmallTables();

// Loop through the resources, converting and outputting each one
$res = $conn->next();
while($res != false) {
    res2olac($res, $smallTables);
    $res = $conn->next();
}


/*****************************
 * CONNECTION TO DATABASE
 * DbConn - A class which extracts data from the mySQL database
 */
class DbConn {
    private $connID; //Connection Number
    private    $resultID=Null; //Result Number of the main query's result.
    private $uniqueNum = 1;
    
    //Establishes a connection to mySQL and makes the query for all resources
    public function conn() {
        $this->connID = conn();
        /* The main query which returns a list of resources.
         * Add any LEFT JOINs here as required.
         */
        $query = 'select resource_id, date_modified, identifier from resource';
        $this->resultID = mysql_query($query, $this->connID); //main query
    }
    
    //Creates in-php copies of some smaller tables
    public function importSmallTables() {
        $smallTables = array();
        
        /* A list of tables to import.
         * 
         * The keys are the SQL tables and the values are
         * a comma-separated list of the columns we want, or "*" for all.
         *
         * The key strings can contain joins, or any other valid mySQL code.
         */
        $tables_to_import = array(
            'language' => 'language_id, name, language_code',
            'genre' => 'genre_id, name');
        
        $queryA = "select ";
        $queryB = " from ";
        foreach($tables_to_import as $table => $columns) {
          $smallTables[$table] = array();
          
          $resultID3 = mysql_query($queryA . $columns . 
            $queryB . $table , $this->connID);
          $indexColName = mysql_field_name($resultID3, 0);
          
          while($row = mysql_fetch_assoc($resultID3)) {
            
            $index = $row[$indexColName];
            unset($row[$indexColName]);
            
            $smallTables[$table][$index] = $row;
          }
        }
        
        return $smallTables;
    }
    
    // Returns all the data about the next resource.
    public function next() {
        /* $res will eventually contain all relevant data on the current
         * resource. It is initalised with all the data from the resource
         * table.
         */
        if(($res = mysql_fetch_assoc($this->resultID)) == NULL) return false;
        
        /* A contains a list of tables, each indexed by resource id, 
         * where there may be more than one entry for a given
         * resource. (otherwise you could just use a LEFT JOIN
         * in the first query)
         * 
         * The keys of A are the SQL tables and the values are
         * a comma-separated list of the columns we want, or "*" for all.
         *
         * The key strings can contain joins, or any other valid mySQL code
         * but only the name of the database will be used in the index of
         * the result array.
         *
         * The key strings starting with "#" indicates we want the result
         * rows split up (see comments below).
         */
        $A = array('#language_to_resource' => 'language_id',
                '#genre_to_resource' => 'genre_id',
                'resource_description' => 'description_text, language',
                'resource_title' => 'title_text, language',
                //This is a nice & complicated one :)
                'contributor_to_resource 
                LEFT JOIN contributor 
                ON contributor_to_resource.contributor_id=contributor.contributor_id 
                LEFT JOIN role ON role.role_id = contributor_to_resource.role_id'
                    => 'first_name, last_name, role_name, keep_anonymous');
                
        
        $whereClause = " where resource_id=" . $res["resource_id"];;
        $this->grab_rows($A, $whereClause, true, $res);
        
        
        return $res;
    }
    
    /*********  grab_rows($A, $whereClause, &$ret)
     * Iterates over rows from (multiple) tables (one table at a time)
     * and adds data from the rows into an array 
     *
     * $A contains a list of tables.$res['identifier']
     *   The keys of A are the SQL tables and the values are
     *   a comma-separated list of the columns we want, or "*" for all.
     * 
     *   If the key starts with a "#", that character will be removed and
     *   the value of each cell of each row from each table will be added
     *     individually to &$ret, indexed by its column name.
     *     If not then each row from each table will be added to &$ret as
     *   an array (with column names as indices and cell values as values)
     *   indexed by its table name.
     *
     *   The key strings can contain joins, or any other valid mySQL code
     *   but only the name of the database will be used in the index of
     *   the result array (in the case where entire rows are added).
     * 
     * $whereClause should be an empty string, or a mySQL where clause
     *   which will be used to restrict the results.
     *
     * $unique is a boolean
     *   if true then a unique number will be appended to each index so
     *   that multiple rows can be grabbed from the same table without
     *     the previous row(s) value(s) being overwritten by the lates.
     *     (essentially it uses &$ret as a list of pairs rather than a
     *   dictionary)
     * 
     * &$ret is an array for the results. Passed by reference.
     */
    private function grab_rows($A, $whereClause, $unique, &$ret) {
        $queryA = "select ";
        $queryB = " from ";
        foreach($A as $table => $columns) {
          //If the table name starts with "#", note this and remove the "#"
          if(substr($table, 0, 1) == '#') {
            $split = true;
            $table = substr($table, 1); // Remove the # character.
          } else {
            $split = false;
          }
          
          $resultID2 = mysql_query($queryA . $columns . $queryB . 
              $table . $whereClause, $this->connID);
          
          $rowIndex = 0;
          while($rowIndex < mysql_num_rows($resultID2)) {
            mysql_data_seek($resultID2, $rowIndex);
            $row = mysql_fetch_assoc($resultID2);
            
            if($split) {
                foreach($row as $column_name => $data) {
                    if($unique) {
                        $ret[$column_name . $this->uniqueNum] = $data;
                        $this->uniqueNum++; //increment to ensure it's unique
                    } else {
                        $ret[$column_name] = $data;
                    }
                }
            }
            else {
                // Remove any left joins from name
                $table = explode(' ', $table);  
                
                $table = $table[0]; // (just keep table name)
                
                if($unique) {
                    $ret[$table . $this->uniqueNum] = $row;
                    $this->uniqueNum++; //increment to ensure it's unique
                } else {
                    $ret[$table] = $row;
                }
            }
            $rowIndex++;
          }
        }
    }
}

/*****************************
 * RESOURCE to <record>
 * Code to output individual resources.
 */


/* Takes an array of attributes of the format output by 
 * DbConn->next() and prints out a complete <oai:record> element.
 */
function res2olac($res, $smallTables) {
    //Maps from Database columns to the functions which transform them.
    $mapC = array(
        'LANGUAGE_ID' => 'fn_lang',
        'GENRE_ID' => 'fn_genre',
        'CONTRIBUTOR_TO_RESOURCE' => 'fn_contrib',
        'RESOURCE_DESCRIPTION' => 'fn_desc',
        'RESOURCE_TITLE' => 'fn_title'
    );
    
    if($res['date_modified'])
        $datestamp = strftime('%Y-%m-%d', strtotime($res['date_modified']));
    else;
        // Default to earliest datestamp TEST
        $datestamp = '2004-02-28';
    
    
    // Header & start the metadata list.
    $identifier = $res['identifier'];
    echo("\n    <oai:record>
         <oai:header>
          <oai:identifier>oai:www.ailla.utexas.org:$identifier</oai:identifier>
          <oai:datestamp>$datestamp</oai:datestamp>
         </oai:header>
         <oai:metadata>
          <olac:olac>");
    
    // Output the metadata elements
    foreach($res as $field => $value) {
        // Uppercase & get rid of the number on the end.
        $field = strrev(strtoupper($field));
        sscanf('1'.$field, '%d%s', $ignore_me, $field);
        $field = strrev($field);

        // Calls the relevant function to transform the column(s).    
        if($mapC[$field])
            $mapC[$field]($value, $smallTables);
    }
    
    // end the metadata list.
    echo("\n          </olac:olac>
     </oai:metadata>
    </oai:record>");
}

/*****************************
 * DATABASE Column(s) to METADATA
 * Code to output individual metadata elements
 */


// Outputs a <dc:subject> using OLAC's language type 
function fn_lang($langid, $smallTables) {
    $whitespace = "\n           ";
    
    echo($whitespace . '<dc:subject xsi:type="olac:language" olac:code="' .
        $smallTables['language'][$langid]['language_code'] . '">' .
        clean_text($smallTables['language'][$langid]['name']) . '</dc:subject>');
}

//BEGIN Code very specific to AILLA


;

function fn_genre($genreid, $smallTables) {
    /* Maps from AILLA genres to OLAC discourse types.
     * Note that not all genres are discourse, eg. book or lexicon
     *
     *The mappings to the latest (still in draft as of 9/2/2009) types
     * are commented out since they are not in use. */
    $genre_to_discourse = array(
        'Conversation' => 'dialogue',#'interactive_discourse',
        'Debate' => 'oratory',
        'Correspondence' => 'dialogue',#'interactive_discourse',
        'Interview' => 'dialogue',#'interactive_discourse',
        'Meeting' => 'dialogue',#'interactive_discourse',
        'Greeting/Leave-Taking' => 'dialogue',#'interactive_discourse',
        'Procedure' => 'procedural',#'procedural_discourse',
        'Recipe' => 'procedural',#'procedural_discourse',
        'Instructions' => 'procedural',#'procedural_discourse',
        'Description' => 'procedural',#'procedural_discourse',
        'Narrative' => 'narrative',
        'Oratory' => 'oratory',
        'Drama' => 'drama',
        'Unintelligible speech' => 'unintelligible_speech',
        'Song' => 'singing',
        'Chant' => 'singing',
        'Curse' => 'formulaic',#'formulaic_discourse',
        'Myth' => 'narrative',
        'Speech play' => 'ludic',#'language_play',
        'Prayer' => 'formulaic',#'formulaic_discourse',
        'Dispute' => 'dialogue',#'interactive_discourse'
        'Ritual Song' => 'singing'
    ); //TODO - a few genres are not yet mapped.
    
    //Maps from AILLA genres to OLAC linguistic data types
    $genre_to_linguistic = array(
        'Lexicon' => 'lexicon',
        'Grammar' => 'language_description',
        'Wordlist' => 'lexicon',
        'Field notes' => 'language_description'
    ); //TODO - a few genres are not yet mapped.

    //TODO - Some genres could map to DCMI Type vocab or OLAC linguistic type.

    /* These genres are well described by their mapped OLAC type,
     * and so don't need to be output twice. */
    $discard_ailla_genre = array('Narrative', 'Oratory', 'Drama', 'Lexicon');
    $whitespace = "\n           ";

    $genre = $smallTables['genre'][$genreid]['name'];

    $discourse = $genre_to_discourse[$genre];
    if($discourse) {
        echo($whitespace .
            '<dc:type xsi:type="olac:discourse-type" olac:code="' . 
            $discourse. '"/>');
    }

    $linguistic = $genre_to_linguistic[$genre];
    if($linguistic) {
        echo($whitespace .
            '<dc:type xsi:type="olac:linguistic-type" olac:code="'
            . $linguistic . '"/>');
    }

    if(!(($discourse || $linguistic) &&
            in_array($genre, $discard_ailla_genre))) {
        echo($whitespace . "<dc:type>" . $genre . "</dc:type>");
    }
}


//END Code very specific to AILLA

/*
    //This a simpler version of the above, which does not attempt
    //to map AILLA genres to OLAC vocab.    
function fn_genre($genreid, $smallTables) {
    $whitespace = "\n           ";
    
    $genre = $smallTables['genre'][$genreid]['name'];
    
    echo($whitespace . "<dc:type>" . $genre . "</dc:type>");
}
*/

// Outputs a <dc:contributor> or <dc:role>
function fn_contrib($contrib, $smallTables) {
    $whitespace = "\n           ";
    if($contrib['keep_anonymous'] != 'N') return;
    
    $role = strtolower($contrib['role_name']);
    // Best Practice is to place surname first.
    $name = clean_text($contrib['last_name'] . ', ' . $contrib['first_name']);
    
    // Some AILLA specific transformations.
    if ($role == "interlocutor")
        $role = "responder";
    elseif ($role == "filmer")
        $role = "photographer";
    elseif ($role == "research participant")
        $role = "research_participant";
    elseif ($role == "contributor") {
        echo ($whitespace . "<dc:contributor>$name</dc:contributor>");
        return;
    }
    elseif ($role == "creator") {
        echo ($whitespace . "<dc:creator>$name</dc:creator>");
        return;
    }

    echo($whitespace . 
        "<dc:contributor xsi:type='olac:role' olac:code='$role'>" .
        "$name</dc:contributor>");
}

/* Note:
 * AILLA stores titles and descriptions in English, Spanish and in some
 * case the subject language as well. I have chosen to output them all
 * and tag them with the relevant xml:lang in order to distinguish between
 * them. */

// Outputs a <dc:description>
function fn_desc($desc, $smallTables) {
    $whitespace = "\n           ";
    $text = clean_text($desc['description_text']);
    if($text == '') return;
    $lang = $desc['language'];
    
    if($lang == 'other') $lang = "";
    else $lang = " xml:lang='$lang'";
    
    echo($whitespace . "<dc:description$lang>$text</dc:description>");
}

// Outputs a <dc:title>
function fn_title($title, $smallTables) {
    $whitespace = "\n           ";
    $text = clean_text($title['title_text']);
    if($text == '') return;
    $lang = $title['language'];
    
    if($lang == 'other') $lang = "";
    else $lang = " xml:lang='$lang'";
    
    echo($whitespace . "<dc:title$lang>$text</dc:title>");
}

//Clean up text so that it doesn't cause XML parse errors.
//This function will probably have to be adapted for each database.
function clean_text($text) {
    //replace <br> with newline characters.
    $ret = str_replace('<br/>', "\n", $text);
    $ret = str_replace('<br>', "\n", $ret);
    $ret = str_replace('<br />', "\n", $ret);

    //Get rid of anything in an <ailla_note> tag
    $ret = preg_replace('/<ailla_note>(.)*<\/ailla_note>/', '', $ret);

    //convert HTML entities to XML escape codes.    
    return convertHtmlEntities($ret);
}

?>

    </ListRecords>
</Repository>

<?

$fp = fopen($cachefile, 'w');

fwrite($fp, ob_get_contents());
fclose($fp);

ob_end_flush();

?>
