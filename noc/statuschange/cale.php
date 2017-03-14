<?php

//$me = "rodolfo.angel";

//include 'Lib.php';
$returned_array = new RT();

$query2 = "Queue = 'Q_StatusChange'" //query to get status change tickets
/*        ."AND ("
        ." Status = 'open'"
        ." OR "
        ." Status = 'new'"
        ." OR "
        ."Status = 'stalled' "
        .") "
*/
        ."AND "
        ."Created >= '01/03/15' "
/*
        ."AND "
        ."Subject NOT LIKE 'New Hire'";
*/;


$tickets = $returned_array -> search($query2); //grab list of tickets from queue
$myarea = $returned_array -> sc_field($me); //my area of interest
      
//print_r($myarea);

$tecks = array();
foreach ($tickets as $ticks) {
//      file_put_contents("txt.file",strtok($ticks, ":").PHP_EOL,FILE_APPEND);
        $tecks[] = strtok($ticks, ":");
}
$whole = $returned_array -> FindId(max($tecks), "yes"); //grabs the complete template
//var_export($whole)
$fieldid = $returned_array -> FindId(max($tecks)); //grabs section of the ticket with details like first|last name and date.

$array1 = array(); //array to store verticals/departments names from template
$array2 = array(); //array to store users involved on each vetical/department

$ti == 0; $j ==0; //very important flags


$parta = 0; //stores first int for TBD section on th earray
$partb = 0; //stores last int for TDB section in the array

$pj = 0; //very important flags

$tempid = "";

$loop=1; //variable needed to count to 3
foreach ($whole as $itos) { //goes through the whole template
        if (strpos($itos,"(id/")) { //finding id numbers on the ticket
                if ($loop == 3) { //we're looking for the third id on the ticket
                        $ids = trim($itos);
                        $parts = explode("/", $ids);
                        //echo $parts[2]."<br>";
                        $tempid = $parts[2]; //stores necessary id to read only the Status Change template
                        break;
                }
                $loop++;
        }
}

$urler = $returned_array -> GetId(max($tecks),$tempid,"yes"); //stores StatusChange template
/*
foreach ($urler as $meh) {
	echo $meh."<br>";
}
*/
/*
foreach ($myarea as $uou) {
	echo $uou."<br>";
}
*/
foreach ($urler as $derp) {
        if (strpos($derp,"[")) {
                preg_match_all("^\[(.*)\]^",$derp,$ticketfields, PREG_PATTERN_ORDER); //grabs fields name inside square brackets
                preg_match_all("#\((.*?)\)#", $derp, $names, PREG_PATTERN_ORDER); //grabs usernames inside parenthesis
                $array1[$ti] = $ticketfields[1][0]; $ti++; //adds fields/vertical/department name to the array
                $array2[$j] = $names[1][0]; $j++; //adds users involved in the status change process
        }
}
/*
echo "<br>";
var_export($array1);
echo "<br>";
var_export($array2);
echo "<br>";
*/

$tasker = array();
$tf = 0;

foreach ($myarea as $uou) {
//        echo "[".$uou."]<br>";
//}

$next = 0; $k = 0;
foreach ($array1 as $arr) { //goes through the field/vertical list
//		if (!strcmp(str_replace(' ','',$arr),end($myarea))) { //finds the correct field/area/vertical for current user
                if (!strcmp(str_replace(' ','',$arr),$uou)) { //finds the correct field/area/vertical for current user
                        $next = $k+1; //integer to point next field/area/vertical from current user
                }
                $k++;
}
$area1 = "[".$uou."]"; //my field/area/vertical/department
//$area1 = "[".end($myarea)."]"; //my field/area/vertical/department
$area2 = "[".$array1[$next]."]"; //next field/area/vertical/...

/*
echo "<br>";
echo $area1;
echo "<br>";
echo $area2;
echo "<br>";
*/

$pos1=0; $pos2=0; 
$pj=0;
$parta=0; $partb=0;
foreach ($urler as $damn) { //goes through the template array again
        $pos1 = strpos(str_replace(' ','',$damn),$area1); $pos1++; //looks for array position for users field/Area and adds 1 to prevent being 0
        $pos2 = strpos($damn,$area2); $pos2++; //looks for array position for next field/area on the template and adds 1 to prevent being 0
        if ($pos1) {
                $parta=$pj;

        } if ($pos2) {
                $partb=$pj;
        }

        $pj++;
}

$minitemp = array(); //array to store new array for actions To Be Done for each ticket and field/Area
$z = 0; //super important variable 

for ($n = ++$parta; $n<$partb-1; $n++) {
        $minitemp[$z] = $urler[$n];
        $z++;
}

foreach ($minitemp as $mini) {
        //echo $mini."<br>";
	$tasker[$uou] .= $mini."<br>";
}
$tf++;
}
/*
var_export($myarea);
echo "<br>";
var_export($tasker);

*/
/*
foreach ($myarea as $uou) {
	echo "[".$uou."]<br>";
	echo $tasker[$uou];
	echo "<br>";
}
*/

//var_export($myarea);
?>