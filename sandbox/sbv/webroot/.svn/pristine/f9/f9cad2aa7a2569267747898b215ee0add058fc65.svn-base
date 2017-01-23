<?php
	include 'settings.php';
	db_connect();
		
	$sql = 'SELECT * 
			FROM partner_configuration
			WHERE id = "'.mysql_real_escape_string(trim($_GET['partner_id'])).'"';
	$row = mysql_fetch_assoc(mysql_query($sql, $central_db));
	
	/* Create partner connection */
	$partner_db = mysql_connect($row['db_host'], $row['db_username'], $row['db_password']) or die('Connect error.');
	mysql_select_db($row['db_name'], $partner_db) or die('Connect error.');
		
	$sql = 'SELECT *
			FROM channels
			ORDER BY channel_name';
	$res = mysql_query($sql);
	$output = '';
	while($row = mysql_fetch_assoc($res)){
		$output .= '<option value="'.$row['id'].'">'.addslashes($row['channel_name']).'</option>';
	}
	echo $output;
?>
