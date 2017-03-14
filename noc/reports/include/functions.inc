<?php

//RETURNS STRING BETWEEN START-END
function get_string_between($string, $start, $end){
     $string = " ".$string;
     $ini = strpos($string,$start);
     if ($ini == 0) return "";
     $ini += strlen($start);
     $len = strpos($string,$end,$ini) - $ini;
     return substr($string,$ini,$len);
}

function lastupdate(){
//GETS DATE AND TIME OF LAST UPDATE IN http://vipvisual.gnmedia.net/
     //$line2=file_get_contents("http://vipvisual.gnmedia.net/");
     $line2=fetchURL("http://vipvisual.gnmedia.net/");
     $lastupdate = get_string_between($line2,"] [","] -Vip");
     echo "<strong>Last update:</strong><br>";
     echo "[".$lastupdate."]";
}

//GETS THE LIST OF HOST FROM VIPVISUAL AND RETURNS ARRAY WITH INFO
function hostlist_vpv($site){
  $site = str_replace('www.','',$site);
  $line=explode("\n",fetchURL("http://vipvisual.gnmedia.net/extractServer?value=".$site));
  $last=$line[count($line)-1];
  $hosts=str_replace(" ","",str_replace("net","net\n",strip_tags($last)));
  if(validate($hosts)){
  $host_array=explode("\n",$hosts);
  if(empty($host_array[count($host_array)-1])) {   
    unset($host_array[count($host_array)-1]);
    sort($host_array);
    return $host_array;    
  }
    //$host_array[0]="No results";
    //echo $hosts;    
  } $host_array[0]="--No results--";
    return $host_array;
}

function validate($server){
//foreach($server as $eachserver){
  $pos = strpos($server,'Error');
  if($pos === false) {
    return true; //not error found
  }
  else {
    return false;//error found
  }
	//}
}

//CONVERTS ARRAY OF HOSTS IN HTML TABLE
function hosts($host_array,$source){
  $graphite_url="http://vipvisual.gnmedia.net/graphite/?hostname=";
  $list_hostst="<table width=1170 border=0><tr><td><strong>Host (".$source."):</strong></br>"; 
  for($i = 0; $i < (count($host_array)); $i++) {
    if ($host_array[$i]!="") {
    
      $list_hostst .= $host_array[$i]."</br>";//.$i;
      if (strstr($host_array[$i],'sql')) {
           printf("<a href=http://toolshed.gnmedia.net/toolshed/sqlps/%s target=_blank>%s</a><br />\n",
              $host_array[$i],$host_array[$i]); 
      }
      else
           printf("<a href=%s%s&frm=-4hours target=_blank>%s</a><br />\n",
              $graphite_url, $host_array[$i], $host_array[$i]); 
    }
  
  }
  $list_hostst.="</td></tr></table>";
  //echo $list_hostst;
  return $list_hostst;
}

//GETS THE LIST OF HOST FROM LOCAL DATABASE AND RETURNS ARRAY WITH INFO
function hostlist_dtb($site, $mysql_link_r) {
      $sql="Select id from rpt_sites where name like '".$site."';";
	    //echo $sql;
      $list_hostst="";
      $list=null;
      $con=database_query($sql,$mysql_link_r) or die(mysql_error());
      $row=database_fetch_row($con);
      $id_website= $row[0];
      $sql="Select name from rpt_hosts where id in ( Select hosts_id from rpt_sitehost where sites_id ='".$id_website."') ORDER BY name;";
	     //echo $sql;
      $i=0;
      $con2=database_query($sql,$mysql_link_r) or die(mysql_error());
      while($row2 = database_fetch_array($con2))
          $list[$i]= $row2[0]; $i++;
      return $list;
}

//CHECK IF PINGDOM MONITOR PROCCRESS IS ALIVE
function checkPrc() 
{
  $cmd = "ps -aA | grep ping";
  exec($cmd, $output, $result);

  if(count($output) >= 1)
    return true;
  
  return false;
}

//EXTRACT VIP INFORMATION
function extractvip($site){
      #$line=file_get_contents("http://vipvisual.gnmedia.net/extractServer?value=$site");
      $line=fetchURL("http://vipvisual.gnmedia.net/extractServer?value=".$site);
      $st1='<li><span class="folder"><font color="#0000FF">';
      $st2='<img width="16" height="15" align="bottom" border="0"';
      return get_string_between($line,$st1,$st2);
  }

//DATABASE SYNC INFORMATION //WHEN DATABASE IS UPDATING RELATIONSHIP BETWEEN SITES AND HOSTS CHECK IF HOST ALREADY EXISTS
function ifexist($host, $link){
  $space = "\n";
  $query = "SELECT id FROM  rpt_hosts WHERE name='".$host."'";
  echo "Checking if exists....".$space.$query.$space;
  $result4 = database_query($query, $link);
  if (!$result4) {
    echo 'Error: ' . mysql_error();
    exit;
  }
  if(database_num_rows($result4)!=0){
    printf("Already Exists%s%s", $site, $space);
    return false;
  }
  else{
    printf("Doesn't Exists %s%s", $site, $space);
    return true;
  }
}

//DATABASE SYNC INFORMATION //WHEN DATABASE IS UPDATING RELATIONSHIP BETWEEN SITES AND HOSTS CHECK IF SITE ALREADY EXISTS
function ifsitexst($site, $link){
     $query = "SELECT COUNT(*) as total FROM  rpt_sites WHERE name='".$site."'";
     echo "Checking if exists....".$query."\n ";
     $result = database_query($query, $link);
     $obj = database_fetch_object($result);
     $res = $obj->total;  
     if (!$result) {
       echo 'Error: ' . mysqli_error($link);
     exit;
     }
     if($res!=0){
      //printf("Already Exists Site %s \n", $site);
      return false;
     }
     else{
       printf("Doesn't Exists Site %s \n", $site);
       return true;
     }
}

