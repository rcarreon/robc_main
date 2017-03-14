#!/usr/bin/php
<?php
$options = getopt('hv');

if (isset($options['h'])) {
  print "This script tests the 3 search api calls that feed the most craved sections on the comingsoon Most Popular page.
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

infoMsg("Starting comingsoon_most_craved", null);

$page = file_get_contents("http://www.comingsoon.net/toppreviews/");
preg_match_all(' (http://search.atomiconline.com\S+) ', $page, $urls, PREG_PATTERN_ORDER);
$minimum_item_count = 20;

if (sizeof($urls) == 0) {
  infoMsg("no urls retrieved", 1);
}

foreach ($urls[0] as $url) {
  # check if page is valid
  if (fopen($url, 'r')) {
    infoMsg("OK - $url accessible", null);
    $feed = file_get_contents($url);
    preg_match_all('|<item>|', $feed, $items, PREG_PATTERN_ORDER);
    $count = sizeof($items[0]);
 
    if ($count >= $minimum_item_count) {
      infoMsg("OK - $url contains $count entries", null);
    } else {
      infoMsg("NOT OK - $url should have at least $minimum_item_count entries but found $count", 1);
    }

  } else {
    infoMsg("NOT OK - $url not accessible", 1);
  }
}

if (isset($options['v'])) {
  infoMsg("Finished comingsoon_most_craved", null);
} else {
  infoMsg("OK - comingsoon most craved search api calls work", 0);
}
?>

