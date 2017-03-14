<?php

/* Hostnames, Pingdom API keys and Virtual Hostnames */
/* E. Osorio */
class hostClass {
  public $hostname;
  public $api_key;
  public $vhosturl;
  public $type;

  public function __construct($type) {
    switch($type) {
      case "prd":
        $this->hostname = "app1v-noc.tp.prd.lax.gnmedia.net";
      	$this->api_key = "phrcs40ebqfi5xjmgdimj53is51otj3i";
        $this->vhosturl = "http://nocreports.gnmedia.net";
        break;
      case "dev":
        $this->hostname="app1v-noc.tp.dev.lax.gnmedia.net";
        $this->api_key = "nb8539g5402jlh6l7k5padsqb8rlti6l";
        $this->vhosturl = "http://dev.nocreports.gnmedia.net";
        break;
      case "hmo":
        $this->hostname="apache02.n2.hmo.gnmedia.net";
        $this->api_key = "wvfav77lexv59sorgmdgks80pxrej0hv";
        $this->vhosturl = "http://reports.hmo.gnmedia.net";
        break;
      case "eoteam":
      default:
        $this->hostname="localhost";
        $this->api_key = "wvfav77lexv59sorgmdgks80pxrej0hv";
        $this->vhosturl = "http://localhost/project/reports";
        break;
    }
    $this->type = $type;
  }
}

/* MySQL settings */
$mysql_host = "localhost";
$mysql_dbname = "nocreports";

/* Pingdom user and pass */
class pingdomAuthClass {
    public   $user = "technologyplatform@gorillanation.com";
    public   $pass = "N@gio5B4";
};

/* Directories */
$img_dir = "images";

/* Icons and logos */
$warning_icon = "warning.png";
$critical_icon = "critical.png";
$report_icon = "report.png";

$timezone='America/Los_Angeles';

/* Graphite settings */
$graphite_url = "http://graphite.gnmedia.net/render/";
$salt=1328377644.834;

/* $debug_pingdom_json!=0 to let curl.php emulate Pingdom json responses */
$debug_pingdom_json = 0;
?>