// IF APP SERVERS MORE THAN 9 (GRAPHITE ONLY SUPPORT 9 SERVERS PER IMAGE)
function check($host_array,$exc_type){
  //print_r($host_array);
  //echo $exc_type;
 if(substr_count_array($host_array,$exc_type)>=9){
        //echo "CONTE MAS DE 9";
        //echo $exc_type;
    
    $values=if_need_split($host_array,$exc_type);  // IF APP SERVERS MORE THAN 9 (GRAPHITE ONLY SUPPORT 9 SERVERS PER IMAGE)
    if($values['bool_strip']){
      $num_app=substr_count_array($host_array,$exc_type);
      echo "<strong>Number of ".$exc_type." servers:</strong> ".$num_app."</br>\n";
      return $values;
    }else{
      $bool_strip=false;}
    //else{
    //  $bool_strip=false;
    //}
    //}else{$bool_strip=false;}
  } 
}

function substr_count_array( $haystack, $needle ) {
  $count = 0;
  foreach ($haystack as $myarray) {
    #echo $haystack[$count]."  ".$count."</br>";  
    $count += substr_count( $myarray, $needle);
    if(array_key_exists($count, $haystack)){
    if(strpos($haystack[$count],$needle)){
    $app_array[$count] = $haystack[$count];
    }
    
    }
   }
     return $count;
}

function if_need_split($host_array,$exc_type){
  //if(substr_count_array($host_array,'app')>=9){

  if(substr_count_array($host_array,$exc_type)>=9){
	echo "<strong>Warning: ".$exc_type." servers are displayed separately</strong></br >";
	$num_app=substr_count_array($host_array,$exc_type);
	//echo "Number of app servers: ".$num_app."</br>";
	$split_num=round($num_app/2);
	//echo "Number of split_num:".$split_num."</br>";

	for($i = 0; $i < count($host_array); $i++) {
		if(strstr($host_array[$i],$exc_type)){
		//$temp_array[$i]= eregi_replace("[^0-9]", "",$host_array[$i]);
    $temp_array[$i]= preg_replace("/[^0-9]/", "",$host_array[$i]);
		//echo "temp_array[$i] ".$temp_array[$i]."</br>";
		}
		}
		sort($temp_array);
		$str1='{';
		$str2='{';
		for($i = 0; $i < count($temp_array); $i++) {
		//echo "temp_array[$i] ".$temp_array[$i]."</br>";
		if(((int)$temp_array[$i]) <= $split_num){
		  $str1.= "".$temp_array[$i];
		  //echo "First group"."</br>";  //FIRST GROUP OS SERVERS STRING
		  //echo $host_array[$i]."</br>" ;
		  if($i != $split_num-1)
                    $str1.=',';
		}
                else {
  		  $str2.= "".$temp_array[$i];
		  //echo "Second group"."</br>";   //SECOND GROUP OS SERVERS STRING
		  //#echo $host_array[$i]."</br>";
		  if($i != count($temp_array)-1)
                    $str2.=',';
	        }
	       }
	$str1.="}"; $str2.="}"; //echo $str1."</br>".$str2."</br>";
	$bool_strip=true;
	$values = array('bool_strip' => $bool_strip,'str1' => $str1,'str2' => $str2);
	//$values[]=$bool_strip;
	//$values[]=$str1;
	//$values[]=$str2;
	//print_r($values);
  return $values;}
  else{
    return false;}
  }

//THIS FUNCTION IS USED INSTEAD OF file_get_contents
function fetchURL($url) {
  if (ini_get('allow_url_fopen')) {
                return file_get_contents($url);
  } elseif (function_exists('curl_init')) {
                $curlObj = curl_init($url);
                curl_setopt($curlObj, CURLOPT_RETURNTRANSFER, 1);
                curl_setopt($curlObj, CURLOPT_HEADER, 0);
                $content = curl_exec($curlObj);
                curl_close($curlObj);
                return $content;
  } else {
                die('Error');
  } 
}

class userClass {
  var $id;                  /* User ID in DB*/
  var $name;                /* Username */
  var $passwd;              /* User password in database */
  var $showLastTestCol;     /* Show LastTest column? */
  var $showLastErrorCol;    /* Show LastError column? */
  var $showStatusCol;       /* Show status flag column? */
  var $sortBy;              /* Order criteria */
  var $orderAsc;            /* Ascending/Descending */
  var $tableRows;           /* Number of lines shown at the incidents table */
  var $incElapTime;         /* Minimal elapsed time to display 
                               incidents of the same site, in minutes */
  var $fullname;            /* Get the full name of the user */

  function getUserSettings($username, $link) {

    global $debug_lvl;

    $query = "SELECT id, name, showLastTestCol, showLastErrorCol, showStatusCol, sortBy, orderAsc, tableRows, incElapTime, fullname ";
    $query.= "FROM rpt_user WHERE name='$username' LIMIT 1";

    if ($debug_lvl >= 2)
      echo "getUserSettings()->query: #$query#\n\n";

    $result = database_query($query, $link);
    if (!$result) {
      die('Error: ' . mysqli_error($link));
    }

    if (database_num_rows($result)<1)
      $this->name = "";
    else {
      $obj = database_fetch_object($result);
      $this->id = $obj->id;
      $this->name = $obj->name;
      $this->showLastTestCol = $obj->showLastTestCol;
      $this->showLastErrorCol = $obj->showLastErrorCol;
      $this->showStatusCol = $obj->showStatusCol;
      $this->sortBy = $obj->sortBy;
      $this->orderAsc = $obj->orderAsc;
      $this->tableRows = $obj->tableRows;
      $this->incElapTime = $obj->incElapTime; 
      $this->fullname = $obj->fullname;
    }

	  return $this;
  }

  function setUserSettings($link_w) {

    global $debug_lvl;

    $query = sprintf("UPDATE rpt_user SET showLastTestCol=%d, showLastErrorCol=%d, showStatusCol=%d, sortBy=\"%s\", orderAsc=%d, tableRows=%d, incElapTime=%d ",
                     $this->showLastTestCol, $this->showLastErrorCol, $this->showStatusCol, $this->sortBy, $this->orderAsc, $this->tableRows, $this->incElapTime);
    $query.= sprintf("WHERE name=\"%s\"", $this->name);

    if ($debug_lvl >= 2)
      echo "setUserSettings()->query: #$query#\n\n";

    $result = database_query($query, $link_w);
    if (!$result) {
      return(-1);
    }
    else
      return(0);
  }

}

