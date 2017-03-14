<?php
//Print the rttickets
function vc_rt($type){

// $type means if you will received all visual check related tickes on Q_NOC
// possible values are: all, fwd, noc

if($type == "noc")
  $vctickets = shell_exec('sh include/rttickets_noc');
elseif ($type == "fwd")
  $vctickets = shell_exec('sh include/rttickets_fwd');
else
  $vctickets = shell_exec('sh include/rttickets');



#echo $vctickets;
#echo "==============\n";
$tickets=explode("\n", $vctickets);

$nTickets=count($tickets)-1;  //number of total tickets
$nt=1; //number of ticket (for the tool, starting from 1)
foreach ($tickets as $ticket)
{
#  echo $ticket."<br>";
  $ticketLink=explode(":", $ticket);

  $numItems=count($ticketLink);
  $i=1;
  $ticket_line = "";
  foreach ($ticketLink as $tl)
  {

    if ($i==1 && $numItems>1)
    {
      echo "<a href=\"https://rt.gorillanation.com/Ticket/Display.html?id=$tl\" target=\"_blank\">$tl</a>: ";
      $ticket_line .= "<a href=\"https://rt.gorillanation.com/Ticket/Display.html?id=$tl\" target=\"_blank\">$tl</a>: ";
      #echo $i;
      $ticketNumber=$tl;
      $i++;
    }

    elseif ($i == $numItems AND $tl!="")
    {
      echo $tl."<br>";
      $ticket_line .= $tl."<br>";
?>
<input type="hidden" name="ticket<?php echo $nt;?>" value='<?php echo $ticket_line;?>'>
<input type="hidden" name="ticketNumber<?php echo $nt;?>" value='<?php echo $ticketNumber;?>'>
<input type="radio" onClick="lffm();" name="visualcheck<?php echo $nt;?>" value="LFFM" checked> LFFM
<input type="radio" onClick="issue();" name="visualcheck<?php echo $nt;?>" value="Issue still persists"> Issue still persists<br>
Comments: <br>
<textarea name="comments<?php echo $nt;?>" cols="50" rows="3"></textarea><br>
<?php


      #echo $i;
      $i++;
    }
    else
    {

      if ($tl!="")
      echo $tl.": ";
      $ticket_line .= $tl.": ";
      #echo $i;
      $i++;
    }

  }
  $nt++;
}
?>
-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-<br>
General Comments: <br>
<textarea name="comments" cols="50" rows="3"></textarea>
<input type="hidden" name="speedtest" id="speedtest" value="Come on! wait for the speedtest..")>
<?php
}//End of function vc_rt();

function vc_rt_lines($type){

// $type means if you will received all visual check related tickes on Q_NOC
// possible values are: all, fwd, noc

if($type == "noc")
  $vctickets = shell_exec('sh include/rttickets_noc');
elseif ($type == "fwd")
  $vctickets = shell_exec('sh include/rttickets_fwd');
else
  $vctickets = shell_exec('sh include/rttickets');

#echo $vctickets;
#echo "==============\n";
$tickets=explode("\n", $vctickets);

$nTickets=count($tickets)-1;  //number of total tickets

foreach ($tickets as $ticket)
{
#  echo $ticket."<br>";
  $ticketLink=explode(":", $ticket);

  $numItems=count($ticketLink);
  $i=1;

  foreach ($ticketLink as $tl)
  {

    if ($i==1 && $numItems>1)
    {
      echo "<a href=\"https://rt.gorillanation.com/Ticket/Display.html?id=$tl\" target=\"_blank\">$tl</a>: ";
      #echo $i;
      $i++;
    }

    elseif ($i == $numItems AND $tl!="")
    {
      echo $tl."<br>";
      #echo $i;
      $i++;
    }
    else
    {

      if ($tl!="")
      echo $tl.": ";
      #echo $i;
      $i++;
    }

  }
}

}//End of function vc_rt_lines();

function shift(){

date_default_timezone_set('America/Hermosillo');
#echo date("H:i:s", time());    //16:45:58

$hour = date('Hi', time());        // HHMM
$date = date("m-d-y", time());     // 07-02-08

#echo "Hour: ".$hour." Date: ".$date."<br><br>";  //Actual date

if( $hour >= 600 && $hour <= 1530) {
  echo "[Morning ".$date."]";
}
else if($hour > 1530 && $hour <= 2330) {
  echo "[Evening ".$date."]";
}
else {
  echo "[Graveyard ".$date."]";
}

}//end of shift function

function rt_add_comment($ticketNumberX, $shift, $visualcheckX, $commentsX)
{
  $commentsX = preg_replace('#<br\s*/?>#i', "<br>", $commentsX);
  $full_comment = $shift." ".$visualcheckX.'<br>'.$commentsX;
  $full_comment = str_replace('<br>', '\n', $full_comment);
  #$full_comment = str_replace('<br />', '\n', $full_comment);
  #$full_comment = str_replace('\n', '\r\n', $full_comment);
   
  $full_comment = strip_tags($full_comment, "\n");
  $ticketNumberX = strip_tags($ticketNumberX);

  #echo "sh include/rttickets_add_comment \"$ticketNumberX\" \"$full_comment\"";
  #echo "<br><br>";
  
  exec("sh include/rttickets_add_comment \"$ticketNumberX\" \"$full_comment\"");

}

// Validate an email address. Not used
function validateEmailAddress($email) {
    return filter_var($email, FILTER_VALIDATE_EMAIL) && preg_match('/@.+\./', $email);
}

?>
