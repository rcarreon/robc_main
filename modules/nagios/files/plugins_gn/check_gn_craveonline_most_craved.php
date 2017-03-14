#!/usr/bin/php
<?php
$options = getopt('hv');

if (isset($options['h'])) {
  print "This script tests the links in the 4 most craved sections on the craveonline homepage.
The default output should be nagios ready (one line of output and appropriate error code).

-h    show help
-v    verbose mode 
\n";
  exit;
}

function infoMsg($msg, $error_value) {
  global $options;
  if (isset($options['v']) || isset($error_value)) {
    $type = $error_value ? 'ERROR' : 'INFO';
    echo date("Y-m-d H:i:s"). " [$type] $msg\n";
    if (isset($error_value)) {
      exit($error_value);
    }
  }
}

infoMsg("Starting craveonline_most_craved", null);

$return_value = 0;

$homepage = file_get_contents("http://www.craveonline.com");
preg_match_all('/excerpt\.php\?url\=(\S+)?"/', $homepage, $urls, PREG_PATTERN_ORDER);
$uniq_urls = array_unique($urls[1]);

if (sizeof($uniq_urls) == 0) {
  infoMsg("no urls retrieved", 1);
}

#$DB_HOST = "localhost"; $DB_USER = "root"; $DB_PASS = ""; $SEARCH_HOST = "http://dev.search.atomiconline.com";
$DB_HOST = "sqlw-spx.sb.gnmedia.net"; $DB_USER = "django"; $DB_PASS = "aiQu1Ier"; $SEARCH_HOST = "http://search.atomiconline.com";

$mysqli = new mysqli($DB_HOST, $DB_USER, $DB_PASS, 'search_data');
if (mysqli_connect_errno()) {
        infoMsg("Connect failed: ". mysqli_connect_error(), 1);
}

$check_stmt = $mysqli->prepare("SELECT id FROM spider_data_urls WHERE url = ?");

foreach ($uniq_urls as $url) {
  # check if page is valid
  if (fopen($url, 'r')) {
    infoMsg("OK - $url accessible", null);
    
    # check if url is in search_data db
    $check_stmt->bind_param('s', $url);
    $check_stmt->execute(); 
    $check_stmt->bind_result($id);
    $check_stmt->fetch();
   
    if ($id) {
      infoMsg("OK - $url found in spider_data_urls", null);
    } else {
      infoMsg("NOT OK - $url not found in spider_data_urls", 1);
    }

  } else {
    infoMsg("NOT OK - $url not accessible", 1);
  }
}

$check_stmt->close();
$mysqli->close();

if (isset($options['v'])) {
  infoMsg("Finished craveonline_most_craved", null);
} else {
  infoMsg("OK - craveonline homepage most craved links work", 0);
}
?>

