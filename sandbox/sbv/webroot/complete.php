<?php
/**
 * Complete upload
 * Send video details and file path
 * Copy file and store data into database
 * @author Unknown - Documented by Milos Todorovic
 * @version 1.0
 * @category  gears.upload
 * @see help.functions.php
 * If error gets true, thats a big error, consider removing record or deleting file - log it in file and send debug email
 * In other cases it's a minor error just log it
 * 
*/
error_reporting(E_ALL ^ E_NOTICE);
ini_set('max_execution_time',600);
ini_set('display_errors',1);

if(isset($_GET ['phpinfo']) && $_GET ['phpinfo']=='version')
{
	echo phpinfo();
	die();
}
include 'settings.php';
require_once 'help.functions.php';
include 'class/class_tags.php';

//Config array to serve insertHelper object if need to reconect with mysql
$config = array('host'=>$db_host,'user'=>$db_user,'pass'=>$db_pass,'db_name'=>$db_name);
//InsertHelper file to work with insert, upadtes and mysql reconnect
$insertHelper = new InsertHelper($central_db,$config);
// configuration
define ( 'TIME_ZONE_OFFSET', 8 );
$intVideoFilePermissions = 0777;
$strIncomingDir = 'incoming';
$strConversionDir = "conversion";
$flagSaveLog = true;
$strLogDir = $LOG_DIR;

$strFilesArray = print_r ( $_FILES, true );
$strPostArray = print_r ( $_POST, true );
$strGetArray = print_r ( $_GET, true );

