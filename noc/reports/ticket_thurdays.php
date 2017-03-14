<!-- SWAG -->
<head>
         <link type=text/css rel=stylesheet href=../css/demo_page.css />
        </head>
        <body id=dt_example>
        <div id=container>
        <img src=../images/banner.jpg>

<?php

//This will be shown after clicking the send email button for any ticket
if (isset($_POST["butt"])) {

?>

<form action="ticket_thurdays.php" method="post">
<b>Status change Review/Reminder</b><br><br>
<b>To: </b><input type="text" name="emails" size="80" value="Alex.Godelman@evolvemediallc.com"></input><br>
<b>Cc: </b><input type="text" name="cmails" size="80" value="ali.argyle@evolvemediallc.com, noc-leads@evolvemediallc.com"></input><br><br>
<b>Name:</b> <input type="text" name="name" value="<?php echo str_replace("<br />", "", $_POST["name"]); ?>"></input><br>
<b>Date of Separation:</b> <input type="text" name="depd" value="<?php echo str_replace("<br />", "", $_POST["depd"]); ?>"></input><br>
<br><b>The Sections without response:</b><br>
<?php echo nl2br($_POST["sect"]); ?><br><br>
<input type="hidden" name="sect" value="<?php echo nl2br($_POST["sect"]); ?>"></input>
<input type="submit" name="bu2n" value="Send Email">
</form>

<?php

//Mail preview will be shown, for a quick review before sending the email
} elseif (isset($_POST["bu2n"])) {
        $to = $_POST["emails"];
        $headers = 'MIME-Version: 1.0' . "\r\n";
        $headers .= 'Content-type: text/html; charset=iso-8859-1' . "\r\n";
        $headers .= 'From: NOC Leads <noc-leads@evolvemediallc.com>' . "\r\n";
        $headers .= 'CC: '.$_POST["cmails"] . "\r\n"; 
        $subject = "Status Change Review [".$_POST["name"]."] [".$_POST["depd"]."]";
        $body = "<b>Status Change Review/Reminder<br><br>";
        $body .= "Name: </b>".$_POST["name"]."<br>";
        $body .= "<b>Date of Review: </b>".date("m/d/y")."<br>";
        $body .= "<b>Date of Departure: </b>".$_POST["depd"]."<br><br>";
        $body .= "<b>The Sections without response:</b><br>";
        $body .= $_POST["sect"];
        
mail($to,$subject,$body,$headers);

        echo "Email Sent!<br>";
        echo "<br><b>To:</b> ".$to."<br>";
        echo "<b>CC:</b> ".$_POST["cmails"];

//This will display the current open, unresolved or stalled tickets with sections without response
} else {

//This variable recieves a plain text info from a script running an rt query
$tickets = `./thur.sh`;

$flag = "\r\n";
$line = strtok(nl2br($tickets), $flag);
$sect = "";

//Parse info on $tickets
while ($line !== false) {
        if (strpos($line,'Ticket') !== false) {
                if ($sect !== "") {
                        echo "<form target='_blank' action='ticket_thurdays.php' method='post'>";
                        echo "<input type='hidden' name='name' value='".$name."'></input>";
                        echo "<input type='hidden' name='depd' value='".$depd."'></input>";
                        echo "<input type='hidden' name='sect' value='".$sect."'></input>";
			if (strpos($stat,'Overdue') !== false) {
	                        echo "<input type='submit' name='butt' value='Send Email'>";
			}
                        echo "</form>";
                } else { echo "This ticket should be closed<br><br>"; }
                $tick = str_replace("Ticket: ", "", $line);
                $sect = "";
        } elseif (strpos($line,'Name') !== false) {
                $name = str_replace("Name:", "", $line);
        } elseif (strpos($line,'Date') !== false) {
                $depd = str_replace("Date:", "", $line);
	} elseif (strpos($line,'Status') !== false) {
                $stat = "<b>".str_replace("Status:", "", $line);
		if (strpos($stat,'OK') == true) { $stat = "<font color='green'>".$stat."</font></b><br>"; }
		else { $stat = "<font color='red'>".$stat."</font></b>"; }
                echo "<b>Ticket: </b><a href='https://rt.gorillanation.com/Ticket/Display.html?id=".str_replace("<br />", "", $tick)."'>".$tick."</a>";
                echo "<b>Name: </b>".$name;
                echo "<b>Date: </b>".$depd;
		echo "<b>Status: </b>".$stat;
        } else {
                $sect .= $line;
        }
        $line = strtok($flag);
}
        if ($sect !== "") {
                        echo "<form target='_blank' action='ticket_thurdays.php' method='post'>";
                        echo "<input type='hidden' name='name' value='".$name."'></input>";
                        echo "<input type='hidden' name='depd' value='".$depd."'></input>";
                        echo "<input type='hidden' name='sect' value='".$sect."'></input>";
			if (strpos($stat,'Overdue') !== false) {
                        	echo "<input type='submit' name='butt' value='Send Email'>";
			}
                        echo "</form>";

        } else { echo "This ticket should be closed!<br><br>"; }

}

?>

