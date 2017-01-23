<?php
	include 'settings.php';
	db_connect();
	$output = '';
	$partner_id = $_GET['partner_id'];
		
	$sqlCheckMax  = "SELECT bit_rate_tiers.max_bit_rate AS bit_rate_tiers FROM bit_rate_tiers 
			LEFT JOIN partner_configuration ON partner_configuration.bitrate_tier_id = bit_rate_tiers.id
			WHERE partner_configuration.id = $partner_id";
	
	$resMax =  mysql_query($sqlCheckMax, $central_db);
	if($row = mysql_fetch_assoc($resMax)){
		$maxAllowed = $row['bit_rate_tiers'];
	}
	if(!isset($maxAllowed)) {
			$maxAllowed = 256;
	}else if($maxAllowed == 0) {
			$maxAllowed = 256;
	}
	
	$sql = 'SELECT * FROM bit_rate_tiers';
	$res = mysql_query($sql, $central_db);
	
	while($row = mysql_fetch_assoc($res)){
		if($row['max_bit_rate'] <= $maxAllowed) {
			$output .= '<option value="'.$row['id'].'">'.addslashes($row['max_bit_rate']).' kbps</option>';
		}
	}
	echo $output;
?>
