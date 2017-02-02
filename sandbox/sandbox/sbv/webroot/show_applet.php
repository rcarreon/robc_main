<?php 
	
	session_start();
	error_reporting(E_ALL ^ E_NOTICE);
	ini_set('display_errors', 1);
	
	include 'settings.php';
	
	$pid = $_GET['pid'];
	$sid = $_GET['sid'];
	$uid = $_GET['uid'];
	
	//echo $uid;
	//echo "Test";

	$appletParams = array();
		
	$appletParams['name'] = 						'JUpload';
	$appletParams['code'] = 						'wjhk.jupload2.JUploadApplet';
	$appletParams['httpUploadParameterType'] = 		'array';

	$appletParams['mayscript'] = 					'true';
	$appletParams['scriptable'] = 					'false';
	$appletParams['stringUploadSuccess'] = 			'SUCCESS';
	$appletParams['stringUploadError'] = 			'ERROR: (.*)';
	$appletParams['maxChunkSize'] = 				2000000;
	
	$appletParams['session_id'] = 					$sid;
	$appletParams['maxFileSize'] = 					'2G';
	$appletParams['maxFileSize'] = 					tobytes($appletParams['maxFileSize']);
	$appletParams['archive'] = 						'wjhk.jupload.jar';
	$appletParams['afterUploadURL'] = 				"javascript:alert('Thank you');";
	$appletParams['sendMD5Sum'] = 					'true';
	$appletParams['debugLevel'] = 					$UPLOAD_DEBUG_LEVEL;
	//$appletParams['debugLevel'] = 					0;
	$appletParams['showLogWindow'] = 				($appletParams['debugLevel'] > 1 && $appletParams['debugLevel'] < 100) ? 'true' : 'false';
	//$appletParams['showLogWindow'] = 				'false';
	$appletParams['width'] = 						($appletParams['debugLevel'] > 1 && $appletParams['debugLevel'] < 100) ? 770 : 770;
	//$appletParams['width'] = 						640;
	$appletParams['height'] = 						($appletParams['showLogWindow'] == 'true') ? 677 : 467;
	$appletParams['partner_id'] = 					$pid;
	$appletParams['user_id'] = 						$uid;
	//$appletParams['codebase'] = 					HTTP_ROOT_PATH;
	$appletParams['postURL'] =						curPageURL() ."handle_upload_applet.php";
	$appletParams['getURL'] = 						curPageURL() ."complete.php?";
	$appletParams['errorURL'] = 					curPageURL() ."handle_applet_error.php";
	
	$sqlChannels  = "SELECT * FROM channels ";
	$sqlChannels .= "WHERE site_id = '".$pid."' ORDER BY channel_name"; // WHERE parent_id = 0
	$arrChannels = mysql_query($sqlChannels) or die("can't execute query");
	
	$channels_array = "";
	$channel_ids_array = "";
	$default_channel_id = 0;
	/*foreach($arrChannels as $key => $value) {
		$channels_array .= $value['channel_name'] .",";
		$channel_ids_array .= $value['channels']['id'] .",";
	}*/
	while($row = mysql_fetch_assoc($arrChannels)) {
		$channels_array .= preg_replace("/,/", "###", $row['channel_name']) .",";
		$channel_ids_array .= $row['id'] .",";
		if($row['channel_name'] == "Default") {
			$default_channel_id = $row['id'];
		}
	}
	$channels_array = substr($channels_array, 0, -1);
	$channel_ids_array = substr($channel_ids_array, 0, -1);
	
	$appletParams['channels'] = 					$channels_array;
	$appletParams['channel_ids'] = 					$channel_ids_array;
	$appletParams['default_channel_id'] = 			$default_channel_id;
	
	$sqlBitRates = "SELECT * FROM bit_rate_tiers WHERE max_bit_rate!=0 AND max_bit_rate <= (SELECT max_bit_rate FROM bit_rate_tiers 
			LEFT JOIN partner_configuration ON partner_configuration.bitrate_tier_id = bit_rate_tiers.id
			WHERE partner_configuration.id = $pid)";
	$arrBitRates = mysql_query($sqlBitRates) or die("can't execute query");
	
	$bitrate_array = "";
	/*foreach($allowedBitrate as $key => $value) {
		$bitrate_array .= $value['bit_rate_tiers']['max_bit_rate'] .",";
	}*/
	while($row = mysql_fetch_assoc($arrBitRates)) {
		$bitrate_array .= $row['max_bit_rate'] .",";
	}
	$bitrate_array = substr($bitrate_array, 0, -1);
	if($bitrate_array == "") {
		$bitrate_array = "256";
	}
	$appletParams['bitrates'] = 					$bitrate_array;
	
	
	//get allowed file size for flv files
	$sqlFlvSize = "SELECT upload_tiers.max_file_size AS upload_file_size FROM upload_tiers LEFT JOIN partner_configuration ON 
			partner_configuration.upload_tier_id = upload_tiers.id WHERE partner_configuration.id = " .$pid;
	$arrFlvSize = mysql_query($sqlFlvSize) or die("can't execute query");
	$flv_max_file_size = "";
	$row = mysql_fetch_assoc($arrFlvSize);
	$flv_max_file_size = $row['upload_file_size'];
	$appletParams['flvMaxFileSize'] = tobytes($flv_max_file_size. "M");
	
	//get allowed file size for nonflv files
	$sqlNonFlvSize = "SELECT upload_tiers.max_file_size AS upload_file_size FROM upload_tiers LEFT JOIN partner_configuration ON 
			partner_configuration.upload_tier_id = upload_tiers.id WHERE partner_configuration.id = " .$pid;
	$arrNonFlvSize = mysql_query($sqlNonFlvSize) or die("can't execute query");
	$non_flv_max_file_size = "";
	$row = mysql_fetch_assoc($arrNonFlvSize);
	$non_flv_max_file_size = $row['upload_file_size'];
	$appletParams['nonFlvMaxFileSize'] = tobytes($non_flv_max_file_size. "M");
		
	$sqlthresholdSize = "SELECT threshold_tiers.file_size AS threshold_size FROM threshold_tiers LEFT JOIN partner_configuration ON 
			partner_configuration.treshold_id = threshold_tiers.id WHERE partner_configuration.id = " .$pid;
	$arrThresholdSize = mysql_query($sqlthresholdSize) or die("can't execute query");
	$row = mysql_fetch_assoc($arrThresholdSize);
	$threshold_size = $row['threshold_size'];
	$appletParams['treshold_value'] = $threshold_size * 1024 * 1024;
	
	$sqlPartner = "SELECT * FROM partner_configuration WHERE id = " .$pid;
	$arrPartner = mysql_query($sqlPartner) or die("can't execute query");
	$row = mysql_fetch_assoc($arrPartner);
	$appletParams['siteMapOn'] = $row['sitemap_verified'];
	if($appletParams['showLogWindow'] != 'true' && $appletParams['siteMapOn'] == '1') {
		$appletParams['height'] = 437;
	}
	?>
	
	<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
		<html xmlns="http://www.w3.org/1999/xhtml">
			<head></head>
		
			<body style="margin: 0; padding: 0;">
				<?php echo str_applet($appletParams);?>
			</body>
		</html>
	
	<?php 
	function str_applet($params) {
        $N = "\n";
        // return the actual applet tag
        $ret = '<object classid = "clsid:8AD9C840-044E-11D1-B3E9-00805F499D93" type = "application/x-java-applet;version=1.5" '.$N;
        $ret .= '  codebase = "http://java.sun.com/update/1.5.0/jinstall-1_5-windows-i586.cab#Version=5,0,0,3"'.$N;
        $ret .= '  width = "'.$params['width'].'"'.$N;
        $ret .= '  height = "'.$params['height'].'"'.$N;
        $ret .= '  name = "'.$params['name'].'">'.$N;
        foreach ($params as $key => $val) {
            if ($key != 'width' && $key != 'height')
                $ret .= '  <param name = "'.$key.'" value = "'.$val.'" />'.$N;
        }
        $ret .= '  <comment>'.$N;
        $ret .= '    <embed'.$N;
        $ret .= '      type = "application/x-java-applet;version=1.5"'.$N;
        foreach ($params as $key => $val)
            $ret .= '      '.$key.' = "'.$val.'"'.$N;
        $ret .= '      pluginspage = "http://java.sun.com/products/plugin/index.html#download">'.$N;
        $ret .= '      <noembed>'.$N;
        $ret .= '        Java 1.5 or higher plugin required.'.$N;
        $ret .= '      </noembed>'.$N;
        $ret .= '    </embed>'.$N;
        $ret .= '  </comment>'.$N;
        $ret .= '</object>';
        return $ret;
    }
	
	function tobytes($val) {
        $val = trim($val);
        $last = strtolower($val{strlen($val)-1});
        switch($last) {
	        case 'g':
	            $val *= 1024;
	        case 'm':
	            $val *= 1024;
	        case 'k':
	            $val *= 1024;
        }
        return $val;
    }
    
    function curPageURL() {
		$pageURL = 'http';
		if ($_SERVER["HTTPS"] == "on") {$pageURL .= "s";}
			$pageURL .= "://";
		if ($_SERVER["SERVER_PORT"] != "80") {
			$pageURL .= $_SERVER["SERVER_NAME"].":".$_SERVER["SERVER_PORT"].$_SERVER["REQUEST_URI"];
		} else {
			$pageURL .= $_SERVER["SERVER_NAME"].$_SERVER["REQUEST_URI"];
		}
		$slash_pos = strrpos($pageURL, '/', -1);
		$pageURL = substr($pageURL, 0, $slash_pos+1);
		
		return $pageURL;
	}

?>