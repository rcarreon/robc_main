#!/usr/bin/php

<?php 
  include("/app/shared/http/reports/include/config.inc");
  include("/app/shared/http/reports/include/functions.inc");
  include("/app/shared/http/reports/include/mysql-connect.inc");

  $link = database_open("$mysql_host", "w");

  if (!is_object($link)) {
     die('Could not connect: ' . mysqli_connect_error());
  }

$space="\n";

//DELETE ALL RELATIONSHIP IN rpt_sitehost
$query="DELETE from rpt_sitehost;";
$result= database_query($query,$link);
if (!$result) {
    echo 'Error: ' . mysql_error();
    exit;
}
echo "Done DELETE from rpt_sitehost ".$space; 

//DELETE ALL rpt_hosts
$query="DELETE from rpt_hosts;";
$result= database_query($query,$link);
if (!$result) {
    echo 'Error: ' . mysql_error();
    exit;
}
echo "Done DELETE from rpt_hosts ".$space;

//SELECT * SITES
$query="SELECT * FROM rpt_sites";
$result= database_query($query,$link);
if (!$result) {
    echo 'Error: ' . mysql_error();
    exit;
}

$space="\n";
//$space="<br />";
while ($array_sites = database_fetch_object($result)) {
    //printf("Name: %s <br/>", $fila->name );
echo $array_sites->id." ".$array_sites->name.$space;
//print_r($fila);  

//$line=explode("\n",file_get_contents("http://vipvisual.gnmedia.net/extractServer?value=$array_sites->name"));
$line=explode("\n",fetchURL("http://vipvisual.gnmedia.net/extractServer?value=$array_sites->name"));
$last=$line[count($line)-1];
$hosts=str_replace(" ","",str_replace("net","net\n",strip_tags($last)));
$host_array=explode("\n",$hosts);

  if(count($host_array)-1==0){
    echo "count(host_array) ".count($host_array).$space;
    echo "host_array vacio ".$space.$host_array[0].$space.$host_array[1].$space;
    echo "No hosts to insert for ".$array_sites->name.$space;
  }
  else{
    for($i = 0; $i < count($host_array)-1; $i++) {
      if(ifexist(($host_array[$i]),$link)){
        //Check if is already inserted if not insert
        $query="INSERT into rpt_hosts (`id`,`name`) VALUES (NULL,'".$host_array[$i]."');";
        echo $query.$space;
        $result2= database_query($query,$link);
        if (!$result2) {
          echo 'Error: ' . mysql_error();
          exit;
        }
      }
      $query="INSERT into rpt_sitehost (`id`,`sites_id`,`hosts_id`) VALUES (NULL,'.".$array_sites->id.".',(SELECT id FROM  rpt_hosts WHERE name='".$host_array[$i]."'));";
      echo $query.$space;
      $result3= database_query($query,$link);
      if (!$result3) {
        echo 'Error: ' . mysql_error();
        exit;
      }
    }
  }
}
mysql_free_result($result);
mysql_free_result($result2);
mysql_free_result($result3);
mysql_free_result($result4);
database_close($link);
echo "Updated Succesfully.."; 
?>
