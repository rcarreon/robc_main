<?php
{
ob_start();  
$output = shell_exec("date +%s"); //Get timestamp CMD Line
//$output = 1357384739;
ob_get_clean();

$name="craveonline.com";
$hostname=$name;
$lasterrortime=$output;
$lasttesttime=$output;
$status="down";	

//Not including variables
//$string_pingdom= '{"checks":[{"id":359198,"created":1307909725,"name":"www.actiontrip.com","hostname":"www.actiontrip.com","resolution":1,"type":"http","lasterrortime":1357374114,"lasttesttime":1357374114,"lastresponsetime":1423,"status":"down"},{"id":359199,"created":1307909731,"name":"www.craveonline.com","hostname":"www.craveonline.com","resolution":1,"type":"http","lasterrortime":1353066485,"lasttesttime":1353502314,"lastresponsetime":1423,"status":"up"},{"id":359201,"created":1307909738,"name":"www.drinksmixer.com","hostname":"www.drinksmixer.com","resolution":1,"type":"http","lasterrortime":1346105697,"lasttesttime":1349674031,"lastresponsetime":1134,"status":"up"},{"id":359202,"created":1307909741,"name":"www.dvdfile.com","hostname":"www.dvdfile.com","resolution":1,"type":"http","lasterrortime":1354234964,"lasttesttime":1354234964,"lastresponsetime":2729,"status":"down"}]}';
//echo $string_pingdom;

$string_pingdom= '{"checks":[{"id":359198,"created":1307909725,"name":"'.$name.'","hostname":"'.$hostname.'","resolution":1,"type":"http","lasterrortime":'.$lasterrortime.',"lasttesttime":'.$lasttesttime.',"lastresponsetime":1423,"status":"'.$status.'"},{"id":359199,"created":1307909731,"name":"www.craveonline.com","hostname":"www.craveonline.com","resolution":1,"type":"http","lasterrortime":1353066485,"lasttesttime":1353502314,"lastresponsetime":1423,"status":"up"},{"id":359201,"created":1307909738,"name":"www.drinksmixer.com","hostname":"www.drinksmixer.com","resolution":1,"type":"http","lasterrortime":1346105697,"lasttesttime":1349674031,"lastresponsetime":1134,"status":"up"},{"id":359202,"created":1307909741,"name":"www.dvdfile.com","hostname":"www.dvdfile.com","resolution":1,"type":"http","lasterrortime":1354234964,"lasttesttime":1354234964,"lastresponsetime":2729,"status":"up"}]}';
echo $string_pingdom;
}
?>





