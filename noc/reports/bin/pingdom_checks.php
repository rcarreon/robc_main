#!/usr/bin/php
<?php
// 2012-2013 Eduardo Osorio, Omar Rivera & Rey Estrada. Gorilla Nation
{
  $app_dir = "/app/shared/http/reports";
  include("${app_dir}/include/config.inc");
  include("${app_dir}/include/functions.inc");
  include("${app_dir}/include/mysql-connect.inc");
  include("${app_dir}/include/debug-functions.inc");

  date_default_timezone_set('America/Los_Angeles');
  switch (php_uname('n')) {
    case "app1v-noc.tp.prd.lax.gnmedia.net":
      $host = new hostClass("prd");
    break;
    case "app1v-noc.tp.dev.lax.gnmedia.net":
      $host = new hostClass("dev");
    break;
    case "apache02.n2.hmo.gnmedia.net":
      $host = new hostClass("hmo");
    break;
    case "eoteam":
    default:
      $host = new hostClass("eoteam");
      break;
  }

  class pingdomHostCheckClass {
    public   $id;	
    public   $created;
    public   $name;
    public   $hostname;
    public   $resolution;
    public   $type;
    public   $lasterrortime;
    public   $lasttesttime;
    public   $lastresponsetime;
    public   $status;

    public function __construct($checks_arr) {
      $this->hostname = $checks_arr["hostname"];
      $this->id = $checks_arr["id"];
      $this->lasterrortime = $checks_arr["lasterrortime"];
      $this->lastresponsetime = $checks_arr["lastresponsetime"];
      $this->lasttesttime = $checks_arr["lasttesttime"];
      $this->status = $checks_arr["status"];
      $this->type = $checks_arr["type"];
      $this->resolution = $checks_arr["resolution"];
    }
  };

  class sitesUpClass {
    public   $id;	
    public   $rptincidents_id;
    public   $site_id;
    public   $statusup;
  };

  $pingdomAuth = new pingdomAuthClass;

  $curl = curl_init();
  
/* $debug_pingdom_json!=0 to let curl.php emulate Pingdom json responses */
  if($debug_pingdom_json){
    //$hostname = php_uname('n');
    //$curl_script_name="/bin/curl.php";
    //curl_setopt($curl, CURLOPT_URL, "{$host->vhosturl}{$curl_script_name}");
    $curlexec=emulate_pingdom_json();
  }
  else{
    curl_setopt($curl, CURLOPT_URL, "https://api.pingdom.com/api/2.0/checks");
    curl_setopt($curl, CURLOPT_CUSTOMREQUEST, "GET");
    curl_setopt($curl, CURLOPT_USERPWD, "$pingdomAuth->user:$pingdomAuth->pass");
    curl_setopt($curl, CURLOPT_HTTPHEADER, array("App-Key: $host->api_key"));
    curl_setopt($curl, CURLOPT_RETURNTRANSFER, 1);
    $curlexec = curl_exec($curl);
    //echo $curlexec;
  }

  $response = json_decode($curlexec,true);
  //echo $response;

  if (isset($response['error'])) {
    print "Error: " . $response['error']['errormessage'] . "\n";
    exit;
  }

  $down_hosts = array();
  $link = database_open($mysql_host, "w");

  if (!is_object($link)) {
     die('Could not connect: ' . mysqli_connect_error());
  }

  // Returns the hosts with down status
  $j=0; //print_r($response);
  for ($i=0; $i<count($response["checks"]); $i++) {
    if(isset($response["checks"][$i]["lasterrortime"]))
      $lasterrorST= date("D M j g:i a T Y", $response["checks"][$i]["lasterrortime"]);
    //else because there are some registers that don't have lasterrortime registered
    else { 
      $response["checks"][$i]["lasterrortime"] = $response["checks"][$i]["lasttesttime"];
      $lasterrorST= date("D M j g:i a T Y", $response["checks"][$i]["lasterrortime"]);
    }
    $lasttestST= date("D M j g:i a T Y", $response["checks"][$i]["lasttesttime"]);

    //TEMP CHECKING IF SITE EXISTS
    //$temp=str_replace('www.','',$response["checks"][$i]["hostname"]); 
    //ifsitexst($temp, $link);
   
    if ($response["checks"][$i]["status"] != "up") {
      $down_hosts[$j++] = new pingdomHostCheckClass($response["checks"][$i]);


      //LOG ONLY
      echo "\nLOG:"; 
      printf("Bad host: %s | status: %s | lasterrortime: %d | lasterrorST: %s | lasttesttime %d | lasttestST %s\n",
               $response["checks"][$i]["hostname"], 
               $response["checks"][$i]["status"], 
               $response["checks"][$i]["lasterrortime"],$lasterrorST, 
               $response["checks"][$i]["lasttesttime"],$lasttestST);
    }
    else {
    //SITES WITH UP ONLY..........    IF EXISTS as DOWN/UNCONFIRMED DOWN in RPT_REPORT NEEDS TO BE UPDATED
      $sitedb = str_replace('www.','',$response["checks"][$i]["hostname"]);
      $query = sprintf("SELECT a.id FROM rpt_report a, rpt_sites b WHERE a.site_id=b.id AND b.name='%s' AND a.uptime IS NULL",
              $sitedb);
      //echo "Exists? ".$query."\n";
      $result4 = database_query($query, $link);
      if (!$result4) {
        echo 'Error: ' . mysqli_error($link);
        exit;
      } 
      while ($obj = database_fetch_object($result4)) {
        $report_id = $obj->id;         
        //if($flag=="yes"){//IF EXISTS AS DOWN IS GOING TO BE UPDATED
        $query = sprintf("UPDATE rpt_report SET uptime = %d, status = 'up' WHERE  id = %d", $response["checks"][$i]["lasttesttime"], $report_id);
        echo "$query\n"; 
        $result = database_query($query, $link);
        if (!$result)
            die('Could not query:' . mysqli_error($link));	
        //}
      }
    }//END OF SITES WITH UP ONLY
  }

  if ($j) {  
    //ONLY STATUS!=UP 
    for ($i=0; $i<$j; $i++) { 
      //Each incident that is going to be checked because is DOWN
      $sitedb=str_replace('www.','',$down_hosts[$i]->hostname);
      print_r($down_hosts[$i]);  /*igm*/
      $query = "SELECT s.id, i.down_timestamp, i.lasttesttime, i.status FROM rpt_sites s INNER JOIN rpt_incidents i ON s.id=i.site_id WHERE ";
      $query.= sprintf("s.name='%s' AND i.down_timestamp=%d AND i.lasttesttime=%d AND i.status='%s' LIMIT 1",
              $sitedb, $down_hosts[$i]->lasterrortime, $down_hosts[$i]->lasttesttime,
              $down_hosts[$i]->status);
      echo "$query\n"; 
      $result = database_query($query, $link);
      if (!$result)
        die('Could not query:' . mysqli_error($link));
 
      //==0 BECAUSE WE DONT WANT TO INSERT DUPLICATE REGISTERS HOSTNAME LASTERRORTIME
      if (database_num_rows($result)==0) { 
           
        //IF DOESN'T EXISTS IN RPT_REPORT LETS CREATE THE RECORD
        $list=ifsitedown($sitedb, $link, $down_hosts[$i]->status); //$flag=$ifsitedown["bool"]; $rpt_report=$ifsitedown["report_id"];
        echo " \$list= ".$list."\n";
        list($flag, $report_id) = explode("/", $list);

        if($flag=="no"){          		        
//INSERT IN RPT_REPORT USING IDRPTINCIDENTS
           $regrepeat=0;                     
           $query = sprintf("INSERT INTO rpt_report (site_id, downtime, uptime, status) SELECT id,%d,null,'%s' FROM rpt_sites WHERE name='%s'",
                    $down_hosts[$i]->lasttesttime,$down_hosts[$i]->status,$sitedb);
            //print_r($down_hosts[$i]);
           echo "$query\n"; 
           $result = database_query($query, $link);
           if (!$result) 
             die('Could not query:' . mysqli_error($link));
     	}
        else
           // EXISTS AS DOWN in RPT_sitesup Repeat = TRUE 	     	  	
     	  $regrepeat=1;
         
         //Each incident that is going to be INSERTED in rpt_incidents
        $list=ifsitedown($sitedb, $link, $down_hosts[$i]->status); //$flag=$ifsitedown["bool"]; $rpt_report=$ifsitedown["report_id"]; echo " \$list= ".$list;
        list($flag, $report_id) = explode("/", $list); //echo " \$flag= ".$flag." \$rpt_report= ".$rpt_report."\n";
        //if($flag=="yes"&&$down_hosts[$i]["status"]=="unconfirmed_down"){ $report_id=0;}
         
        $query = sprintf("INSERT INTO rpt_incidents (site_id, down_timestamp, lasttesttime, status, report_id, regrepeat) SELECT id,%d,%d,'%s',%d,%d FROM rpt_sites WHERE name='%s'",
            $down_hosts[$i]->lasterrortime,$down_hosts[$i]->lasttesttime,$down_hosts[$i]->status,
                $report_id, $regrepeat, $sitedb );

        $result = database_query($query, $link);
        if (!$result) 
          die('Could not query:' . mysqli_error($link));
      }
      else
         echo "Repeated register\n";
    }
  }
  database_close($link);
}
?>
