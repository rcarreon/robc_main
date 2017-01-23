<?php

include 'settings.php';

$sid = $_GET ['sid'];
$pid = $_GET ['pid'];
$fid = $_GET ['fid'];

/*print_r($_FILES);

if ($_FILES["fileToUpload"]["error"] > 0) {
	echo "Error: " . $_FILES["fileToUpload"]["error"] . "<br />";
} else {
	echo "Upload: " . $_FILES["fileToUpload"]["name"] . "<br />";
	echo "Type: " . $_FILES["fileToUpload"]["type"] . "<br />";
	echo "Size: " . ($_FILES["fileToUpload"]["size"] / 1024) . " Kb<br />";
	echo "Stored in: " . $_FILES["fileToUpload"]["tmp_name"];
}*/

// /tmp/uploads/
$dstdir = $UPLOAD_DIR;
$dstname = $dstdir.$sid . "." .$fid. ".final";
$logFileName = $pid . '_' . date ( 'Ymd' ) . '_' . $sid . '_upload_log.txt';
$partDebug = '';
$error = false;
$nominal_chunk_size = 500000;

function addToDebug($msg) {
	global $partDebug;
	$partDebug .= date('h:i:s').' - '.$msg."\n";
}

$headers = getallheaders();
$protocol = $_SERVER['SERVER_PROTOCOL'];
//$fnc = isset($_GET['fnc']) ? $_GET['fnc'] : null;
$file = new stdClass();
$file->name = basename($headers['X-File-Name']);
$file->size = $headers['X-File-Size'];
$file->currentChunk = $headers['X-File-Chunk'];
$file->resumeChunk = $headers['X-File-Resume'];
$file->currentChunkSize = $headers['X-File-Chunk-Size'];
$file->chunkNumber = $headers['X-File-Chunk-Number'];
$last_chunk = $file->currentChunk + 1 == $file->chunkNumber;
$last_chunk_size = $file->size - ($file->chunkNumber - 1) * 500000;


//File size request for paused uploads
if(isset($_GET['file_size']) && $_GET['file_size'] == '1') {
	//echo filesize('/mnt/nfs/Sova.com/'.$file->name);
	echo filesize($UPLOAD_DIR . $sid . '.' . $fid . '.' . $file->currentChunk . '.part');
	exit;
}

//Delete if upload was interrupted
if($file->currentChunk == '0' && $file->resumeChunk == '0') {
	if(file_exists($dstname)) {
		unlink($dstname);
	}
}


//echo $file->name ."   +++   ". $file->size; 
/*
$maxUpload = getBytes(ini_get('upload_max_filesize'));
$maxPost = getBytes(ini_get('post_max_size'));
$memoryLimit = getBytes(ini_get('memory_limit'));
$limit = min($maxUpload, $maxPost, $memoryLimit);
if ($headers['Content-Length'] > $limit) {
  header($protocol.' 403 Forbidden');
  exit('File size to big. Limit is '.$limit. ' bytes.');
}
*/

