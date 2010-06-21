<?php

require_once('lib/php/OLACDB.php');
$DB = new OLACDB();

function error($msg) {
  echo "<p>ERROR: $msg</p>";
  exit(0);
}

# get area name
$path = preg_split('#/#', $_SERVER['PATH_INFO']);
$area_name = $path[1];
$Area_name = ucfirst($area_name);
$the_area_name = $Area_name;
if ($area_name == 'pacific' || $area_name == 'americas')
  $the_area_name = "the " . $Area_name;

$s = mysql_real_escape_string($area_name);
$sql = "select count(*) c from CountryCodes where Area='$s'";
$tab = $DB->sql($sql);
if ($DB->saw_error()) error("internal server error");
if ($tab[0]['c'] == 0) error("unrecognized area name: $area_name");

# get language table
$sql = "select li.Name, li.CountryID, count(distinct ai.Item_ID) c
        from ARCHIVED_ITEM ai,
             METADATA_ELEM me,
             (select distinct substring_index(cc.Name,' (',1) Name, cc.CountryID, li.LangID
              from LanguageCodes li, CountryCodes cc
              where li.CountryID=cc.CountryID
                and cc.Area='$area_name'
                and li.LangStatus='L') li
        where ai.Item_ID=me.Item_ID
          and me.TagName in ('subject','language')
          and me.Code=li.LangID
        group by li.Name
        order by li.Name";
$tab = $DB->sql($sql);
if ($DB->saw_error()) error("internal server error");

# compose title
$title = "Resources for languages in $the_area_name";

?>
<html>
<head>
<title><?=$title?></title>
<meta http-equiv="Content-type" content="text/html;charset=UTF-8" />
<link rel="stylesheet" type="text/css" href="/olac.css">
<link type="text/css" rel="stylesheet" href="/css/search/main.css"></link>
<script type="text/javascript" src="/js/XMLHttpRequest.js"></script>
<script type="text/javascript" src="http://www.google.com/jsapi"></script>
<script type="text/javascript" src="/js/search/main.js"></script>
<script type="text/javascript">
  google.setOnLoadCallback(function() {
      initialize('area_<?=$area_name?>', '<?=$area_name?>');
    });
</script>
<script type="text/javascript" src="/js/gatrack.js"></script>
</head>
<body>

<!-- It's difficult to implement a layout with css, so we use table. -->
<center>
  <div class='searchtitle'>Search Open Language Archives (<?=$Area_name?>)</div>

  <img id="world-map" src="/images/world-color-<?=$area_name?>-320.png" alt="World Map" usemap="#areas"></img>
  <map name="areas">
    <area id="area-africa" shape="poly" coords="136,45,127,60,127,71,136,78,149,77,159,118,171,116,179,103,186,109,192,94,188,92,183,96,182,88,193,69,184,70,173,49,163,47,161,49,154,46,153,43,139,44" alt="Africa"  nohref="nohref" />
    <area id="area-americas" shape="poly" coords="11,25,22,22,34,10,62,12,77,5,83,6,102,1,142,3,131,13,109,21,103,33,73,50,91,66,90,72,116,88,91,125,100,134,91,139,80,129,77,100,65,85,69,75,57,66,46,65,35,40,40,31,41,23,37,21,16,28" alt="Americas"  nohref="nohref" />
    <area id="area-asia" shape="poly" coords="207,57,218,77,220,65,226,61,239,89,262,92,261,84,268,86,266,90,269,90,272,87,275,91,275,82,264,77,258,59,271,43,268,38,283,14,233,4,196,2,200,7,191,9,193,29,181,30,185,34,185,38,165,39,168,45,176,45,175,50,184,68,197,63,199,56" alt="Asia"  nohref="nohref" />
    <area id="area-europe" shape="poly" coords="135,42,142,45,148,37,152,37,152,40,157,40,157,43,161,40,165,44,165,38,169,37,172,35,176,34,178,37,184,36,184,33,180,30,192,28,192,12,184,13,191,8,183,1,154,3,148,19,131,14,129,17,141,21,135,29,143,35,136,35" alt="Eurpoe"  nohref="nohref" />
    <area id="area-pacific" shape="poly" coords="265,93,245,104,246,119,262,116,269,128,284,127,286,132,304,119,299,115,284,126,274,125,285,108,320,96,319,92,303,97,286,83,283,86,275,82,275,98" alt="Pacific"  nohref="nohref" />
  </map>

  <div id="search-box"></div>

  <form>
    Archive:
    <select id="archive-selector">
      <option>-- all archives --</option>
    </select>
  </form>

  Region:
    <a href="/area/africa">Africa</a>
    <a href="/area/americas">Americas</a>
    <a href="/area/asia">Asia</a>
    <a href="/area/europe">Europe</a>
    <a href="/area/pacific">Pacific</a>
</center>

<div id="result-box">
<center>
<hr>

<p class="narrow-p">The combined OLAC catalog has resources for languages that
are spoken in <?=$the_area_name?>.
The number in parentheses is the number of items cataloged for
languages for which the shown country is the primary country.</p>

<table>
<tr><td><ul>
<?php
$n = ceil(sizeof($tab) / 4);
$c = 0;
foreach ($tab as $row) {
  if ($c > 0 && $c % $n == 0)
    echo "</ul></td><td><ul>";
  #$a = preg_split('#\s*,\s*#', $row['LangName']);
  #$langname = rtrim("$a[1] $a[0]");
  $langname = $row['Name'];
  echo "<li>";
  echo "<a href=\"/country/$row[CountryID]\">$langname</a> ($row[c])";
  echo "</li>";
  $c += 1;
}
?>
</ul></td></tr>
</table>
<hr>

</center>
</div>

<center>
<a class="bottomsign" href="/">OLAC: Open Language Archives Community</a>
<br><br>
<a href="/"><img src="/images/olac100.gif"></img></a>
</center>
</body>
</html>
