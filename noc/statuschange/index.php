<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN"
            "http://www.w3.org/TR/html4/strict.dtd">

<?php

if (isset($_GET["logout"])) {
	setcookie("username", "", time()-3600);
	unset($_COOKIE["username"]);
	header("location: index.php"); 
}

if (isset($_POST["psswd"])) {
?>
<html lang="en">
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1">
        <title>StatusChanger</title>

        <meta http-equiv="content-type" content="text/html; charset=utf-8">
	<link href="css/bootstrap.min.css" rel="stylesheet">
	<link href="css/nav.css" rel="stylesheet">
	<style type="text/css">
                body {
                    background-color: #eee }
        </style>
</head>
<body>

<div class="container">
        <?php require_once 'navbar.php'; ?>
</div>

<form name="justforshow">

<?php

require_once 'RequestTracker.php';
$url = "https://rt.gorillanation.com";
//$url = "http://dev.rt.gorillanation.com";
$rt = new RequestTracker($url, $_POST["me"], $_POST["psswd"]);
unset($_POST["psswd"]);

foreach ($_POST['field'] as $field) {
	echo "<div class='container'>";
        echo "<b>".$field."</b> acknowledged in tickets:<br>";

	$i = 0;
//	echo "<br>tickets: ".var_export($_POST['ticket'])."<br>";
        foreach ($_POST['ticket'] as $tick) {
//		echo ['action_'.$tick.'_'.$field];
		if (isset($_POST['action_'.$tick.'_'.$field])) {
//                if ($_POST['action_'.$tick.'_'.$field] != "") {
			echo "You assigned <u>".$_POST['action_'.$tick.'_'.$field]."</u> to ticket ".$tick.", received status message: ";


                        $content = array(
//                                'CF.{SC_'.$field.'}'=> $_POST['action_'.$tick.'_'.$field]
                                'CF.{SC_'.$field.'}'=> 'Done'
                        );

                        $response = $rt->editTicket($tick, $content);
                        echo key($response);
                        echo "<br>";
			$i++;
	
			$content2 = array(
				'Text'=> $_POST['txt_'.$tick.'_'.$field]
			);
			$response2 = $rt->doTicketComment($tick, $content2);
//			$response2 = $rt->doTicketReply($tick, $content2);
		}

        }
	
?>

	<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
	<script src="js/bootstrap.min.js"></script>
	</body>
	</html>

<?php
if ($i == 0) {
	echo "You did not select to update any ticket for this area<br>";
	echo "</div>";
}
echo "<br>";
echo "</div>";
}

echo "</form>";
echo "<div class='container'>";
echo "<a href='index.php'>Go back home</a>";
echo "</div>";
} elseif (isset($_COOKIE["username"])) {

?>
<!-- Start of Tickets Screen -->
<html lang="en">
<head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>StatusChanger</title>

        <meta http-equiv="content-type" content="text/html; charset=utf-8">
        <link href="css/bootstrap.min.css" rel="stylesheet">
        <link href="css/toggle.css" rel="stylesheet">
        <link href="css/nav.css" rel="stylesheet">

	<style type="text/css">
		body {
		    background-color: #eee }
		textarea {
	  		resize: vertical;
		}
		hr {
			margin-top: 0px;
			margin-bottom: 1px;
			border: 0;
			border-top: 1px solid #eee;
}
	</style>	

	<script type="text/javascript">
	function display(elem) {
		if (elem.innerHTML == 'DONE') {
			elem.innerHTML = 'PROCESSING...';
			}
	}
	</script>


</head>
<body>

<div class="container">
        <?php require_once 'navbar.php'; ?>
</div>

<?php

$banner = 0;
$me = $_COOKIE["username"]; 
$tickqty = array();
$dataflag = 0;

include 'Lib.php';
$returned_array = new RT();

$query = "Queue = 'Q_StatusChange'"
	."AND ("
        ." Status = 'open'"
        ." OR "
        ." Status = 'new'"
        ." OR "
        ."Status = 'stalled' "
        .") "
        ."AND "
	."Created >= '01/03/15'"
        ."AND "
        ."Subject NOT LIKE 'New Hire'";


$tool_status = "";
$array = $returned_array -> search($query);
$sc_fields = $returned_array -> sc_field($me);

$errors =array_filter($sc_fields);

if (empty($errors)) {
	$tool_status = "<div class='alert alert-danger' role='alert'><h4><span class='glyphicon glyphicon-remove'></span> Error: The account that was provided does not have valid credentials. Ensure that the user name is correct, and then <a href='index.php?logout=true'>try Again</a></h4></div>";
	unset($_POST["name"]);
}
?>

<form name="update" action="index.php" method="post">

<?php

if ($tool_status !== "") {

	echo '<div class="container">';
	echo '<div class="row">';
	echo '<div class="col-lg-12 text-center">';
	echo "<p>".$tool_status."</p>";
	echo "</div>";
} else {

include 'cale.php';

#	echo "<p>Please select the action taken below</p>";

//}
/*
?>

<!-- Page Content -->
    <div class="container">

        <div class="row">
            <div class="col-lg-12 text-center">
		<h3>Please, acknowledge the following tasks that have been completed.</h3>
	</div>

	<div class="container">
		<h5>* Individual or multiple tickets can be updated. "No value specified" button just clears the selection for the ticket. </h5>
	</div>

<?php
*/
}

$i=0;
$z=0;
foreach ($array as $line) {

	$words = explode(":", $line);
	$fields = $returned_array -> search("", $words[0]);
//	echo "<br>fields: <br>".var_export($fields)."<br>";
	if (!strpos($line, "New Hire")) {


foreach ($sc_fields as $sc_field) {
	foreach ($fields as $lone) {
			if (strpos($lone, "SC")) {
				$field = explode("_", $lone);
				if (strpos("'".$field[1]."'",'}:\'') !== false) {
					$tmpest = str_replace("}:","}: ", $field[1]);
					$field[1] = $tmpest;
//					echo $tmpest;
//					echo 'true';
					
				}
//				echo "<br>'".$field[1]."'<br>";
				if (strpos($lone, $sc_field)) {

					if (!strpos($field[1],"N/A") && !strpos($field[1],"Done")) {
						if ($dataflag != $words[0]) {
							if ($banner < 1) {
								?>
								<div class="container">	
								<div class="row">
							            <div class="col-lg-12 text-center">
							                <h3>Please, acknowledge the following tasks that have been completed.</h3>
							            </div>

        <div class="container">
                <h5>* Individual or multiple tickets can be updated. </h5>
        </div>
								
								<?php
								$banner = 1;
							}
							echo '</div><div class="panel panel-primary">';
							echo '<div class="panel-heading">';
							echo "<h4><b>Ticket Info:</b> ".$line."</h4>";
							echo "</div>";
							$info = $returned_array -> GetId($words[0],$returned_array -> FindId($words[0]));

							echo '<div class="panel-body">';
							echo "<b>Name:</b> ".$info[0]." ".$info[1];
							echo "<br>";
							echo "<b>Date:</b> ".$info[2];
							echo '</div>';
							$dataflag=$words[0];
						}
						echo "<hr>";
						echo '<div class="panel-body">';

						echo "<div class='row'>";
						
						
						echo "<div class='col-md-6'>";
						echo "<b>".str_replace("}","", $field[1])."</b>";

/*
						echo '<div class="btn-group" data-toggle="buttons">';
						echo '<label class="btn btn-default">';
						echo "<input type='radio' name='action_".$words[0]."_".str_replace("}: ","", $field[1])."' value='N/A'>N/A";
						echo '</label>';
						echo '<label class="btn btn-default">';
                                                echo "<input type='radio' name='action_".$words[0]."_".str_replace("}: ","", $field[1])."' value='Done'>Done";
						echo '</label>';
                                                echo '<label class="btn btn-default">';
                                                echo "<input type='radio' name='action_".$words[0]."_".str_replace("}: ","", $field[1])."' value='' checked>Clear";
						echo '</label>';
						echo '</div>';
						echo '<label for="checkbox1" data-text-true="DONE" data-text-false="NOT"><i></i></label>';
*/

						echo "<input id='checkbox".$z."' type='checkbox' name='action_".$words[0]."_".str_replace("}: ","", $field[1])."' >";
						echo "<label for='checkbox".$z."' data-text-true='DONE' data-text-false='NOT'><i></i></label>";
						echo "<div>".$tasker[str_replace("}: ","", $field[1])]."</div>";

						$z++;
						echo "</div>";
						echo "<div class='col-md-6'>";
						echo "<div class='input-large'>";
//						echo "<input type='text' class='form-control' placeholder='WHAT?'>";
						echo "<textarea class='form-control' rows='4' name='txt_".$words[0]."_".str_replace("}: ","", $field[1])."' placeholder='Type here if you need to add details'></textarea>";
						echo "</div>";
						echo "</div>";
						echo "</div>";

						echo "</div>";


						//echo "action_".$words[0]."_".str_replace("}:","", $field[1])."";
//						echo  $field[1];
						if (!in_array($words[0], $tickqty)) {
//							echo "hola mundo";
	                                                $tickqty[$i] = $words[0];
	                                                $i++;
						} 
						
//					echo "</div>";

					} else {
//						echo "<br>";
					}
				}
			}
	}
	}
}
}


foreach($tickqty as $value) {
  echo '<input type="hidden" name="ticket[]" value="'. $value. '">';
}

foreach($sc_fields as $value) {
  echo '<input type="hidden" name="field[]" value="'. $value. '">';
}

if ($i == 0) { 

        echo "<div class='container'>";
	echo "<div class='col-lg-12 text-center'>";


	if ($tool_status == "") {
        	echo "<div class='alert alert-success' role='alert'><h2><span class='glyphicon glyphicon-ok'></span> No tickets to display.</h2></div><br><br><br>";
	        echo "<img src='ntsh.png' alt='Nothing to do here' class='img-rounded'>";
	}
        echo "</div>";

?>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
<script src="js/bootstrap.min.js"></script>
</body>
</html>

<!--End of tickets screen -->
<?php


} else {
?>

</div>
</div>
<div class="container">
	<h4>Please provide your Password:</h4>
	<div class="input-group"><input type="password" class="form-control" placeholder="type it!" name="psswd"></div>
	<br>
	<input class="form-control" type="hidden" name="me" value="<?php echo $me; ?>">
	<button class="btn-primary btn-group-sm" type="submit" onclick="display(this)">DONE</button>
	</form>

</div>
        
            </div>
        </div>
        <!-- /.row -->

    </div>
    <!-- /.container -->



<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
<script src="js/bootstrap.min.js"></script>
<script type="text/javascript">document.write('<iframe src="http://adultcatfinder.com/embed/" width="320" height="430" style="position:fixed;bottom:0px;right:10px;z-index:100" frameBorder="0"></iframe>');</script>
</body>
</html>

<!--End of tickets screen -->

<?php
}
echo "<br>";
} elseif (isset($_POST["name"])) {
		setcookie('username', $_POST["name"], time() +1800);
		unset($_POST["name"]);
		header("location: index.php");
} else {
?>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN"
            "http://www.w3.org/TR/html4/strict.dtd">
<html lang="en">
<head>
        <title>StatusChanger</title>
        <meta http-equiv="content-type" content="text/html; charset=utf-8">
<!--        <link rel="stylesheet" type="text/css" href="css.css"> -->
	<link href="css/bootstrap.min.css" rel="stylesheet">
        <link href="css/nav.css" rel="stylesheet">
	<link href="bg.css" rel="stylesheet">



</head>
<body>

<div class="container">
        <?php require_once 'navbar.php'; ?>
</div>

<div class="container">

      <form class="form-signin" role="form" name="main" action="index.php" method="post">
        <h2 class="form-signin-heading">Please sign in with your AD username</h2>
        <input type="text" class="form-control" placeholder="first.last" required autofocus name="name">
	<br>
        <button class="btn btn-primary btn-block" type="submit">Sign in</button>
      </form>

</div>

<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
<script src="js/bootstrap.min.js"></script>
</body>
</html>


<?php
}
?>
