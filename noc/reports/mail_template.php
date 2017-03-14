<head>
         <link type=text/css rel=stylesheet href=../css/demo_page.css />
        </head>
        <body id=dt_example>
        <div id=container>
        <img src=../images/banner.jpg>

<?php

if(isset($_POST["butt"])) {

$name = $_POST["name"];
$date = $_POST["date"];
$message = $_POST["message"]; 
$subject = "Status Change Reminder - [".$name."] [".$date."]";
$emails = $_POST["emails"];

//$to = "rodolfo.angel@evolvemediallc.com";
$to = $emails;


$MESSAGE_BODY = "<b>Status change Review/Reminder</b><br><br>"; 
$MESSAGE_BODY .= "<b>Name:</b> ".$name."<br>"; 
$MESSAGE_BODY .= "<b>Date of Review: </b> ".date("m/d/y")."<br>"; 
$MESSAGE_BODY .= "<b>Date of Separation: </b> ".$date."<br><br>"; 
$MESSAGE_BODY .= $message; 
$headers = 'MIME-Version: 1.0' . "\r\n";
$headers .= 'Content-type: text/html; charset=iso-8859-1' . "\r\n";
$headers .= 'From: NOC Leads <noc-leads@evolvemediallc.com>' . "\r\n";
if (isset($_POST["cmails"])) { $headers .= 'CC: '.$_POST["cmails"] . "\r\n"; }

mail($to,$subject,$MESSAGE_BODY,$headers);

echo "Email Sent!<br>";
echo "<b>To</b>: ".$to."<br>";
echo "CC:</b>".$_POST["cmails"];

} else {

$name = $_GET["first"]." ".$_GET["last"];
$date = $_GET["date"];
$section = $_GET["sec"];
$emails = $_GET["emails"];

$message = "
 <b>The Sections without response:</b>
<u>".$section." (".$emails.")</u> <br>
 According to our record, the following tasks haven&#39t been completed or acknowledged. <br>
 If the task doesn't apply to your department, reply the original mail with the task following the N/A status. <br>
 <b> Please complete them as soon as feasible and acknowledge their completion by replying to the original status change email as soon as possible.</b><br>
 If you are receiving this in error, please contact Alex Godelman at your earliest convenience. <br>
 Thank you in advance for making this a priority.";

?>

<form action="mail_template.php" method="post">
<b>Status change Review/Reminder</b><br><br>
<b>To: </b><input type="text" name="emails" size="80" value="<?php echo $emails; ?>"></input><br>
<b>CC: </b><input type="text" name="cmails" size="80" value="Alex.Godelman@evolvemediallc.com, ali.argyle@evolvemediallc.com, noc-leads@evolvemediallc.com"></input><br><br>
<strong>Name:</strong> <input type="text" name="name" value="<?php echo $name; ?>"></input><br>
<strong>Date of Separation: </strong><input type="text" name="date" value="<?php echo $date; ?>"></input><br>
<?php echo nl2br($message); ?><br><br>
<input type="hidden" name="message" value="<?php echo nl2br($message); ?>"></input>
<!--<input type="hidden" name="emails" value="<?php //echo $emails; ?>"></input>-->
<input type="submit" name="butt" value="Send Email">
</form>

<?php
}
?>