//GRAPHICS CODING
function graphite($title,$oldline,$from,$until,$spec1,$spec2,$spec3,$spec4){
  $graphite_url = "http://graphite.gnmedia.net/render/";
  $salt=1328377644.834;
  $pref="$graphite_url?width=1003&height=495&_salt=$salt&target";
  $size="width='600' height='300'";
  $memva="memory.memory";
  $inter="interface.eth0.if_";
  $proxy="varnish.default-";
  $mysql="mysql.default.mysql_commands";
  $mysqlt="mysql.default.threads";
  $mysqlp="processes.ps_state";
  $nconn="nginx.nginx_";

  echo "<b>$title</b><br>$oldline</br>\n";

        $graphic1 = "<a href=$pref=$oldline.$spec1$spec2&from=$from&until=$until>";
        $graphic1 .= "<img src=$pref=$oldline.$spec1$spec2&from=$from&until=$until $size></img></a>&nbsp";
        $img1 = "<img src=$pref=$oldline.$spec1$spec2&from=$from&until=$until $size></img>&nbsp";
        echo "<input type=\"checkbox\" name=\"graphics[]\" value=\"$graphic1\">".$graphic1;
        //echo "<input type=\"hidden\" name=\"images[]\" value=\"$img1\">";

        $graphic2 = "<a href=$pref=$oldline.$spec1$spec3&from=$from&until=$until>";
        $graphic2 .= "<img src=$pref=$oldline.$spec1$spec3&from=$from&until=$until $size></img></a>&nbsp";
        $img2 = "<img src=$pref=$oldline.$spec1$spec3&from=$from&until=$until $size></img>&nbsp";
        echo "<input type=\"checkbox\" name=\"graphics[]\" value=\"$graphic2\">".$graphic2;
        //echo "<input type=\"hidden\" name=\"images[]\" value=\"$img2\">";

	if($spec4!=null){
        $graphic3 = "<a href=$pref=$oldline.$spec1$spec4&from=$from&until=$until>";
        $graphic3 .= "<img src=$pref=$oldline.$spec1$spec4&from=$from&until=$until $size></img></a>&nbsp";
        $img3 = "<img src=$pref=$oldline.$spec1$spec4&from=$from&until=$until $size></img>&nbsp";
        echo "<input type=\"checkbox\" name=\"graphics[]\" value=\"$graphic3\">".$graphic3;
        //echo "<input type=\"hidden\" name=\"images[]\" value=\"$img3\">";        
	}
        echo "</br>";
}        
               

/* Initialize database link (read) and get user settings  [restrada]*/
function init (){ 
  global $mysql_host, $user;
  
  if (isset($_COOKIE['nocreports_uname']))
    $user->name = $_COOKIE['nocreports_uname'];
  else
    $user->name = "jdoe";

  $mysql_link_r = database_open($mysql_host, "r");
  $user->getUserSettings($user->name, $mysql_link_r);  /* Get user settings */

  return($mysql_link_r);
}

//IF SITE MARKED AS DOWN BY PINGDOM
function ifsitedown($sitedb, $link, $status){
     $report_id="";
     $query = sprintf("SELECT a.id FROM rpt_report a, rpt_sites b WHERE a.site_id=b.id AND a.status='%s' AND b.name='%s'",$status,$sitedb);
       //echo "Exists? ".$query."\n";
     $result4 = database_query($query, $link);
     if (!$result4) {
       echo 'Error: ' . mysqli_error($link);
     exit;
     } 
     while ($obj = database_fetch_object($result4)) {
     $report_id = $obj->id;
     //$id = (string)$report_id; // $items == "5";
     //$id = strval($report_id); // $items == "5"
     }            
     if(database_num_rows($result4)!=0){
       printf("Already Exist ifsitedown!\n");
       $bool = "yes";     
       $answer= $bool."/".$report_id;  
       return $answer;
     }
     else{
       printf("Doesn't Exists ifsitedown!\n");
       $bool = "no";      
       $answer= $bool."/"."0";  
       return $answer;
     }
}

//GET REPORT ID OF THE INCIDENT
function getreportid($site, $downtime, $link){
    $query=sprintf("SELECT report_id FROM rpt_incidents a, rpt_sites b WHERE a.site_id=b.id AND a.lasttesttime=%d AND b.name LIKE '%s'",$downtime,$site);
    //echo "$query\n";       
     $result = database_query($query, $link);
     if (!$result) {
       echo 'Error: ' . mysqli_error($link);
     exit;
     } 
     while ($obj = database_fetch_object($result)) {
       $id = $obj->report_id;}  
      return $id;
}
///GET DOWNTIME AND UPTIME OF INCIDENT
 //report.php          index_basic.php    
function gettimes($id,$link){//only used in index_basic.php
	
	$query=sprintf("SELECT downtime,uptime,status FROM rpt_report WHERE id='%d'",$id);
   //echo "$query\n";       
   $result = database_query($query, $link);
   if (!$result) {
	   die('Could not query:' . mysqli_error($link));
	 }
   if(database_num_rows($result)!=0){
   while ($obj = database_fetch_object($result)){
     $downtime = $obj->downtime; $uptime = $obj->uptime; $status = $obj->status;}
     //echo $uptime; echo $status;
     if($status=="down"||$status=="unconfirmed_down"){
     	  return $downtime."#"." ";
     	  }
     if($status=="up"){
        //$downtime=date('m/d/Y h:i:s a',$downtime);     	  
        //$uptime=date('m/d/Y h:i:s a',$uptime);
     	  //echo $uptime; echo $status;
     	  return  $downtime."#".$uptime;}	 	
	}  
}

	//index.php
