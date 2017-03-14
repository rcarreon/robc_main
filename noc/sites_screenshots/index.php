<!DOCTYPE html>
<?php
include("include/functions.php");
date_default_timezone_set("America/Los_Angeles");
?>

<html>
	<head>
		<title>Site Screenshots</title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
		<meta http-equiv="X-UA-Compatible" content="chrome=1" />
		<meta name="viewport" content="width=device-width, initial-scale=1.0" />
		<link rel="stylesheet" href="../css/bootstrap.min.css">
	  <!-- Optional theme -->
	  	<link rel="stylesheet" href="../css/bootstrap-theme.min.css">
	  	<link rel="stylesheet" href="../js/jquery-ui-1.10.3.custom/css/jquery-ui-1.10.3.custom.min.css">
		<style type="text/css">
			body{
				font-size: 14px;
				font-family: Arial;
			}
			.img_container{
				float: left;
				border: 1px solid #eaeaea;
				padding: 15px;
				margin-right: 5px;
				margin-bottom: 5px;
				text-align: center;
				width: 175px;
				height: 350px;
				white-space: pre-wrap;      /* CSS3 */
				white-space: -moz-pre-wrap; /* Firefox */
				white-space: -pre-wrap;     /* Opera <7 */
				white-space: -o-pre-wrap;   /* Opera 7 */
				word-wrap: break-word;      /* IE */
			}
			.img_container img{
				max-width: 150px;
			}
			.img_container:hover{
				background: #eaeaea;
				border-color: #c0c0c0;
			}
			p{
				text-align: left;
			}
			#lightbox{
				background-color:#eee;
				padding: 10px;
				border-bottom: 2px solid #666;
				border-right: 2px solid #666;
			}
			#lightboxDetails{
				font-size: 0.8em;
				padding-top: 0.4em;
			}
			#lightboxCaption{ float: left; }
			#keyboardMsg{ float: right; }
			#closeButton{ top: 5px; right: 5px; }

			#lightbox img{ border: none; clear: both;}
			#overlay img{ border: none; }

			#overlay{ background-image: url(img/overlay.png); }

		</style>
		<script type="text/javascript" src="lightbox.js"></script>
	</head>
	<body>
		<div class="container">
			<?php require_once '../navbar.php'; ?>
		</div>
    <div class="container"><br><br>
		<h2>Site Screenshots</h2>
<?php
$server = "http://$_SERVER[HTTP_HOST]";
$actual_link = "http://$_SERVER[HTTP_HOST]$_SERVER[REQUEST_URI]";
//echo $server."<br>";
//echo $actual_link."<br>";

$current_dir = getcwd();
chdir('screenshots');
$sites_screenshots = glob("*.jpg");
chdir($current_dir);
//print_r($sites_screenshots);

// get the ID, Name, and CF.{NotificationGroups} from Inventory
// in an array form
$inventorySites = queryInventory("s");
//print_r($inventorySites);
/*
$inventorySites = queryInventory("l");
foreach ($inventorySites as $row){
  foreach ($row as $field){
    if (is_array($field)){
      foreach($field as $email){
        echo $email." ";
      }
    }
    else{
      echo $field." ";
    }
  }
  echo "<br>";
}
*/
foreach ($sites_screenshots as $screenshot){
  ?> 
  <div class="img_container"><div><a rel="lightbox" href="<?php echo $server . "/sites_screenshots/screenshots/" . $screenshot?>"><img src="screenshots/thumbs/thumb-<?php echo $screenshot; ?>" height="150"></a></div>
  <?php
  list($id, $size, $mmddyy, $description) = explode("-", $screenshot);
  //echo $id."<br>".$size."<br>".$mmddyy."<br>".$description."<br>";
  $site = $inventorySites[$id];
  $month = substr($mmddyy, 0, 2); 
  $day = substr($mmddyy, 2, 2);
  $year = substr($mmddyy, 4, 2);
  $lastupdate = mktime(0, 0, 0, $month, $day, $year);
  $lastupdate = date('l F jS\, Y', $lastupdate);
  //$lastupdate = date('l jS \of F Y', $lastupdate);
  //echo $site." Month: ".$month." Day: ".$day." Year: ".$year."<br>".$lastupdate;

  // with this simple comparision, if an ID doesn't exist, and then $site doesn't contain anything (null)
  // we will print the name of the file becuse the ID do not returned a valid site name (or errors exist)
  if ($site ==null){ ?>
    <p><?php echo $screenshot; ?></p></div> <?php
  }
  else { ?>
    <p><?php echo $site; ?></p><p><?php echo "Last Update: ".$lastupdate; ?></p></div><?php
  }
}

?>
		</div>
		<hr>
		<div id="footer">
			<div class="container span12">
				<p class="text-muted credit">NOC Tools <?php echo date('Y'); ?></p>
			</div>
		</div>
	</body>
<script src="../js/jquery-1.10.2.min.js"></script>
<script src="../js/jquery-ui-1.10.3.custom/js/jquery-ui-1.10.3.custom.min.js"></script>
<script src="../js/bootstrap.min.js"></script>
<script src="../js/jquery.tablesorter.js"></script>
</html>