if (isset($sid) && isset($fid) && isset($file->currentChunk)) {
	
	if ($file->currentChunk == 0 && $file->resumeChunk == '0') {
		addToDebug("######################## UPLOADER DEBUG ######################");
		addToDebug('Partner ID: ' . $pid);
		addToDebug('File name: ' . $file->name);
		addToDebug("Total size: " . $file->size);
		addToDebug(date ( 'l jS \of F Y h:i:s A' ) );
		addToDebug('USER AGENT: ' . $_SERVER ['HTTP_USER_AGENT'] );
		addToDebug("session id: " . $sid . " , file id: " . $fid );
	} 
	
	//save chunk file path
	$temp_part = $UPLOAD_DIR . $sid . '.' . $fid . '.' . $file->currentChunk . '.part';
	
	if($file->currentChunk == 0) {
		$currentFinalFileSize = 0;
	} else {
		$currentFinalFileSize = getFileSize($dstname);
		$currentFinalFileSize = $currentFinalFileSize != '' ? $currentFinalFileSize : 0;
	}
	
	//Final file can't be bigger in size than source file and must be different in size then source if we want to append
	if($currentFinalFileSize <= $file->size && $currentFinalFileSize != $file->size) {
		
		/** 
	 	* Is chunk recieved again or it was resent by Connection failiure, check do we need to append it?
	 	* Is chunk number valid against file size; number of chunks already appended and current chunk that is sending. 
	 	*/
		addToDebug("\n\nPreliminary check");
		addToDebug("Current size of the final file (system size) :".$currentFinalFileSize);
		addToDebug("Html5 is sending part:".$file->currentChunk." in size according to Html5: ".$file->currentChunkSize);
		
		/**
		 * Preliminar check if file that we want to appned is allready appended to final file.
		 * Devision of final file size and nominal chunk size will tell us how many chunks are successufully appended.
		 * If number of appended files is smaller or equal then chunk part number that is currently sent by script, then we append.
		*/
		$uploadedChunkNumber = (int)($currentFinalFileSize/$nominal_chunk_size);
		$uploadedPartsNum = $uploadedChunkNumber;
		//$uploadedChunkNumber = sprintf ( "%04d", $uploadedChunkNumber );
		
		addToDebug("Already uploaded parts on system by calculation (Current Final File Size divided by Nominal Chunk size): ".$currentFinalFileSize." / ".$nominal_chunk_size." = ".$uploadedPartsNum." - calcualted value");
		
		// Is number of uploaded parts equal then the current part that is sent?
		addToDebug("Is Uploaded parts num (calculated value):".$uploadedPartsNum." equal to Html5 parts num (value sent by Gears):".($file->currentChunk));
		
		if($uploadedPartsNum == $file->currentChunk) {
			
			if($file->resumeChunk == '0') {
				// temp save chunk	
				file_put_contents($temp_part, $HTTP_RAW_POST_DATA);	
			} else {
				file_put_contents($temp_part, $HTTP_RAW_POST_DATA, FILE_APPEND);
			}
			
			/**
			 * Is chunk file size same as the chunk size that is saved?
			 * If it is chunk that is recieved is good so we can append it.
			 * If it is not, send retry signal for this chunk, so it can be sent again.
			 */
			$tmp_part_size = getFileSize($temp_part);
			if (($tmp_part_size == $file->currentChunkSize) || (!$last_chunk && $file->resumeChunk == '1' && $tmp_part_size == 500000) || ($last_chunk && $file->resumeChunk == '1' && $tmp_part_size == $last_chunk_size)) {
				
				addToDebug('Sending part: ' .$file->currentChunk. ' (current:' .$file->currentChunk . ') of ' . ($file->chunkNumber) . ' size: ' . $tmp_part_size);
				addToDebug('Final file size BEFORE append is:' . $currentFinalFileSize);
				addToDebug('Appending ' . $temp_part. ' to final with size:' .$tmp_part_size);
				
				/**
				* Saving good chunk in size.
				* Try to open handler for binary appending data.
				*/
				if (!$handle = fopen($dstname, 'ab')) {
			         addToDebug("Cannot open file ($dstname)");
			         $error = true;
				} else {
					addToDebug("Fopen is good ($dstname)");
					/**
					* If fopen opened file for appending, try to write our data/chunk
					*/
					if(fwrite($handle, file_get_contents($temp_part)) === FALSE) {
						        
						addToDebug("Cannot write to file ($dstname)");
						$error = true;
					} else {
						//File append success !!!
						addToDebug("Success, wrote  to file ($dstname)");
						unlink($temp_part);
					}
					//Close fopen
					fclose($handle);
				}
				
				//If last chunk is recieved, AND PROPERLY SAVED, checkout size of gears final and uploaded final file
				if ($last_chunk) {
					$final_file_size = getFileSize($dstname);
					if ($final_file_size != $file->size) {
						addToDebug("Error, file size mismatch, NOT passed to complete.php.");
						addToDebug("Html5 size: (".$file->size.") is not ".$final_file_size);
						$error = true;
						//Remove junk file
						unlink($dstname);
					} else {
						addToDebug( "File successfully passed to complete.php");
					}
				}
			}
			
			/*
			$file->content = file_get_contents('php://input');
			file_put_contents($dstname, $file->content, FILE_APPEND);
			*/	
		} else if(($file->currentChunk) < $uploadedPartsNum) {
			//Stop/pause is pressed, so script is trying to send previous chunk again
			addToDebug("Stop/pause is pressed, so script is trying to send previous chunk again");
		} else {
			addToDebug("Number of chunks uploaded on the system (calculated by size)".$uploadedPartsNum." is NOT equal to the current part number (sent by Html5):".$file->currentChunk);
			addToDebug("CHUNK IS LATE -> CHUNK IS ALREADY APPENDED?");
			addToDebug("-----------------------------------------------------------");
			$error = true;
		}
		addToDebug('Final file size AFTER is:' . getFileSize($dstname));
		
		
	} else {
		//Script is trying to append on file that is equal or larger then the source.
		addToDebug("File size of the final file, can't be larger than the source file.");
		$error = true;
	}
		
} else {
	addToDebug( "no input data ");
}



//header('X-COMPLETE: TESTING');
echo "SUCCESS";

//If there is no log dir, we create it
if(!is_dir($LOG_DIR.$pid)) {
	exec('mkdir '.$LOG_DIR.$pid);
}

$LOG_DIR = $LOG_DIR.$pid.'/';
if(!is_dir($LOG_DIR.date("Ymd"))) {
	exec('mkdir '.$LOG_DIR.date("Ymd"));
}
$LOG_DIR = $LOG_DIR.date("Ymd").'/';

//Fill log file with data
if($partDebug != '') {
	file_put_contents ($LOG_DIR . $logFileName, $partDebug, FILE_APPEND);
}

//If error is triggered, we send it to sb.debug
if ($error) {
	//header ( $error_type );
	//header ( $error_msg );
	sendDebugEmail(file_get_contents($LOG_DIR . $logFileName) . "\n" );
}

function getFileSize($file_path) {
	clearstatcache();
	return filesize($file_path);
}
 
function getBytes($val) {
 
	$val = trim($val);
	$last = strtolower($val[strlen($val) - 1]);
	switch ($last) {
		case 'g': $val *= 1024;
		case 'm': $val *= 1024;
		case 'k': $val *= 1024;
	}
 
	return $val;
}
?>