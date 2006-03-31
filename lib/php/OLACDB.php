<?php

#
# Changes:
#
# 2005-01-06  Haejoong Lee  <haejoong@ldc.upenn.edu>
#	* saw_error() didn't work in case of errors occurred in sql()
#

require_once("DB.php");

class OLACDB
{
  var $db;
  var $err;
  var $err_sql;

  function OLACDB($dbname)
  {
    $dsn = trim(file_get_contents("/home/olac/.mysqlpass"));
    $this->db = DB::connect($dsn);
    if (DB::isError($this->db))
      $this->err = $this->db;
    else
      $this->db->fetchmode = DB_FETCHMODE_ASSOC;
  }

  function _OLACDB()
  {
    $this->db->disconnect();
  }

  function sql($sql)
  {
    $this->err = "";
    $res = $this->db->simpleQuery($sql);
    if ($this->db->isError($res)) {
      $this->err = $res;
      $this->err_sql = $sql;
      return false;
    }
    $row = $this->db->fetchRow($res);
    while ($row) {
      $rows[] = $row;
      $row = $this->db->fetchRow($res);
    }
    $this->db->freeResult($res);
    return $rows;
  }

  function saw_error()
  { return DB::isError($this->db) || $this->db->isError($this->err); }

  function get_error_message()
  { return $this->err->getMessage(); }

  function get_error_sql()
  { return $this->err_sql; }

}

?>
