#!/usr/bin/php
<?php
{
  include("/app/shared/http/reports/include/mysql-connect.inc");
  $api_key = "ttjo9hgc9tja8ii05hi9zxkow8h44vye";
  #$mysql_host = "reports.hmo.gnmedia.net";
  #$mysql_user = "rpt_incidents";
  #$mysql_pass = "reportn0cstation";
  #$mysql_dbname = "nocreports";

  class pingdomAuthClass {
    public   $user = "technologyplatform@gorillanation.com";
    public   $pass = "N@gio5B4";
  };

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
  };

  $pingdomAuth = new pingdomAuthClass;

  $curl = curl_init();
  curl_setopt($curl, CURLOPT_URL, "https://api.pingdom.com/api/2.0/checks");
  curl_setopt($curl, CURLOPT_CUSTOMREQUEST, "GET");
  curl_setopt($curl, CURLOPT_USERPWD, "$pingdomAuth->user:$pingdomAuth->pass");
  curl_setopt($curl, CURLOPT_HTTPHEADER, array("App-Key: $api_key"));
  curl_setopt($curl, CURLOPT_RETURNTRANSFER, 1);

  $response = json_decode(curl_exec($curl),true);

  if (isset($response['error'])) {
    print "Error: " . $response['error']['errormessage'] . "\n";
    exit;
  }

  $down_hosts = array (new pingdomHostCheckClass);

  // Returns the hosts with down status
  $j=0;
  for ($i=0; $i<count($response["checks"]); $i++) {
    //printf("%s\n", $response["checks"][$i]["status"]);  /*igm */
    //if ($response["checks"][$i]["status"] == "down") {
    if ($response["checks"][$i]["status"] != "up") {
	$down_hosts[$j++] = $response["checks"][$i];
	printf("Bad host: %s  | timestamp: %d\n",
	       $response["checks"][$i]["hostname"],
	       $response["checks"][$i]["lasterrortime"]);
    }
  }

  if ($j) {
    //$link = mysql_connect("$mysql_host", "$mysql_user", "$mysql_pass");
   $link = database_open("localhost", "w"); 
   if (!is_object($link)) {
      die('Could not connect: ' . mysql_error());
    }

    for ($i=0; $i<$j; $i++) {
      //print_r($down_hosts[$i]);  /*igm*/

      $query = "SELECT s.id, i.down_timestamp FROM rpt_sites s INNER JOIN rpt_incidents i ON s.id=i.site_id WHERE ";
      $query.= sprintf("s.name='%s' AND i.down_timestamp=%d LIMIT 1", $down_hosts[$i]["hostname"],
		       $down_hosts[$i]["lasterrortime"]);
      //echo "$query\n";   /*igm*/
      $result = database_query($query);
      if (!$result) {
	die('Could not query:' . mysql_error());
      }
      
      if (database_num_rows($result)==0) {
	/* Ejecutar insert aqui */
	$query = sprintf("INSERT INTO rpt_incidents (site_id, down_timestamp) SELECT id,%d FROM rpt_sites WHERE name='%s'\n",
			 $down_hosts[$i]["lasterrortime"], $down_hosts[$i]["hostname"]);
	echo "$query\n";    /*igm*/
	/*$result = database_query($query);
	if (!$result) {
	  die('Could not query:' . mysql_error());
	}*/
      }
    }
    close_database($link);
  }
}
?>