function report_icon($id,$link){
  $query=sprintf("SELECT downtime,uptime,status FROM rpt_report WHERE id='%d'",$id);
  //echo "$query\n";       
  $result = database_query($query, $link);
  if (!$result) {
    die('Could not query:' . mysqli_error($link));
  }
  if(database_num_rows($result)!=0){
    while ($obj = database_fetch_object($result)){
      //$downtime = $obj->downtime; $uptime = $obj->uptime; 
      $status = $obj->status;
    }
     //echo $uptime; echo $status;
    if($status=="down")
      return false;

    if($status=="up"){
      //$downtime=date('m/d/Y h:i:s a',$downtime);     	  
      //$uptime=date('m/d/Y h:i:s a',$uptime); echo $status;
     	  return  true;
          
    }	 	
  }  
}

//GET INFO FROM VIPTRACE (ONLY WORKS IN DEV SERVER)
function gettrace($site){

  $service="jcamou.gnmedia.net";
  if($site=="sheknows.com")
    $site="www.sheknows.com";
  $curl = curl_init();
  curl_setopt($curl, CURLOPT_URL, "http://".$service."/cgi-bin/viptrace.cgi?site=".$site);
  curl_setopt($curl, CURLOPT_RETURNTRANSFER, 1);
  
  $response = json_decode(curl_exec($curl),true);

  if (isset($response['error'])) {
    print "Error: " . $response['error']['errormessage'] . "\n";
    exit;
  }

  if(is_array($response)&&(!empty($response))&&(sizeof($response)>1)){
    $s=0;
    foreach($response as $vip_value => $value){
      foreach( $value as $server_value => $value2){
          if(substr($server_value,0,3)==('APP')||substr($server_value,0,3)==('PXY')||substr($server_value,0,3)==('SQL')||substr($server_value,0,3)==('WWW')||substr($server_value,0,3)==('NGX')||substr($server_value,0,3)==('ENG')){ 
              $servers[$s]=strtolower($server_value).".gnmedia.net";
              $server_bool=true;$s++;
               //$info .=  $vip_value." [rserver] ".$server_value." ";   
              //$info .="<tr><td width=200>".$vip_value."</td><td width=200>".$server_value."</td>";
              }
              else {
                $server_bool=false;
                //$attr_list .= $vip_value." ";
                //$attr_list .="<tr><td width=200>".$vip_value;
              }
    
    //$info .="</tr>";
    }
    //$attr_list .="</tr>";
   
    
    //sort($servers);
    //foreach ($servers as $serv) {
    //  $table_stc .= $serv."</br>";
    }
    $servers = array_unique($servers);
    sort($servers);
    //echo " Test good</br >";
    //echo $table_stc."</br >"; 
    }
    else{   
      $servers[0]="--No results--";
      //echo $site." "; 
      //echo " TEST ERROR string received: ";
      //$string=fetchURL("http://".$service."/cgi-bin/viptrace.cgi?site=".$site);
     
      //echo $string."</br >"; 
    }

    //print_r($servers);
    //hosts($servers);
    return $servers;
    }

function ltrim_www($string) {
  $string = preg_replace('#^www[.]#','',$string);
  return($string);
}

