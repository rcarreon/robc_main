#!/usr/bin/php
<?php
$install_dir = "/app/shared/http/reports/";
include("${install_dir}/include/config.inc");
include("${install_dir}/include/functions.inc");
include("${install_dir}/include/vars.inc");
include("${install_dir}/include/mysql-connect.inc");

$sh_cmd="rt list -s -t asset \"Type = 'Site' AND Status != 'retired'\" | cut -d\" \" -f2 | grep -v '/' | xargs";

$rt_sites_str=shell_exec($sh_cmd);
$rt_sites_arr = explode(" ", $rt_sites_str);

$mysql_link_w = database_open($mysql_host, "w");

if (!is_object($mysql_link_w)) {
  if ($debug_lvl>0)
    mysqli_connect_error();
  die("Cannot connect to the database");
}

function create_temp_sitetable($rt_sites_arr, $mysql_link_w) {
  $query = "CREATE TEMPORARY TABLE rt_sites (id int(11) NOT NULL AUTO_INCREMENT, name varchar(50) CHARACTER SET latin1 DEFAULT NULL, PRIMARY KEY (`id`))";
  $res = database_query($query, $mysql_link_w);
  if (!$res)
    die("Could not create temp table!\n\n");

  foreach($rt_sites_arr as $site) {
    $query = sprintf("INSERT INTO rt_sites (name) VALUES (\"%s\")", rtrim(ltrim_www($site)));
    $res = database_query($query, $mysql_link_w);
    if (!$res)
      die('Could not query:' . mysqli_error($mysql_link_w));
  }
}

function compare_missing ($mysql_link_w) {
  $sites_a = array();
  $query = "SELECT rt.name AS rt_name, nr.name AS nr_name FROM rt_sites rt LEFT JOIN rpt_sites nr USING (name) WHERE nr.name IS NULL";
  $res = database_query($query, $mysql_link_w);
  if (!$res)
    die('Could not query:' . mysqli_error($mysql_link_w));
  while($sites = database_fetch_object($res)){
    $sites_a[] =  $sites->rt_name;
  }
  return ($sites_a);
}

function insert_sites($sites_a, $mysql_link_w) {
  foreach($sites_a as $site) {
    $query = sprintf("INSERT INTO rpt_sites (name) VALUES (\"%s\")", ($site));
    $res = database_query($query, $mysql_link_w);
    if (!$res)
      die('Could not query:' . mysqli_error($mysql_link_w));
    else
      echo "Added $site to NRT database";
  }
}
create_temp_sitetable($rt_sites_arr, $mysql_link_w);
$new_sites_a = compare_missing ($mysql_link_w);

//print_r($new_sites_a);  /*igm*/

insert_sites($new_sites_a, $mysql_link_w);

database_close($mysql_link_w);
?>
