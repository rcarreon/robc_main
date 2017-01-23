<?php
	
	/**
	 * Complete upload
	 * Send video details and file path
	 * Copy file and store data into database
	 */
	include 'settings.php';
	include 'class/class_tags.php';
	db_connect();
	
	// configuration
	define('TIME_ZONE_OFFSET', 8);
	$intVideoFilePermissions = 0777;
	$strIncomingDir = 'incoming';
	$strConversionDir = "conversion";
	$flagSaveLog = true;
	$strLogDir = $LOG_DIR;
	
	$strFilesArray = print_r($_FILES, true);
	$strPostArray = print_r($_POST, true);
	$strGetArray = print_r($_GET, true);
	
	// start the log message
	$strMessage  = "LOG ENTRY: ".$_SERVER['SERVER_NAME']."\n";
	$strMessage .= "Time: ".date("Y-m-d", strtotime(TIME_ZONE_OFFSET ." hours"))." ";
	$strMessage .= "at ".date("H:i:s", strtotime(TIME_ZONE_OFFSET ." hours"))."\n";
	$strMessage .= "Remote IP: ".$_SERVER['REMOTE_ADDR']."\n";
	$strMessage .= "Remote Port: ".$_SERVER['REMOTE_PORT']."\n";
	$strMessage .= "Remote User Agent: ".$_SERVER['HTTP_USER_AGENT']."\n";
	$strMessage .= "Referrer URI: ".$_SERVER['HTTP_REFERER']."\n";
	$strMessage .= "Request URI: ".$_SERVER['REQUEST_URI']."\n";
	$strMessage .= "FILES Array: ".$strFilesArray."\n";
	$strMessage .= "POST Array: ".$strPostArray."\n";
	$strMessage .= "GET Array: ".$strGetArray."\n";
	$strMessage .= "SCRIPT ACTIVITY LOG: "."\n\n";
	
	if(isset($_GET['file_size']) && isset($_GET['partner_id']) && isset($_GET['title']) && isset($_GET['blurb']) && isset($_GET['tags']) && isset($_GET['channel']) && isset($_GET['adult']) && isset($_GET['fid']) && isset($_GET['sid']) && isset($_GET['file']) && isset($_GET['uid'])){
		
		/* Filter input */
		$uid = mysql_escape_string(trim($_GET['uid']));
		$file_size = mysql_escape_string(trim($_GET['file_size']));
		$partner_id = mysql_escape_string(trim($_GET['partner_id'])); // partner sajt 
		$sid = mysql_escape_string(trim($_GET['sid'])); // upload session id
		$fid = mysql_escape_string(trim($_GET['fid'])); // file id, redni broj fajla u sesiji
		$file = mysql_escape_string(trim($_GET['file'])); //ime fajla
		$title = mysql_escape_string(trim($_GET['title'])); // naslov
		$blurb = mysql_escape_string(trim($_GET['blurb']));
		$tags = mysql_escape_string(trim($_GET['tags']));
		$channel = mysql_escape_string(trim($_GET['channel'])); // channel_id
		$adult = mysql_escape_string(trim($_GET['adult'])); //flag
		$upload_mode = mysql_escape_string(trim($_GET['upload_mode'])); //flag
		
		/* Create central_db connection */
		$sql = 'SELECT * 
				FROM partner_configuration
				WHERE id = "'.$partner_id.'"';
		$row = mysql_fetch_assoc(mysql_query($sql, $central_db));
		
		if(!$row){
		       $strMessage .= "Failed to connect to central network database."."\n";
		}
	
		$strSiteDomain = '';
		if(isset($row['domain'])) $strSiteDomain = $row['domain'];
			
		/* Create partner connection */
		$partner_db = mysql_connect($row['db_host'], $row['db_username'], $row['db_password']) or die('Connect error');
		mysql_select_db($row['db_name'], $partner_db) or die('Connect error');
		
		
		$strServerName = $_SERVER['SERVER_NAME'];
		$strMessage .= "Current server name: ".$strServerName."\n";
		
		// start managing the uploaded file
		$strMessage .= "Original File Name: ".$file."\n";
		
		$strURL = '/'.$strIncomingDir."/".$file;
		$strMessage .= "Starting URL: ".$strURL."\n";
		
		if(!isset($row['flag_private'])) $row['flag_private'] = 0;
		if(!isset($row['flag_video_auto_accept'])) $row['flag_video_auto_accept'] = 0;
		
		// check is video uploaded by user or site 		
		$intFlagPrivate = 0; 
		$intFlagPrivate = $row['flag_private'];
		
		$strFlagVideoAutoAccept = 0;
		$strFlagVideoAutoAccept = $row['flag_video_auto_accept'];
		
		
	
		$intFlagUser = 1;
		$intFlagAccepted = 0;
		$intFlagActive = 0;
		
		if($upload_mode == 'user') {
			$intFlagUser = 1;
			if($strFlagVideoAutoAccept == 1) {
				$intFlagAccepted = 1;
				$intFlagActive = 1;
			} else {
				$intFlagAccepted = 0;
				$intFlagActive = 0;
			}
		} else if($upload_mode == 'site') {
					$intFlagUser = 0;
					$intFlagAccepted = 1;
					$intFlagActive = 1;
		}

		/* Save data into video table */
		$strVideoInsert  = "INSERT INTO videos ";
		$strVideoInsert .= "SET url = '".$strURL."', ";
		$strVideoInsert .= "user_id = '".$uid."', ";
		$strVideoInsert .= "created = NOW(), ";
		$strVideoInsert .= "title = '".$title."', ";
		$strVideoInsert .= "original_filename = '".$file."', ";
		$strVideoInsert .= "blurb= '".$blurb."', ";
		$strVideoInsert .= "flvw = '0', ";
		$strVideoInsert .= "flvh = '0', ";
		$strVideoInsert .= "video_type_id = '7', ";
		$strVideoInsert .= "status = 'pre_uploaded', ";
		$strVideoInsert .= "flag_user = '".$intFlagUser."', ";
		$strVideoInsert .= "flag_private = '".$intFlagPrivate."', ";
		$strVideoInsert .= "flag_accepted = '".$intFlagAccepted."', ";
		$strVideoInsert .= "flag_active = '".$intFlagActive."', ";
		$strVideoInsert .= "flag_adult = '".$adult."'";
		$strMessage .= "Insert Video SQL: "."\n";
		$strMessage .= $strVideoInsert."\n";

		$resultVideoInsert = mysql_query($strVideoInsert, $partner_db);
		$intInsertVideoID = mysql_insert_id($partner_db);
		
		if($resultVideoInsert){
			$strMessage .= "SQL query executed successfully."."\n";
		}else{
			$strMessage .= "Failed to execute SQL query."."\n";
		}
		
		/* Save data into vote table */
		$sqlVote = "INSERT INTO vote SET type = 'video', id = '".$intInsertVideoID."'";

		$strMessage .= "Insert Vote SQL: "."\n";
		$strMessage .= $sqlVote."\n";
		
		$rsVote = mysql_query($sqlVote, $partner_db);
		if($rsVote){
			   $strMessage .= "Insert Vote SQL query executed successfully."."\n";
		}else{
			   $strMessage .= "Failed to execute Insert Vote SQL query."."\n";
		}
		
		$intVoteID = mysql_insert_id($partner_db);
		
		
		$strExtension = end(explode(".", $file));
		//$strExtension = strtolower($arrExtension[sizeof($arrExtension)-1]);
		
		//copy to converted
		$strNewFileName = $intInsertVideoID.".".$strExtension;
		$strDestinationPath = $strFileStorageDir.'/'.$strSiteDomain.'/'.$strIncomingDir."/".$strNewFileName;
		$strNewURL = '/'.$strIncomingDir.'/'.$strNewFileName;
		$strNewStatus = 'uploaded';      
	   
		$strMessage .= "New file name: ".$strNewFileName."\n";
		$strMessage .= "Destination Path: ".$strDestinationPath."\n";
		$strMessage .= "New URL: ".$strNewURL."\n";
		$strMessage .= "New status: ".$strNewStatus."\n";
		
		
		$tmp_file_path = $UPLOAD_DIR.$sid.'.'.$fid.'.final';
		$strMessage .= "Try to copy: ".$tmp_file_path." to ".$strDestinationPath."\n";

		@exec('cp '.$tmp_file_path.' '.$strDestinationPath);
		// if(!@copy($tmp_file_path, $strDestinationPath)){
			// header('X-COMPLETE: ERROR');
			// echo "File is uploaded but cannot be copied!<br>\n";
			// echo "Please, check the file system structure<br>\n";
		// }
		//print('cp '.$tmp_file_path.' '.$strDestinationPath);
		if(file_exists($strDestinationPath)) {
			   $boolUploadSuccess = true;
			   chmod($strDestinationPath, $intVideoFilePermissions);
			   //@unlink($UPLOAD_DIR.$sid.'.'.$fid.'.*');
			   @exec('rm -rf '.$tmp_file_path);
			   @exec('rm -rf '.$UPLOAD_DIR.$sid.'.'.$fid.'*');
			   #fclose(fopen($tmp_file_path.'.copied'., 'w'));
			   $strMessage .= "Removed temp files for: ".$UPLOAD_DIR.$sid.'.'.$fid."\n";
		} else {
			   $boolUploadSuccess = false;
			   $strNewStatus = 'failed';
			   $strMessage .= "Uploaded file doesn't exist on file system."."\n";
			   $strMessage .= "Changing file status to failed."."\n";
		}
		
		//update file name in table videos
		$sqlVideoUpdate  = "UPDATE videos SET ";
		$sqlVideoUpdate .= "url='".$strNewURL."', ";
		$sqlVideoUpdate .= "status = '".$strNewStatus."' ";
		$sqlVideoUpdate .= "WHERE id = '".$intInsertVideoID."'";

		$strMessage .= "Update Video SQL: "."\n";
		$strMessage .= $sqlVideoUpdate."\n";

		$rsVideoUpdate = mysql_query($sqlVideoUpdate, $partner_db);

		if($rsVideoUpdate){
			$strMessage .= "Video Update SQL query executed successfully."."\n";
		}else{
			$strMessage .= "Failed to execute Video Update SQL query."."\n";
		}
		
		$sqlVideoInfo  = "UPDATE videos SET ";
		$sqlVideoInfo .= "title = '".$title."', ";
		$sqlVideoInfo .= "blurb = '".$blurb."', ";
		$sqlVideoInfo .= "flag_adult = '".$adult."', ";
		$sqlVideoInfo .= "flag_private = '".$intFlagPrivate."', ";
		$sqlVideoInfo .= "main_channel_id = '".$channel."' ";
		$sqlVideoInfo .= "WHERE id = '".$intInsertVideoID."' ";
		$sqlVideoInfo .= "AND user_id = '".$uid."' LIMIT 1";
		$rsVideoInfo = mysql_query($sqlVideoInfo, $partner_db);

		if($rsVideoInfo){
			$strMessage .= "Video Info SQL query executed successfully."."\n";
		}else{
			$strMessage .= "Failed to execute Video Info SQL query."."\n";
		}
		
		$strMessage .= "Second Update Video SQL: "."\n";
		$strMessage .= $sqlVideoInfo."\n";
		
		// channels joint
		$sqlChannelJoint = "INSERT INTO channels_videos SET video_id = '".$intInsertVideoID."', channel_id = '".$channel."'";

		$strMessage .= "Videos-Channels joint SQL: "."\n";
		$strMessage .= $sqlChannelJoint."\n";

		$rsChannelJoint = mysql_query($sqlChannelJoint, $partner_db);

		if($rsChannelJoint){
			$strMessage .= "Videos-Channels joint SQL query executed successfully."."\n";
		}else{
			$strMessage .= "Failed to execute Videos-Channels joint SQL query."."\n";
		}
		
		// add video tags
		if($tags){
			$strMessage .= "Saving video tags: ".$tags."\n";
			$objTag = new tags();
			$objTag->tablename = "tags_videos";
			$objTag->connection = $partner_db;
			$resultAddTag = false;
			$resultAddTag = $objTag->add_tag($tags, $intInsertVideoID);
			if($resultAddTag){
				$strMessage .= "Tags saved successfully."."\n";
			}else{
				$strMessage .= "Failed to save tags."."\n";
			}
		}				
		$strMessage .= "\n\n"."--------------------------------------------------------------------------"."\n\n";

		//save log for user
		$file_size_mb = round($file_size/1048576, 2);
		$userMessage = $file.", ".$file_size_mb." MB, ".$strNewStatus."\r\n";
		$fp = fopen($strLogDir.$sid.'.log', 'a');
		fwrite($fp, $userMessage);
		fclose($fp);
		if(file_exists($strLogDir.$sid.'.log')) chmod($strLogDir.$sid.'.log', 0777);
		
		if($flagSaveLog){
		   $fp = fopen($strLogDir.$sid.'_debug.log', 'a');
		   fwrite($fp, $strMessage);
		   fclose($fp);
		   if(file_exists($strLogDir.$sid.'_debug.log')) chmod($strLogDir.$sid.'_debug.log', 0777);
		}
		
	}else {
		echo "No input data"."\n\n";
		
	}
?>