// start the log message
$insertHelper->strMessage = 'LOG ENTRY: ' . $_SERVER ['SERVER_NAME'] . "\n";
$insertHelper->strMessage .= 'Time start: ' . date ( "Y-m-d", strtotime ( TIME_ZONE_OFFSET . " hours" ) );
$insertHelper->strMessage .= ' at ' . date ( "H:i:s", strtotime ( TIME_ZONE_OFFSET . " hours" ) ) . "\n";
$insertHelper->strMessage .= 'Remote IP: ' . $_SERVER ['REMOTE_ADDR'] . "\n";
$insertHelper->strMessage .= 'Remote Port: ' . $_SERVER ['REMOTE_PORT'] . "\n";
$insertHelper->strMessage .= 'Remote User Agent: ' . $_SERVER ['HTTP_USER_AGENT'] . "\n";
$insertHelper->strMessage .= 'Referrer URI: ' . $_SERVER ['HTTP_REFERER'] . "\n";
$insertHelper->strMessage .= 'Request URI: ' . $_SERVER ['REQUEST_URI'] . "\n";
$insertHelper->strMessage .= 'FILES Array: ' . $strFilesArray . "\n";
$insertHelper->strMessage .= 'POST Array: ' . $strPostArray . "\n";
$insertHelper->strMessage .= 'GET Array: ' . $strGetArray . "\n";
$insertHelper->strMessage .= 'SCRIPT ACTIVITY LOG: ' . "\n\n";
//check get
if (isset ( $_GET ['convert_to'] ) && isset ( $_GET ['file_size'] ) && isset ( $_GET ['partner_id'] ) && isset ( $_GET ['title'] ) && isset ( $_GET ['blurb'] ) && isset ( $_GET ['tags'] ) && isset ( $_GET ['channel'] ) && isset ( $_GET ['flag_agegate'] ) && isset ( $_GET ['fid'] ) && isset ( $_GET ['sid'] ) && isset ( $_GET ['file'] ) && isset ( $_GET ['uid'] ) && isset ( $_GET ['activationDate'] ))
{
	
	/* Filter input */
	$uid = mysql_real_escape_string ( trim ( $_GET ['uid'] ) );
	$file_size = mysql_real_escape_string ( trim ( $_GET ['file_size'] ) );
	$original_file_size = mysql_real_escape_string ( trim ( $_GET ['file_size'] ) );
	$partner_id = mysql_real_escape_string ( trim ( $_GET ['partner_id'] ) ); // partner sajt 
	$sid = mysql_real_escape_string ( trim ( $_GET ['sid'] ) ); // upload session id
	$fid = mysql_real_escape_string ( trim ( $_GET ['fid'] ) ); // file id, redni broj fajla u sesiji
	$file = mysql_real_escape_string ( trim ( $_GET ['file'] ) ); //ime fajla
	$title = mysql_real_escape_string ( trim ( $_GET ['title'] ) ); // naslov
	$blurb = mysql_real_escape_string ( trim ( $_GET ['blurb'] ) );
	$tags = mysql_real_escape_string ( trim ( $_GET ['tags'] ) );
	$channel = mysql_real_escape_string ( trim ( $_GET ['channel'] ) ); // channel_id
	$flag_agegate = mysql_real_escape_string ( trim ( $_GET ['flag_agegate'] ) ); //flag
	$upload_mode = mysql_real_escape_string ( trim ( $_GET ['upload_mode'] ) ); //flag
	$custom_bitrate = mysql_real_escape_string ( trim ( $_GET ['bitrate'] ) ); //flag
	$activationDate = mysql_real_escape_string ( trim ( $_GET ['activationDate'] ) ); //Activation date for video
	$convert_to = mysql_real_escape_string ( trim ( $_GET ['convert_to'] ) ); // Convert to added @since Version 1.1, values [0,1], 0 for flv, 1 for h264
	if(isset($_GET['sitemap_url']) && $_GET['sitemap_url'] != '' && $_GET['sitemap_url'] != 'http://') {
		$sitemapUrl = mysql_real_escape_string ( trim ( $_GET ['sitemap_url'] ) );
	}
	

	$originalFileName = $file;
	$insertHelper->strMessage .= "Original File Name: $originalFileName ." . "\n";
	
	$strExtension = $insertHelper->getExtension ( $file );
	$insertHelper->strMessage .= "Original File Extension: $strExtension " . "\n";
	
	$file = $sid . "_" . $fid . "." . $strExtension;
	$insertHelper->strMessage .= "Temp File Name: $file " . "\n";
	
	//get max allowed bitrate for partner
	$video_bitrate = $insertHelper->getVideoBitRate ( $partner_id, $custom_bitrate );
	
	$row = $insertHelper->getPartnerConfiguration($partner_id);
	
	if (! $insertHelper->getError())
	{
		$strSiteDomain = '';
		if (isset ( $row ['domain'] ))
			$strSiteDomain = $row ['domain'];
		
		$insertHelper->strMessage .= 'Current server name: ' . $_SERVER ['SERVER_NAME'] . "\n";
		$insertHelper->strMessage .= 'Original File Name: ' . $file . "\n"; // start managing the uploaded file
		$strURL = '/' . $strIncomingDir . '/' . $file;
		$insertHelper->strMessage .= 'Starting URL: ' . $strURL . "\n";
		
		if (! isset ( $row ['flag_private'] ))
			$row ['flag_private'] = 0;
		if (! isset ( $row ['flag_video_auto_accept'] ))
			$row ['flag_video_auto_accept'] = 0;
			
		// check is video uploaded by user or site 		
		$intFlagPrivate = 0;
		$intFlagPrivate = $row ['flag_private'];
		
		$strFlagVideoAutoAccept = 0;
		$strFlagVideoAutoAccept = $row ['flag_video_auto_accept'];
		
		$intFlagUser = 1;
		$intFlagAccepted = 0;
		$intFlagActive = 0;
		
		if ($upload_mode == 'user')
		{
			$intFlagUser = 1;
			if ($strFlagVideoAutoAccept == 1)
			{
				$intFlagAccepted = 1;
				$intFlagActive = 1;
			} else
			{
				$intFlagAccepted = 0;
				$intFlagActive = 0;
			}
		} else if ($upload_mode == 'site')
		{
			$intFlagUser = 0;
			$intFlagAccepted = 1;
			$intFlagActive = 1;
		}
		///////////////////////
		// Main insert query //
		//////////////////////
		
		// Contract text on 2000 chars - limit by database
		$blurb = substr ( $blurb, 0, 2000 );
		//$insertHelper->executeQuery ( 'START TRANSACTION', __LINE__.' file:'.__FILE__);
		/* Save data into video table */
		$strVideoInsert = 'INSERT INTO videos SET 
		user_id= "'.$uid.'", 
		flag_private ="' . $intFlagPrivate . '", 
		main_channel_id ="' . $channel . '",  
		url = "' . $strURL . '", 
		site_id = "' . $partner_id . '", 
		created = NOW(), 
		title = "' . $title . '", 
		original_filename = "' . $originalFileName . '", 
		blurb= "' . $blurb . '", 
		status = "pre_uploaded", 
		bitrate = "' . $video_bitrate . '" ,
		flag_user = "' . $intFlagUser . '", 
		flag_accepted = "' . $intFlagAccepted . '", 
		file_size = "' . $file_size . '", 
		original_file_size = "' . $original_file_size . '", 
		flag_active = "' . $intFlagActive . '", 
		convert_to = "' . $convert_to . '", 
		flag_agegate = "' . $flag_agegate . '", 
		activation_date = "' . $activationDate . '"';
		
		if(isset($_GET['sitemap_url']) && $_GET['sitemap_url'] != '' && $_GET['sitemap_url'] != 'http://') {
			$strVideoInsert .= ", sitemap_id = ". $row['sitemap_id'] . ", ";
			$strVideoInsert .= "sitemap_title = '". $title . "', ";
			$strVideoInsert .= "sitemap_description = '". $blurb . "', ";
			$strVideoInsert .= "sitemap_url = '". $sitemapUrl . "', ";
			$strVideoInsert .= "sitemap_tag = '". $tags . "'";
		}
		
		
		$insertHelper->strMessage .= 'Insert Video SQL: ' . "\n" . $strVideoInsert . "\n";
		$resultVideoInsert = $insertHelper->executeQuery ( $strVideoInsert, __LINE__.' file:'.__FILE__);
		if ($resultVideoInsert)
		{
			//$insertHelper->executeQuery ( 'COMMIT', __LINE__.' file:'.__FILE__);
			$insertHelper->strMessage .= 'SQL query executed successfully.' . "\n";
		} else
		{
			$insertHelper->strMessage .= 'Failed to execute SQL query.' . mysql_error () . '(On line: ' . __LINE__ . ')' . "\n";
			$insertHelper->setError(true);
			//$insertHelper->executeQuery ( 'ROLLBACK', __LINE__.' file:'.__FILE__);
		}
		//It is failed in every other case right?
	}
	$strNewStatus = 'failed';
	
	if ($resultVideoInsert && ! $insertHelper->getError())
	{
		$insertHelper->strMessage .= 'Try to get last insert id.' . "\n";
		$intInsertVideoQuery = $insertHelper->executeQuery ( 'SELECT LAST_INSERT_ID();' ,__LINE__.' file:'.__FILE__);
		$lastIdRow = mysql_fetch_assoc ( $intInsertVideoQuery );
		$intInsertVideoID = 0;
		if (! empty ( $lastIdRow ))
		{
			//Here we set last insert id of video - this is very important
			$intInsertVideoID = $lastIdRow ['LAST_INSERT_ID()'];
			$insertHelper->strMessage .= 'Last insert id is:(' . $intInsertVideoID . ")\n";
		} else
		{
			$insertHelper->strMessage .= 'No Last insert id set.' . "\n";
			$insertHelper->setError(true);
		}
		//If last insert id isn't set, this is an Error!
		if ($intInsertVideoID != 0 && ! $insertHelper->getError())
		{
			
			/* Save data into vote table */
			/*$sqlVote = 'INSERT INTO vote SET type = "video", site_id = "' . $partner_id . '", id = "' . $intInsertVideoID . '"';
			$insertHelper->strMessage .= 'Insert Vote SQL: ' . "\n" . $sqlVote . "\n";
			$rsVote = $insertHelper->executeQuery ( $sqlVote ,__LINE__.' file:'.__FILE__);
			if ($rsVote)
			{
				$insertHelper->strMessage .= 'Insert Vote SQL query executed successfully.' . "\n";
			} else
			{
				$insertHelper->strMessage .= 'Failed to execute Insert Vote SQL query.' . mysql_error () . '(On line: ' . __LINE__ . ')' . "\n";
				$insertHelper->setError(true);
			}*/
			if (! $insertHelper->getError())
			{
				
				//copy video file to converted folder
				$strNewFileName = $intInsertVideoID . "." . $strExtension;
				$strDestinationPath = $strFileStorageDir . '/' . $strSiteDomain . '/' . $strIncomingDir . "/" . $strNewFileName;
				$strNewURL = '/' . $strIncomingDir . '/' . $strNewFileName;
				$strNewStatus = 'uploaded';
				
				$insertHelper->strMessage .= 'New file name: ' . $strNewFileName . "\n";
				$insertHelper->strMessage .= 'Destination Path: ' . $strDestinationPath . "\n";
				$insertHelper->strMessage .= 'New URL: ' . $strNewURL . "\n";
				$insertHelper->strMessage .= 'New status: ' . $strNewStatus . "\n";
				
				//find max file size for current partner
				$MAX_FILE_SIZE = $insertHelper->getMaxFileSizeByPartnerId ( $partner_id );
				$insertHelper->strMessage .= "Max file size: $MAX_FILE_SIZE\n";
				//If file size is larger then allowed file size, return error
				$fileBigError = false;
				clearstatcache();
				if (filesize ( $UPLOAD_DIR . $sid . '.' . $fid . '.final' ) > $MAX_FILE_SIZE)
				{
					header ( 'X-COMPLETE: TOO_BIG' );
					header ( 'X-RETURN: File is too large.' );
					$insertHelper->strMessage .= "The file is too large!!!\n";
					$insertHelper->updateVideoStatus ( $intInsertVideoID,$uid, 'failed' );
					unlink ( $UPLOAD_DIR . $sid . '.' . $fid . '.final' );
					//return error
				}
				else
				{
					//copy
					$tmp_file_path = $UPLOAD_DIR . $sid . '.' . $fid . '.final';
					$insertHelper->strMessage .= 'Try to copy: ' . $tmp_file_path . ' to ' . $strDestinationPath . "\n";
					clearstatcache();
					$tmpFileSize = filesize($tmp_file_path);
					$insertHelper->strMessage .= 'Tmp file size: ' . $tmp_file_path . ' in bytes :' . $tmpFileSize . "\n";
					$out = exec ( 'mv ' . $tmp_file_path . ' ' . $strDestinationPath ,$arr, $output);
					$insertHelper->strMessage .= '---------- START OUTPUT OF EXEC ---------------'. "\n";
					$insertHelper->strMessage .= 'out:'.print_r($out,true). "\n";
					$insertHelper->strMessage .= 'arr:'.print_r($arr,true). "\n";
					$insertHelper->strMessage .= 'output:'.print_r($output,true). "\n";
					$insertHelper->strMessage .= '---------- END OUTPUT OF EXEC ---------------'. "\n";
					
					//When copy is successufull Linux returns in as output 0 not 1
					
					
					$original_mimetype = $insertHelper->getMimeType($strDestinationPath);
					
					//Check if file exists after copy
					clearstatcache();
					$destinationFileSize = filesize($strDestinationPath);
					if (file_exists ( $strDestinationPath ))
					{
						chmod ( $strDestinationPath, $intVideoFilePermissions );
						//@unlink($UPLOAD_DIR.$sid.'.'.$fid.'.*');
						//@exec ( 'rm -rf ' . $tmp_file_path );
						//@exec ( 'rm -rf ' . $UPLOAD_DIR . $sid . '.' . $fid . '*' );
						#fclose(fopen($tmp_file_path.'.copied'., 'w'));
						$insertHelper->strMessage .= 'Removed temp files for: ' . $UPLOAD_DIR . $sid . '.' . $fid . "\n";
					} else
					{
						$insertHelper->setError(true);
						$strNewStatus = 'failed';
						$insertHelper->strMessage .= 'Uploaded file doesn\'t exist on file system or file size of the destination file ('.$destinationFileSize.') isnt same as tmp file('.$tmpFileSize.').' . "\n";
						$insertHelper->strMessage .= 'Changing file status to failed.' . "\n";
					}
					//Check DB size and real file size on disk
					if($destinationFileSize!=$file_size)
					{
						$insertHelper->setError(true);
						$strNewStatus = 'failed';
						$insertHelper->strMessage .= 'Uploaded file doesn\'t size tmp size ('.$destinationFileSize.') isnt same as DB size ('.$file_size.').' . "\n";
						$insertHelper->strMessage .= 'Changing file status to failed.' . "\n";
						header ( 'X-COMPLETE: ERROR' );
						header ( 'X-RETURN: Upload error detected. Please retry upload.' );
					}
					
					
						//Update file name - url, legacy_id, status in table videos
						$sqlVideoUpdate = 'UPDATE videos SET incoming_url="'.$strNewURL.'", original_mime_type="'.$original_mimetype.'", url="' . $strNewURL . '", legacy_id="' . $intInsertVideoID . '",  status = "' . $strNewStatus . '" WHERE id = "' . $intInsertVideoID . '" AND user_id = "' . $uid . '"';
						$insertHelper->strMessage .= 'Update Video SQL: ' . "\n";
						$insertHelper->strMessage .= $sqlVideoUpdate . "\n";
						$rsVideoUpdate = $insertHelper->executeQuery ( $sqlVideoUpdate, __LINE__.' file:'.__FILE__);
						if ($rsVideoUpdate)
						{
							$insertHelper->strMessage .= 'Video Update SQL query executed successfully.' . "\n";
							// This need to be executed only if update pass
							// Insert channels join chain
							$insertHelper->insertChannel ( $intInsertVideoID, $channel, $partner_id );
							// Insert video tags
							if ($tags)
							{
								$insertHelper->strMessage .= 'Saving video tags: ' . $tags . "\n";
								$objTag = new tags ( );
								$objTag->tablename = "tags_videos";
								//Check connection with mysql_ping
								$objTag->connection = $insertHelper->getDb(__LINE__.' file:'.__FILE__);
								$objTag->site_id = $partner_id;
								$resultAddTag = false;
								$resultAddTag = $objTag->add_tag ( $tags, $intInsertVideoID );
								if ($resultAddTag)
								{
									$insertHelper->strMessage .= 'Tags saved successfully.' . "\n";
								} else
								{
									$insertHelper->strMessage .= 'Failed to save tags.' . mysql_error () . '(On line: ' . __LINE__ . ')' . "\n";
								}
							}
						
						} else
						{
							//If we get here this means that this query didn't passed so we need to set status failed for this videos
							$insertHelper->strMessage .= 'Failed to execute Video Update SQL query.' . mysql_error () . '(On line: ' . __LINE__ . ')' . "\n";
							$insertHelper->updateVideoStatus($intInsertVideoID,$uid,'failed');
							$insertHelper->setError(true);
						}
				
				}
				
			} else
			{
				//Vote insert failed, so video is failed so do not leave it preuploaded...
				$insertHelper->strMessage .= 'Failed to execute Vote insert SQL query.' . mysql_error () . '(On line: ' . __LINE__ . ')' . "\n";
				$insertHelper->updateVideoStatus ( $intInsertVideoID,$uid, 'failed' );
			}
		
		} else
		{   //If script gets here, that means that video tried to stuck on pre_upload status
			//Transaction will roll back but if in some reason this pass trasaction prevention
			//we get last 5 videos that are in pre_upload status to trace a bug
			$insertHelper->strMessage .= 'FAILED: Last insert id is:(' . $intInsertVideoID . ")\n";
			$insertHelper->fillDebugPreuploadByThisUser($uid);
			$insertHelper->setError(true);
			
		
		}
	}
	$insertHelper->strMessage .= "\n\n" . '--------------------------------------------------------------------------' . "\n\n";
	
	clearstatcache();
	// Fill debug with SHOW MYSQL info - removed from Version 1.2 of the help.functions.php @see isConnected
	//$insertHelper->fillDebugWithMysqlInfo();
	$insertHelper->strMessage .= 'Time script end: ' . date ( "Y-m-d", strtotime ( TIME_ZONE_OFFSET . " hours" ) );
	$insertHelper->strMessage .= ' at ' . date ( "H:i:s", strtotime ( TIME_ZONE_OFFSET . " hours" ) ) . "\n";
	//Save log for user - on server
	//Creating dir structure for upload logs by partner id and date
	if(!is_dir($strLogDir.$partner_id))
	{
			exec('mkdir '.$strLogDir.$partner_id);
	}
	
	$strLogDir = $strLogDir.$partner_id.'/';
	
	if(!is_dir($strLogDir.date("Ymd")))
	{
			exec('mkdir '.$strLogDir.date("Ymd"));
	}
	$strLogDir = $strLogDir.date("Ymd").'/';
	
	$file_size_mb = round ( $file_size / 1048576, 2 );
	$userMessage = $originalFileName . ', ' . $file_size_mb . ' MB, ' . $strNewStatus . "\r\n";
	$fp = fopen ( $strLogDir . $partner_id . '_' .date('Ymd').'_'. $sid . '.log', 'a' );
	fwrite ( $fp, $userMessage );
	fclose ( $fp );
	if (file_exists ( $strLogDir . $partner_id . '_'.date('Ymd').'_' . $sid . '.log' ))
		chmod ( $strLogDir . $partner_id . '_' .date('Ymd').'_'. $sid . '.log', 0777 );
	
	if ($flagSaveLog)
	{
		$fp = fopen ( $strLogDir . $partner_id . '_' .date('Ymd').'_'. $sid . '_debug.log', 'a' );
		fwrite ( $fp, $insertHelper->strMessage );
		fclose ( $fp );
		if (file_exists ( $strLogDir . $partner_id . '_' .date('Ymd').'_'. $sid . '_debug.log' ))
			chmod ( $strLogDir . $partner_id . '_' .date('Ymd').'_'. $sid . '_debug.log', 0777 );
	}
	// If error occures, send debug email to DEBUG_EMAIL and remove video from upload dir	
	if ($insertHelper->getError())
	{
		sendDebugEmail($insertHelper->strMessage);
		header ( 'X-COMPLETE:ERROR' );
		echo 'Some Error occured. Report is sent.';
		@unlink ( $UPLOAD_DIR . $sid . '.' . $fid . '.final' );
	}

} else
{
	echo 'No input data' . "\n\n";
}
//After script completes close mysql connection
mysql_close($central_db);
@mysql_close($insertHelper->db);
?>
