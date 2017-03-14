<!DOCTYPE html>
<html>
<head>
<title>Visual Check Report Tool</title>
<?php
include("include/functions.inc");
$i=1;
if (isset($_POST["shift"]))
{
  $to=$_POST["to"];
  #$to="rey.estrada@evolvemediallc.com";
  $subject=$_POST["status"];
  $message ="";
 
  date_default_timezone_set('America/Hermosillo'); 
  $random_hash = md5(date('r', time()));
  $headers = "From: noc@evolvemediallc.com\r\n"
            ."Content-Type: text/html; boundary=\"PHP-alt-".$random_hash."\"";

  $ticket[]=""; 
  $visualcheck[]="";
  $comments[]="";
  $ticketNumber[]="";

 $shift=$_POST["shift"]; 
 echo $shift."<br><br>"; 

 $message .= $shift."<br><br>";

 while (isset($_POST["ticket$i"]))
 {
  $ticket[$i]=$_POST["ticket$i"];
  $visualcheck[$i]=$_POST["visualcheck$i"];
  $comments[$i]=nl2br($_POST["comments$i"]);
  $ticketNumber[$i]=$_POST["ticketNumber$i"];

  echo $ticket[$i];
  echo $visualcheck[$i]."<br>";

  $message .= $ticket[$i].$visualcheck[$i]."<br>";

  if ($comments[$i]!="")
  {
    echo "Comments: <br>";
    echo $comments[$i]."<br>";

    $message .= "Comments: <br>".$comments[$i]."<br>";

  }

  echo "<br>";
  $message .= "<br>"; 
  $i++;

 }

 $commentsG=nl2br($_POST["comments"]);
 $speedtest=$_POST["speedtest"];
 
 if ($commentsG!="")
 {
  echo "<br>";
  echo "General Comments <br>";
  echo $commentsG."<br>";

  $message .= "<br>"."General Comments <br>".$commentsG."<br>";

 }
 echo "<br>";
 echo "<strong>".$speedtest."</strong>";
 
 $message .= "<br>"."<strong>".$speedtest."</strong>"; 

  mail($to, $subject, $message, $headers); 

 echo "<br><br><br><br><br>";
 echo "<strong>Mail Sent Successfully</strong><br>";

#  This section is to add the information to the ticket
 $i=1;
 while(isset($ticket[$i]))
 {
   $ticketNumber[$i]="32853";  //hardcoding ticket for testiong purposes
   rt_add_comment($ticketNumber[$i], $shift, $visualcheck[$i], $comments[$i]);
   $i++;
 } 
}
else
{

?>
<script>
function loadXMLDoc()
{
document.getElementById("spDiv").innerHTML="<p style=\"color:red\"> Doing speedtest...<br> Please be patient, it takes about 25 seconds</p>";
if (window.XMLHttpRequest)
  {// code for IE7+, Firefox, Chrome, Opera, Safari
  xmlhttp=new XMLHttpRequest();
  }
else
  {// code for IE6, IE5
  xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
  }
xmlhttp.onreadystatechange=function()
  {
  if (xmlhttp.readyState==4 && xmlhttp.status==200)
    {
    document.getElementById("spDiv").innerHTML=xmlhttp.responseText;
    document.getElementById("speedtest").value=xmlhttp.responseText;
    }
  }
xmlhttp.open("GET","include/sp.php",true);
xmlhttp.send();
}
</script>

<script>
function lffm()
{
    document.getElementById("statusDiv").innerHTML="Visual Check OK";
    document.getElementById("status").value="Sites Visual Check [OK]";
}
</script>

<script>
function issue()
{
    document.getElementById("statusDiv").innerHTML="Visual check issue";
    document.getElementById("status").value="Sites Visual Check [issue]";
}
</script>

</head>
<body onload="loadXMLDoc();">
<h2><div id="statusDiv">Visual Check OK</div></h2>
<?php shift();?>
<!-- ######################################
###### CK Editor #################
<textarea class="ckeditor" name="editor1">
test text test text test text
</textarea>
######################################    -->
<br>
-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-<br>
<form method="POST" action="<?php $_SERVER['PHP_SELF'];?>"  enctype="multipart/form-data">
<input type="hidden" name="status" id="status" value="Sites Visual Check [OK]">
<input type="hidden" name="shift" value='<?php shift();?>'>
<?php
//////////////////////////

vc_rt('noc');

/////////////////////////////////



?>
<div id="spDiv">Speedtest</div>
To: <input type='email' multiple required size=48 name="to" id="to" value="noc@evolvemediallc.com"><br>
<button type="button" onclick="loadXMLDoc()">Speedtest again</button>
<input type="submit" name="send_mail" value="Send Mail">
</form>
<br>
<h4>Also please take a look on the following Visual Check related ticket(s)</h4>
<?php 
vc_rt_lines('fwd'); 
  
#closing the main else
}

?>

</body>
</html>
