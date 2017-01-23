<?php
	include 'settings.php';
	db_connect();
		
	// $sql = 'SELECT * 
			// FROM channels
			// WHERE site_id = "'.mysql_real_escape_string(trim($_GET['partner_id'])).'"';
	// $row = mysql_fetch_assoc(mysql_query($sql, $central_db));
	
	// print_r($row);exit;
	$sql = 'SELECT * 
			FROM channels
			WHERE site_id = "'.mysql_real_escape_string(trim($_GET['partner_id'])).'"';
	$res = mysql_query($sql, $central_db);
	$output = '';
	while($row = mysql_fetch_assoc($res)){
		$output .= '<option value="'.$row['id'].'">'.stripslashes($row['channel_name']).'</option>';
	}
	echo $output;
?>
