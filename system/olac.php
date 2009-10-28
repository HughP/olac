<?php
function olacvar($name)
{
  $out = array();
  $res = exec("olacvar $name", $out);
  return $out[0];
}
?>
