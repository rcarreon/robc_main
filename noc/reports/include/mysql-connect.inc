<?php
  //reports.hmo.gnmedia.net 192.168.99.161
 /* $mysql_user = "rpt_incidents";
  $mysql_pass = "reportn0cstation";*/

function database_open($mysql_hostname, $mode="r") {
  global $mysql_dbname;
  $hostname = php_uname('n');
  //echo $hostname;
  if($hostname=="app1v-noc.tp.prd.lax.gnmedia.net"){ //PRD Server
    $mysql_user_r = "rptincidents_r";
    $mysql_pass_r = "PaitiJ6y";

    $mysql_user_w = "rptincidents_w";
    $mysql_pass_w = "OhmuSh6c";
  }
  else{		//DEV or all other servers
    $mysql_user_r = "rptincidents_r";
    $mysql_pass_r = "P94qSsnl";

    $mysql_user_w = "rptincidents_w";
    $mysql_pass_w = "M5HjYeWm";
  }

  if ($mode == "w")
    $link = mysqli_connect("$mysql_hostname", "$mysql_user_w", "$mysql_pass_w", "$mysql_dbname");
  else
    $link = mysqli_connect("$mysql_hostname", "$mysql_user_r", "$mysql_pass_r", "$mysql_dbname");

  if (!$link)
    return(-1);
  else {
    return($link);
  }
}

function database_close($link) {
  mysqli_close($link);
}

function database_query($query, $link=NULL) {
  if ($link == NULL)
    return(-1);
  else
    return(mysqli_query($link, $query));
}

function database_num_rows($result) {
  return(mysqli_num_rows ( $result ));
}

function database_fetch_row($result) {
  return(mysqli_fetch_row ( $result ));
}

function database_fetch_array($result) {
  return(mysqli_fetch_array ( $result ));
}

function database_fetch_object($result) {
  return(mysqli_fetch_object ( $result ));
}
?>
