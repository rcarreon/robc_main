#!/usr/bin/php -q
<?php
/*
Plugin to alert on trending increases or decreases based on weekly ganglia graphs.
*/

error_reporting(E_ALL ^ E_NOTICE);
$MY_PERCENT=95;
$str='';

$shortopts = "u:w:c:t:m:p:s:d";
$options = getopt($shortopts);

$URL = $options['u'];
$TYPE = ($options['t']) ? $options['t'] : 'percent';
$MODE = ($options['m']) ? $options['m'] : 'points';
$DEBUG = (isset($options['d'])) ? 1 : 0;
$MY_PERCENT = ($options['p']) ? $options['p'] : $MY_PERCENT;
$SKIP = $options['s'];

if (filter_var($URL, FILTER_VALIDATE_URL) === FALSE) {
   echo "Args wrong!\nganglia_trend_alert.php -u <ganglia graph url> -t [fixed|percent] -m [diffs|points] -w <WARN> -c <CRIT>\nIf set to 'fixed' WARN and CRIT must be set.\nYou can also set an optional -p with a pecentage only if type is percent and -d will turn on debug messages.\n";
   echo "Defaults:\n\t-t percent\n\t-m points\n\t-w .15\n\t-c .25\n\t-p 95\n\n";
   exit();
   exit;
}

$WARN_ALERT=($options['w']) ? $options['w'] : .15;
$CRIT_ALERT=($options['c']) ? $options['c'] : .25;

function array_average($arr, $type) {
   if ( intval(array_sum($arr) / count($arr)) == 0 ) {
      return ($type=='high') ? 1 : -1;
   } else {
      return array_sum($arr) / count($arr);
  }
}

function curl_get_file_contents($URL)
    {
        $c = curl_init();
        curl_setopt($c, CURLOPT_RETURNTRANSFER, 1);
        curl_setopt($c, CURLOPT_FOLLOWLOCATION, 1);
        curl_setopt($c, CURLOPT_URL, $URL);
        $contents = curl_exec($c);
        curl_close($c);

        if ($contents) return $contents;
            else return FALSE;
    }

function is_alert($percentile,$alert_num,$type,$ishigh=1){
   if (strtolower($type)=='percent') {// percent type lets do some math
	if ($ishigh)
      	   return $percentile+($percentile*$alert_num);
	else
      	   return $percentile-($percentile*$alert_num);
   }else{
	if ($ishigh)
      	   return $percentile+$alert_num;
	else
      	   return $percentile-$alert_num;
   }
}


// http://ci.gweb.gnmedia.net/graph.php?r=week&c=mem-cache-prd&h=mem1v-ci.ci.prd.lax.gnmedia.net&v=20304102&m=mc_evictions&jr=&js=&vl=items&ti=Number+of+valid+items+removed+from+cache+to+free+memory+for+new+items&json=1'
$tmp=curl_get_file_contents($URL);


$data = json_decode($tmp,true);
$arr=$data[0]['datapoints'];
foreach ($arr as $name => $value) {
    	foreach ($value as $n => $v) {
	   if ($n==0)
		$points[]=$v;
	}
}


$last=NULL;
$today=NULL;
$count=0;

if (end($points)==0)
	array_pop($points);

if ($MODE=='diffs'){
	$last=array_shift($points);
	foreach ($points as $e){
		$diffs[]=$e-$last;
        	$last=$e;
   		$count++;
	}

	$today=array_pop($diffs);
	sort($diffs);
	$the_high = $diffs[round(($MY_PERCENT/100) * count($diffs) - .5)];
	$the_low = $diffs[round(($MY_PERCENT/100) / count($diffs) + .5)];

}else{
//$points=array(1,2,3,4,5,6,7,8,9,10);
 	$today=array_pop($points);
	$the_high = array_average ( $points, 'high' ) * (($MY_PERCENT/100)+1);
	$the_low = array_average ( $points, 'low' ) / (($MY_PERCENT/100)+1);
	echo ($DEBUG) ? "average:" . array_average ( $points, 'high' ) . " ... " : '';
}

echo ($DEBUG) ? "the_high=$the_high ... the_low=$the_low ... current=$today\n" : '';

// firt we check the high end alert
echo ($DEBUG) ? "high crit percent: " . $CRIT_ALERT . " =".is_alert($the_high,$CRIT_ALERT,$TYPE,1). "\n" : '';
echo ($DEBUG) ? "high warn percent: " . $WARN_ALERT . " =".is_alert($the_high,$WARN_ALERT,$TYPE,1). "\n" : '';

if ($today>is_alert($the_high,$CRIT_ALERT,$TYPE,1)){
	$str= "CRIT: Current ($today) is higher than average (" . is_alert($the_high,$CRIT_ALERT,$TYPE,1) . ")!\n";
}else if ($today>is_alert($the_high,$WARN_ALERT,$TYPE,1)){
	$str .= "WARN: Current ($today) is higher than average (" . is_alert($the_high,$WARN_ALERT,$TYPE,1) . ")!\n";
}



// next we check the low end alert?
if ($SKIP != 'low') {
   echo ($DEBUG) ? "low crit percent: " . $CRIT_ALERT . " =".is_alert($the_low,$CRIT_ALERT,$TYPE,0). "\n" : '';
   echo ($DEBUG) ? "low warn percent: " . $WARN_ALERT . " =".is_alert($the_low,$WARN_ALERT,$TYPE,0). "\n" : '';

   if ($today<is_alert($the_low,$CRIT_ALERT,$TYPE,0)){
	$str .= "CRIT: Current ($today) is lower than average (" . is_alert($the_low,$CRIT_ALERT,$TYPE,0) . ")!\n";
   }else if ($today<is_alert($the_low,$WARN_ALERT,$TYPE,0)){
	$str.= "WARN: Current ($today) is lower than average (" . is_alert($the_low,$WARN_ALERT,$TYPE,0) . ")!\n";
  }
}


if (strpos($str,'CRIT') !== false) {
  echo $str;
  exit(2);
} elseif (strpos($str,'WARN') !== false) {
  echo $str;
  exit(1);
} else {
  echo "OK: Everything looks good.\n";
  exit(0);
}
