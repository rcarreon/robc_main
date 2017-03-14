<?php
function emulate_pingdom_json ()
{
  ob_start();
  $output = shell_exec("date +%s"); //Get timestamp CMD Line
//$output = 1357976607;
  ob_get_clean();

//$output = 1357977917;
  $name1 = "craveonline.com";
  $hostname1 = $name1;
  $lasterrortime1 = $output;
  $lasttesttime1 = $output;
//$status1="unconfirmed_down";
//$status1="down";	
  $status1 = "up";

//$output = 1357977915;
  $name2 = "myanimelist.net";
  $hostname2 = $name2;
  $lasterrortime2 = $output;
  $lasttesttime2 = $output;
  $status2="unconfirmed_down";
//$status2="down";	
  //$status2 = "up";

//Not including variables
//$string_pingdom= '{"checks":[{"id":359198,"created":1307909725,"name":"www.actiontrip.com","hostname":"www.actiontrip.com","resolution":1,"type":"http","lasterrortime":1357374114,"lasttesttime":1357374114,"lastresponsetime":1423,"status":"down"},{"id":359199,"created":1307909731,"name":"www.craveonline.com","hostname":"www.craveonline.com","resolution":1,"type":"http","lasterrortime":1353066485,"lasttesttime":1353502314,"lastresponsetime":1423,"status":"up"},{"id":359201,"created":1307909738,"name":"www.drinksmixer.com","hostname":"www.drinksmixer.com","resolution":1,"type":"http","lasterrortime":1346105697,"lasttesttime":1349674031,"lastresponsetime":1134,"status":"up"},{"id":359202,"created":1307909741,"name":"www.dvdfile.com","hostname":"www.dvdfile.com","resolution":1,"type":"http","lasterrortime":1354234964,"lasttesttime":1354234964,"lastresponsetime":2729,"status":"down"}]}';
//echo $string_pingdom;

  $string_pingdom = '{"checks":[
{"id":359198,"created":1307909725,"name":"' . $name1 . '","hostname":"' . $hostname1 . '","resolution":1,"type":"http","lasterrortime":' . $lasterrortime1 . ',"lasttesttime":' . $lasttesttime1 . ',"lastresponsetime":1423,"status":"' . $status1 . '"},
{"id":359198,"created":1307909342,"name":"' . $name2 . '","hostname":"' . $hostname2 . '","resolution":1,"type":"http","lasterrortime":' . $lasterrortime2 . ',"lasttesttime":' . $lasttesttime2 . ',"lastresponsetime":1741,"status":"' . $status2 . '"},
{"id":359202,"created":1307909741,"name":"www.dvdfile.com","hostname":"www.dvdfile.com","resolution":1,"type":"http","lasterrortime":1354234964,"lasttesttime":1354234964,"lastresponsetime":2729,"status":"up"}]}';
  return($string_pingdom);
}