function gangliaGraph ($site, $qhost, $option, $from, $until)
{
# $site = The site you want to get the graphs
# $qhost = the host you will query to the get the hostlist of the site 
		# vtr - VipTrace
		# dtb - local-NOC-Reports-database
		# vpv - VipVisual
# $option = from where is this query
		# analyzer - to create a report from VisualGrafito (site.php)
		# reports - to create a report from the the Home (index.php)
# $from = starting time for the graphs
		# if is not a custom time (starting and ending this value should be set to a range (1hr, 2hr, 4hr, day, week, month, year)
# $until = ending time for the graphs
		# if there is not a custom time this value can be skipped or set to NULL to avoid warning in error_log

  $ganglia = "gweb.gnmedia.net";
  $timeGraph = "";
  $apps = 0; $appHostList = ""; $appFlag = 0;
  $sqls = 0; $sqlHostList = ""; $sqlFlag = 0;
  $pxys = 0; $pxyHostList = ""; $prxFlag = 0;
  $ngxs = 0; $ngxHostList = ""; $ngxFlag = 0;

  if ($qhost == "vtr")
    $hostlist = gettrace($site);
  elseif ($qhost == "dtb")
    $hostlist = hostlist_dtb($site, $link);
  elseif ($qhost == "vpv")
    $hostlist = hostlist_vpv($site);
  else
    $hostlist = hostlist_vpv($site);

   #print_r ($hostlist);

  if (sizeof($hostlist)<=1)
    echo "Error getting the hostlist from $qhost";
  else{
    foreach ($hostlist as $host)
    {
      
 //      print $host."<br>\n";    // Uncomment this line to see the host list recevied from $qhost (VipVisual, VipTrace or Database)

      $thost = substr ($host, 0, 3);  //typo of host
      $vertical = between($host, '.', '.');
#      $vertical = preg_replace("/\..*/", '', preg_replace("/^[a-z0-9]*-[a-z0-9]*\./", '',$host));

      if ($thost == "app")
      {
        $src = file_get_contents("http://".$vertical.".".$ganglia."/search.php?q=".$host);
        $match = between($src, '?c=', '&');
        $cluster = $match;

/*   DEBUG PRINTS
echo "DEBUG ".$cluster;
echo "http://".$vertical.".".$ganglia."/search.php?q=".$host;
print_r ($src);
echo "DEBUG VERTICAL ".$vertical; */

        if ($appHostList == "")
          $appHostList = $host."|".$cluster;
        else
          $appHostList = $appHostList.",".$host."|".$cluster;

        $apps++; 
      }
      elseif ($thost == "sql")
      {
        $src = file_get_contents("http://".$vertical.".".$ganglia."/search.php?q=".$host); 
        //ex. http://ao.gweb.gnmedia.net/search.php?q=app1v-mal.ao.prd.lax.gnmedia.net
        $match = between($src, '?c=', '&');
        $cluster = $match;
        
        if ($sqlHostList == "")
          $sqlHostList = $host."|".$cluster;
        else
          $sqlHostList = $sqlHostList.",".$host."|".$cluster;

        $sqls++; 
      }
      elseif ($thost == "pxy")
      {
        $src = file_get_contents("http://".$vertical.".".$ganglia."/search.php?q=".$host);
        $match = between($src, '?c=', '&');
        $cluster = $match;

        if ($pxyHostList == "")
          $pxyHostList = $host."|".$cluster;
        else
          $pxyHostList = $pxyHostList.",".$host."|".$cluster;

        $pxys++; 
      }
      elseif ($thost == "ngx")
      {
        $src = file_get_contents("http://".$vertical.".".$ganglia."/search.php?q=".$host);
        $match = between($src, '?c=', '&');
        $cluster = $match;

        if ($ngxHostList == "")
          $ngxHostList = $host."|".$cluster;
        else
          $ngxHostList = $ngxHostList.",".$host."|".$cluster;

        $ngxs++; 
      }


/* DEBUG OUTPUT */
/*      echo "thost $thost <br>";
      echo "apps = ".$apps." sqls = ".$sqls."<br>";
      echo "clusterApps = ".$clusterApps." clusterSqls = ".$clusterSqls."<br>";
      echo "cluster $cluster <br>";
      echo "vertical $vertical <br>";
//    switch 
      $urlGraph = $vertical.".".$ganglia."/graph.php?h=".$host."&c=".$cluster;
      echo "urlGraph $urlGraph <br>"; 
      echo "<br>";  */
/* END DEBUG OUTPUT */
      
    }  

if ($option == "analyzer")
  $timeGraph = "&r=$from";
elseif ($option == "reports")
  $timeGraph = "&r=custom&cs=$from&ce=$until";
else
  $timeGraph = "";

/* APPS GRAPHS */
/* ALL TESTS WILL BE PERFORM IN LOAD ONE AND THEN WILL COPIED IN THE RESTS OF GRAPHICS*/

/* Arrays that will hold the parameters */

$parameters = array(
  "app"=>array(
        //  Title  //   Parameter         
    array("Load One", "load_one"),
    array("Load Five", "load_five"),
    array("Load Fifteen", "load_fifteen"),
    array("Context Switches", "contexts"),
    array("CPU Idle", "cpu_idle"),
    array("CPU Interrupts", "cpu_intr"),
    array("CPU Nice", "cpu_nice"),
    array("CPU Soft Interrupts", "cpu_sintr"),
    array("CPU System", "cpu_system"),
    array("CPU User", "cpu_user"),
    array("CPU I/O Wait", "cpu_wio"),
    array("Interrupts", "interrupts"),
    array("Bytes Read", "bytes_read"),
    array("Bytes Written", "bytes_written"),
    array("Free Disk Space", "disk_free"),
    array("Disk Space Available On /", "disk_free_absolute_rootfs"),
    array("Disk Space Percent Available On /", "disk_free_percent_rootfs"),
    array("Total Disk Space", "disk_total"),
    array("Maximum Disk Space Used", "part_max_used"),
    array("Read Time", "read_time"),
    array("Reads", "reads"),
    array("Write Time", "write_time"),
    array("Writes", "writes"),
/*    array("diskstat_hda_io_time", "diskstat_hda_io_time"),
    array("diskstat_hda_percent_io_time", "diskstat_hda_percent_io_time"),
    array("diskstat_hda_read_bytes_per_sec", "diskstat_hda_read_bytes_per_sec"),
    array("diskstat_hda_read_time", "diskstat_hda_read_time"),
    array("diskstat_hda_reads", "diskstat_hda_reads"),
    array("diskstat_hda_reads_merged", "diskstat_hda_reads_merged"),
    array("diskstat_hda_weighted_io_time", "diskstat_hda_weighted_io_time"),
    array("diskstat_hda_write_bytes_per_sec", "diskstat_hda_write_bytes_per_sec"),
    array("diskstat_hda_write_time", "diskstat_hda_write_time"),
    array("diskstat_hda_writes", "diskstat_hda_writes"),
*///    array("diskstat_hda_writes_merged", "diskstat_hda_writes_merged"),
    array("Memory Buffers", "mem_buffers"),
    array("Cached Memory", "mem_cached"),
    array("Memory waiting to be written to disk", "mem_dirty"),
    array("Free Memory", "mem_free"),
    array("Memory HardwareCorrupted", "mem_hardware_corrupted"),
    array("Memory Mapped", "mem_mapped"),
    array("Shared Memory", "mem_shared"),
    array("Memory actively being written to disk", "mem_writeback"),
    array("Pages In", "page_in"),
    array("Pages Out", "page_out"),
    array("Free Swap Space", "swap_free"),
    array("Swap Pages In", "swap_in"),
    array("Swap Pages Out", "swap_out"),
    array("Major Page Fault", "vm_pgmajfault"),
    array("Pages In from Disk", "vm_pgpgin"),
    array("Pages Out to Disk", "vm_pgpgout"),
    array("VM Efficiency", "vm_vmeff"),
    array("Bytes Received", "bytes_in"),
    array("Bytes Sent", "bytes_out"),
    array("Input Drops", "drops_in"),
    array("Output Drops", "drops_out"),
    array("Input Errors", "errs_in"),
    array("Output Errors", "errs_out"),
    array("Packets Received", "pkts_in"),
    array("Packets Sent", "pkts_out"),
    array("rx_bytes_eth0", "rx_bytes_eth0"),
    array("rx_drops_eth0", "rx_drops_eth0"),
    array("rx_errs_eth0", "rx_errs_eth0"),
    array("rx_pkts_eth0", "rx_pkts_eth0"),
    array("tx_bytes_eth0", "tx_bytes_eth0"),
    array("tx_drops_eth0", "tx_drops_eth0"),
    array("tx_errs_eth0", "tx_errs_eth0"),
    array("tx_pkts_eth0", "tx_pkts_eth0"),
    array("NFS v3 access", "nfs_v3_access"),
    array("NFS v3 getattr", "nfs_v3_getattr"),
    array("NFS v3 lookup", "nfs_v3_lookup"),
    array("NFS v3 read", "nfs_v3_read"),
    array("NFS v3 write", "nfs_v3_write"),
    array("Average Latency of NFS Mounts", "nfsmounts-avg"),
    array("Max Latency of NFS Mounts", "nfsmounts-max"),
    array("Total Running Processes", "proc_run"),
    array("Total Processes", "proc_total"),
    array("Entropy Available", "entropy_avail"),
    array("TCP Segments Received", "tcp_insegs"),
    array("TCP Segments Sent", "tcp_outsegs"),
    array("TCP Retransmit Percentage", "tcp_retrans_percentage"),
    array("TCP Loss Percentage", "tcpext_tcploss_percentage"),
    array("UDP Packets In", "udp_indatagrams"),
    array("UDP Packets Out", "udp_outdatagrams")

/*    array("Memory Free", "mem_free"),
    array("Memory Cached", "mem_cached"),
    array("Swap Free", "swap_free"),
    array("Bytes In", "bytes_in"),
    array("Bytes Out", "bytes_out"),
    array("Error In", "errs_in"),
    array("Errors Out", "errs_out")
*/
  ),
  "sql"=>array(
        //  Title  //   Parameter         
    array("Load One", "load_one"),
    array("Load Five", "load_five"),
    array("Load Fifteen", "load_fifteen"),
    array("Free Memory", "mem_free"),
    array("VM Efficiency", "vm_vmeff"),
    array("Memory Buffers", "mem_buffers"),
    array("Cached Memory", "mem_cached"),
    array("Memory waiting to be written to disk", "mem_dirty"),
    array("Bytes Read", "bytes_read"),
    array("Bytes Written", "bytes_written"),
    array("Read Time", "read_time"),
    array("Reads", "reads"),
    array("Write Time", "write_time"),
    array("Writes", "writes"),
    array("Memory HardwareCorrupted", "mem_hardware_corrupted"),
    array("Memory Mapped", "mem_mapped"),
    array("Shared Memory", "mem_shared"),
    array("Memory actively being written to disk", "mem_writeback"),
    array("Pages In", "page_in"),
    array("Pages Out", "page_out"),
    array("Free Swap Space", "swap_free"),
    array("Swap Pages In", "swap_in"),
    array("Swap Pages Out", "swap_out"),
    array("Major Page Fault", "vm_pgmajfault"),
    array("Pages In from disk", "vm_pgpgin"),
    array("Pages Out to disk", "vm_pgpgout"),
    array("Bytes In", "bytes_in"),
    array("Bytes Out", "bytes_out"),
    array("Input Drops", "drops_in"),
    array("Drops Out", "drops_out"),
    array("Input Errors", "errs_in"),
    array("Output Errors", "errs_out"),
    array("Packets Received", "pkts_in"),
    array("Packets Out", "pkts_out"),
    array("rx_bytes_eth0", "rx_bytes_eth0"),
    array("rx_drops_eth0", "rx_drops_eth0"),
    array("rx_errs_eth0", "rx_errs_eth0"),
    array("rx_pkts_eth0", "rx_pkts_eth0"),
    array("tx_bytes_eth0", "tx_bytes_eth0"),
    array("tx_drops_eth0", "tx_drops_eth0"),
    array("tx_errs_eth0", "tx_errs_eth0"),
    array("tx_pkts_eth0", "tx_pkts_eth0"),
    array("NFS v3 access", "nfs_v3_access"),
    array("NFS v3 getattr", "nfs_v3_getattr"),
    array("NFS v3 lookup", "nfs_v3_lookup"),
    array("NFS v3_read", "nfs_v3_read"),
    array("NFS v3_write", "nfs_v3_write"),
    array("Average Latency of NFS Mounts", "nfsmounts-avg"),
    array("Max Latency of NFS Mounts", "nfsmounts-max"),
    array("Total Running Processes", "proc_run"),
    array("Total Processes", "proc_total"),
    array("Entropy Available", "entropy_avail"),
    array("TCP Segments Received", "tcp_insegs"),
    array("TCP Segments Sent", "tcp_outsegs"),
    array("TCP Retransmit Percentage", "tcp_retrans_percentage"),
    array("TCP Loss Percentage", "tcpext_tcploss_percentage"),
    array("UDP Packets In", "udp_indatagrams"),
    array("UDP Packets Out", "udp_outdatagrams")
/*    array("diskstat_sda_io_time", "diskstat_sda_io_time"),
    array("diskstat_sda_read_bytes_per_sec", "diskstat_sda_read_bytes_per_sec"),
    array("diskstat_sda_read_time", "diskstat_sda_read_time"),
    array("diskstat_sda_reads", "diskstat_sda_reads"),
    array("diskstat_sda_weighted_io_time", "diskstat_sda_weighted_io_time"),
    array("diskstat_sda_write_bytes_per_sec", "diskstat_sda_write_bytes_per_sec"),
    array("diskstat_sda_write_time", "diskstat_sda_write_time"),
    array("diskstat_sda_writes", "diskstat_sda_writes"),
*///    array("diskstat_sda_writes_merged", "diskstat_sda_writes_merged")
  ),
  "pxy"=>array(
        //  Title  //   Parameter         
    array("Load One", "load_one"),
    array("Load Five", "load_five"),
    array("Load Fifteen", "load_fifteen"),
    array("Context Switches", "contexts"),
    array("CPU Idle", "cpu_idle"),
    array("CPU Interrups", "cpu_intr"),
    array("CPU Nice", "cpu_nice"),
    array("CPU Soft Interrups", "cpu_sintr"),
    array("CPU System", "cpu_system"),
    array("CPU User", "cpu_user"),
    array("CPU I/O Wait", "cpu_wio"),
    array("Interrups", "interrupts"),
    array("Bytes Read", "bytes_read"),
    array("Bytes Written", "bytes_written"),
    array("Free Disk Space", "disk_free"),
    array("Disk Space Available on /", "disk_free_absolute_rootfs"),
    array("Disk Space Percent Available On /", "disk_free_percent_rootfs"),
    array("Total Disk Space", "disk_total"),
    array("Maximun Disk Space Used", "part_max_used"),
    array("Read Time", "read_time"),
    array("Reads", "reads"),
    array("Write Time", "write_time"),
    array("Writes", "writes"),
/*    array("diskstat_hda_io_time", "diskstat_hda_io_time"),
    array("diskstat_hda_percent_io_time", "diskstat_hda_percent_io_time"),
    array("diskstat_hda_read_bytes_per_sec", "diskstat_hda_read_bytes_per_sec"),
    array("diskstat_hda_read_time", "diskstat_hda_read_time"),
    array("diskstat_hda_reads", "diskstat_hda_reads"),
    array("diskstat_hda_reads_merged", "diskstat_hda_reads_merged"),
    array("diskstat_hda_weighted_io_time", "diskstat_hda_weighted_io_time"),
    array("diskstat_hda_write_bytes_per_sec", "diskstat_hda_write_bytes_per_sec"),
    array("diskstat_hda_write_time", "diskstat_hda_write_time"),
    array("diskstat_hda_writes", "diskstat_hda_writes"),
*///    array("diskstat_hda_writes_merged", "diskstat_hda_writes_merged"),
    array("Memory Buffers", "mem_buffers"),
    array("Cached Memory", "mem_cached"),
    array("Memory waiting to be written to disk", "mem_dirty"),
    array("Free Memory", "mem_free"),
    array("Memory HardwareCorrupted", "mem_hardware_corrupted"),
    array("Memory Mapped", "mem_mapped"),
    array("Shared Memory", "mem_shared"),
    array("Memory actively being written to disk", "mem_writeback"),
    array("Pages In", "page_in"),
    array("Pages Out", "page_out"),
    array("Free Swap Space", "swap_free"),
    array("Swap Pages In", "swap_in"),
    array("Swap Pages Out", "swap_out"),
    array("Major Page Fault", "vm_pgmajfault"),
    array("Pages In from disk", "vm_pgpgin"),
    array("Pages out to disk", "vm_pgpgout"),
    array("VM Efficiency", "vm_vmeff"),
    array("Bytes Received", "bytes_in"),
    array("Bytes Sent", "bytes_out"),
    array("Input Drops", "drops_in"),
    array("Output Drops", "drops_out"),
    array("Input Errors", "errs_in"),
    array("Output Errors", "errs_out"),
    array("Packets Received", "pkts_in"),
    array("Packets Sent", "pkts_out"),
    array("rx_bytes_eth0", "rx_bytes_eth0"),
    array("rx_drops_eth0", "rx_drops_eth0"),
    array("rx_errs_eth0", "rx_errs_eth0"),
    array("rx_pkts_eth0", "rx_pkts_eth0"),
    array("tx_bytes_eth0", "tx_bytes_eth0"),
    array("tx_drops_eth0", "tx_drops_eth0"),
    array("tx_errs_eth0", "tx_errs_eth0"),
    array("tx_pkts_eth0", "tx_pkts_eth0"),
    array("NFS v3 access", "nfs_v3_access"),
    array("NFS v3 getattr", "nfs_v3_getattr"),
    array("NFS v3 lookup", "nfs_v3_lookup"),
    array("NFS v3 read", "nfs_v3_read"),
    array("NFS v3 write", "nfs_v3_write"),
    array("Average Latency of NFS Mounts", "nfsmounts-avg"),
    array("Max Latency of NFS Mounts", "nfsmounts-max"),
    array("Total Running Processes", "proc_run"),
    array("Total Processes", "proc_total"),
    array("Entropy Available", "entropy_avail"),
    array("TCP Segments ", "tcp_insegs"),
    array("TCP Segments Received", "tcp_insegs"),
    array("TCP Segments Sent", "tcp_outsegs"),
    array("TCP Retransmit Percentage", "tcp_retrans_percentage"),
    array("TCP Loss Percentage", "tcpext_tcploss_percentage"),
    array("UDP Packets In", "udp_indatagrams"),
    array("UDP Packets Out", "udp_outdatagrams")
  ),
  "ngx"=>array(
        //  Title  //   Parameter         
    array("Load One", "load_one"),
    array("Load Five", "load_five"),
    array("Load Fifteen", "load_fifteen"),
    array("Context Switches", "contexts"),
    array("CPU Idle", "cpu_idle"),
    array("CPU Interrups", "cpu_intr"),
    array("CPU Nice", "cpu_nice"),
    array("CPU Soft Interrups", "cpu_sintr"),
    array("CPU System", "cpu_system"),
    array("CPU User", "cpu_user"),
    array("CPU I/O Wait", "cpu_wio"),
    array("Interrups", "interrupts"),
    array("Bytes Read", "bytes_read"),
    array("Bytes Written", "bytes_written"),
    array("Free Disk Space", "disk_free"),
    array("Disk Space Available on /", "disk_free_absolute_rootfs"),
    array("Disk Space Percent Available On /", "disk_free_percent_rootfs"),
    array("Total Disk Space", "disk_total"),
    array("Maximun Disk Space Used", "part_max_used"),
    array("Read Time", "read_time"),
    array("Reads", "reads"),
    array("Write Time", "write_time"),
    array("Writes", "writes"),
/*    array("diskstat_sda_io_time", "diskstat_sda_io_time"),
    array("diskstat_sda_percent_io_time", "diskstat_sda_percent_io_time"),
    array("diskstat_sda_read_bytes_per_sec", "diskstat_sda_read_bytes_per_sec"),
    array("diskstat_sda_read_time", "diskstat_sda_read_time"),
    array("diskstat_sda_reads", "diskstat_sda_reads"),
    array("diskstat_sda_reads_merged", "diskstat_sda_reads_merged"),
    array("diskstat_sda_weighted_io_time", "diskstat_sda_weighted_io_time"),
    array("diskstat_sda_write_bytes_per_sec", "diskstat_sda_write_bytes_per_sec"),
    array("diskstat_sda_write_time", "diskstat_sda_write_time"),
    array("diskstat_sda_writes", "diskstat_sda_writes"),
*///    array("diskstat_sda_writes_merged", "diskstat_sda_writes_merged"),
    array("Memory Buffers", "mem_buffers"),
    array("Cached Memory", "mem_cached"),
    array("Memory waiting to be written to disk", "mem_dirty"),
    array("Free Memory", "mem_free"),
    array("Memory HardwareCorrupted", "mem_hardware_corrupted"),
    array("Memory Mapped", "mem_mapped"),
    array("Shared Memory", "mem_shared"),
    array("Memory actively being written to disk", "mem_writeback"),
    array("Pages In", "page_in"),
    array("Pages Out", "page_out"),
    array("Free Swap Space", "swap_free"),
    array("Swap Pages In", "swap_in"),
    array("Swap Pages Out", "swap_out"),
    array("Major Page Fault", "vm_pgmajfault"),
    array("Pages In from disk", "vm_pgpgin"),
    array("Pages out to disk", "vm_pgpgout"),
    array("VM Efficiency", "vm_vmeff"),
    array("Bytes Received", "bytes_in"),
    array("Bytes Sent", "bytes_out"),
    array("Input Drops", "drops_in"),
    array("Output Drops", "drops_out"),
    array("Input Errors", "errs_in"),
    array("Output Errors", "errs_out"),
    array("Packets Received", "pkts_in"),
    array("Packets Sent", "pkts_out"),
    array("rx_bytes_eth0", "rx_bytes_eth0"),
    array("rx_drops_eth0", "rx_drops_eth0"),
    array("rx_errs_eth0", "rx_errs_eth0"),
    array("rx_pkts_eth0", "rx_pkts_eth0"),
    array("tx_bytes_eth0", "tx_bytes_eth0"),
    array("tx_drops_eth0", "tx_drops_eth0"),
    array("tx_errs_eth0", "tx_errs_eth0"),
    array("tx_pkts_eth0", "tx_pkts_eth0"),
    array("NFS v3 access", "nfs_v3_access"),
    array("NFS v3 getattr", "nfs_v3_getattr"),
    array("NFS v3 lookup", "nfs_v3_lookup"),
    array("NFS v3 read", "nfs_v3_read"),
    array("NFS v3 write", "nfs_v3_write"),
    array("Average Latency of NFS Mounts", "nfsmounts-avg"),
    array("Max Latency of NFS Mounts", "nfsmounts-max"),
    array("Total Running Processes", "proc_run"),
    array("Total Processes", "proc_total"),
    array("Entropy Available", "entropy_avail"),
    array("TCP Segments ", "tcp_insegs"),
    array("TCP Segments Received", "tcp_insegs"),
    array("TCP Segments Sent", "tcp_outsegs"),
    array("TCP Retransmit Percentage", "tcp_retrans_percentage"),
    array("TCP Loss Percentage", "tcpext_tcploss_percentage"),
    array("UDP Packets In", "udp_indatagrams"),
    array("UDP Packets Out", "udp_outdatagrams")
  )
);

#print_r ($parameters);
echo "<br>";
foreach ($parameters as $host => $parameter){
  foreach ($parameter as $title){
    if (${$host."s"}==0){  
#      echo "Host: {$host} ";
#      echo "{$title[0]}";
#      echo "{$title[1]}";
#      echo "<br>";
    }
    else{
      if ($host == "app" && $appFlag == 0){
        echo "<br><div style=\"width: 100%; height: auto; position: absolut; text-align: center; \">";
        echo "=======================================================================================<br>";
        echo "<h3><b>APP SERVERS</b></h3>";
        echo "=======================================================================================<br>";
        $appFlag = 1; 
        echo "</div>";
      }
      elseif ($host == "sql" && $sqlFlag == 0){
        echo "<br><div style=\"width: 100%; height: auto; position: absolut; text-align: center; \">";
        echo "=======================================================================================<br>";
        echo "<h3><b>SQL SERVERS</b></h3>";
        echo "=======================================================================================<br>";
        $sqlFlag = 1; 
        echo "</div>";
      }
      elseif ($host == "pxy" && $pxyFlag == 0){
        echo "<br><div style=\"width: 100%; height: auto; position: absolut; text-align: center; \">";
        echo "=======================================================================================<br>";
        echo "<h3><b>VARNISH SERVERS</b></h3>";
        echo "=======================================================================================<br>";
        $pxyFlag = 1; 
        echo "</div>";
      }
      if ($host == "ngx" && $ngxFlag == 0){
        echo "<br><div style=\"width: 100%; height: auto; position: absolut; text-align: center; \">";
        echo "=======================================================================================<br>";
        echo "<h3><b>NGX SERVERS</b></h3>";
        echo "=======================================================================================<br>";
        $ngxFlag = 1; 
        echo "</div>";
      }

      echo "<div style=\"width: auto; height: auto; position: auto; float: left; margin-right: 25px; margin-bottom: 10px\">";

      $imageGanglia = "http://".$vertical.".".$ganglia."/graph.php?z=xlarge&mreg[]=^".$title[1]."$&hl=".${$host."HostList"}.$timeGraph."&title=".$title[0]."&aggregate=1";
      $imageGanglia = preg_replace('/ /', '%20', $imageGanglia);

      $imageGangliaPrint = "<a href=\"".$imageGanglia."\" target=\"_blank\"><img src=\"".$imageGanglia."\" width='600' height='300'></img></a>";
      $imageGangliaMail = "<a href=".$imageGanglia."><img src=\"".$imageGanglia."\"></img></a>";

      echo "<input type='checkbox' name='graphics[]' value='".$imageGangliaMail."'>";
      echo "{$host} - {$title[0]}<br>";

      echo $imageGangliaPrint; 

//      echo "<a href=\"".$imageGanglia."\" target=\"_blank\"><img src=".$imageGanglia." width='600' height='300'></img></a>";
      
      echo "</div>";

    }
  }
}
echo "<br>";


/*  // original
  echo "Testing graphic, will not be included at the end";
  echo "Load One<br>";
  echo "<a href=\"http://".$vertical.".".$ganglia."/graph.php?z=xlarge&mreg[]=^load_one$&hl=".$appHostList.$timeGraph."&aggregate=1\" target=\"_blank\"><img src=http://".$vertical.".".$ganglia."/graph.php?z=xlarge&mreg[]=^load_one$&hl=".$appHostList.$timeGraph."&aggregate=1"."width='600' height='300'></img></a><br> ";
*/



  
}
} // (sizeof($hostlist)<1)    echo "Error getting the hostlist"; //

function between($src,$start,$end){
  $txt=explode($start,$src);
  $txt2=explode($end,$txt[1]);
  return trim($txt2[0]);
}












?>
