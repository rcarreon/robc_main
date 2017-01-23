<?php

include 'settings.php';
/**
 * Catch values from the Ajax calls from the gears_uploader.js
 * 
 */
$sid = $_GET ['sid'];
$fid = $_GET ['fid'];
$current_part = $_GET ['current_part'];
$currPartByGears = $current_part +1;
$total_parts = $_GET ['total_parts'];
$total_size = $_GET ['total_size'];
$last_part_size = $_GET ['last_part_size'];
$last = $_GET ['last'];
$fileName = $_GET ['fileName'];
$partnerId = $_GET ['partnerId'];
$retryAttempt = isset ( $_GET ['retryAttempt'] ) ? $_GET ['retryAttempt'] : 0;
//Set current part
if (isset ( $current_part ))
{
	$current_part = sprintf ( "%04d", $current_part );
}
//Do we want to save log?
$flagSaveLog = true;
//Log file name
$logFileName = $partnerId . '_' . date ( 'Ymd' ) . '_' . $sid . '_upload_log.txt';
$partDebug = '';
$error = false;
//Nominal chunk size
$nominal_chunk_size = 512 * 1024;
//representative chunk size
$chunk_size = $nominal_chunk_size; 
if ($last == 1)
{
	$chunk_size = $last_part_size;
}
function addToDebug($msg)
{
	global $partDebug;
	$partDebug .= date('h:i:s').' - '.$msg."\n";
}
//Defaul values for header error to be sent
$error_type = 'X-COMPLETE: ERROR';
$error_msg = 'X-RETURN: Upload error detected. Please retry upload.';

header ( 'X-COMPLETE: FALSE' );
header ( 'X-RETURN: In progress' );
header ( 'X-SENDING-PART: ' . $current_part );

if (isset ( $sid ) && isset ( $fid ) && isset ( $current_part ))
{
		// Name of the final file
		$finalName = $UPLOAD_DIR . $sid . '.' . $fid . '.final';
		// If first part is recieved fill debug var
		if ($current_part == 0000)
		{
			addToDebug("######################## UPLOADER DEBUG ######################");
			addToDebug('Partner ID: ' . $partnerId);
			addToDebug('File name: ' . $fileName);
			addToDebug("Total size: " . $total_size);
			addToDebug(date ( 'l jS \of F Y h:i:s A' ) );
			addToDebug('USER AGENT: ' . $_SERVER ['HTTP_USER_AGENT'] );
			addToDebug("session id: " . $sid . " , file id: " . $fid );
		}
		
		//save chunk file path
		$temp_part = $UPLOAD_DIR . $sid . '.' . $fid . '.' . $current_part . '.part';
		
		clearstatcache();
		$currentFinalFileSize = filesize($finalName);
		$currentFinalFileSize = $currentFinalFileSize!='' ? $currentFinalFileSize : 0;
		//Final file can't be bigger in size than source file and must be different in size then source if we want to append
		if($currentFinalFileSize<=$total_size && $currentFinalFileSize!=$total_size)
		{
			/** 
		 	* Is chunk recieved again or it was resent by Connection failiure, check do we need to append it?
		 	* Is chunk number valid against file size; number of chunks already appended and current chunk that is sending. 
		 	*/
			addToDebug("\n\nPreliminary check");
			addToDebug("Current size of the final file (system size) :".$currentFinalFileSize);
			addToDebug("Gears is sending part:".$currPartByGears." in size according to Gears: ".$chunk_size);
			/**
			 * Preliminar check if file that we want to appned is allready appended to final file.
			 * Devision of final file size and nominal chunk size will tell us how many chunks are successufully appended.
			 * If number of appended files is smaller or equal then chunk part number that is currently sent by script, then we append.
			 */
			$uploadedChunkNumber = sprintf ( "%04d", 0 );
			$uploadedChunkNumber = (int)($currentFinalFileSize/$nominal_chunk_size);
			$uploadedPartsNum = $uploadedChunkNumber;
			$uploadedChunkNumber = sprintf ( "%04d", $uploadedChunkNumber );
			
			addToDebug("Already uploaded parts on system by calculation (Current Final File Size devided by Nominal Chunk size): ".$currentFinalFileSize." / ".$nominal_chunk_size." = ".$uploadedPartsNum." - calcualted value");
			
			// Is number of uploaded parts equal then the current part that is sent?
			addToDebug("Is Uploaded parts num (calculated value):".$uploadedPartsNum." equal to Gears parts num (value sent by Gears):".($currPartByGears-1));
			if($uploadedPartsNum==($currPartByGears-1))
			{
				// temp save chunk	
				file_put_contents ( $temp_part, $HTTP_RAW_POST_DATA );
				/**
				 * Is chunk file size same as the chunk size that is saved?
				 * If it is chunk that is recieved is good so we can append it.
				 * If it is not, send retry signal for this chunk, so it can be sent again.
				 */
				clearstatcache();
				$tmp_part_size = filesize ( $temp_part );
				if ($tmp_part_size == $chunk_size)
				{
					  
					  addToDebug('Sending part: ' .$currPartByGears. ' (current:' .$current_part . ') of ' . ($total_parts) . ' size: ' . $tmp_part_size);
					  addToDebug('Final file size BEFORE append is:' . $currentFinalFileSize);
					  addToDebug('Appending ' . $temp_part. ' to final with size:' .$tmp_part_size);
					  
					  /**
					   * Saving good chunk in size.
					   * Try to open handler for binary appending data.
					   */			
					  if (!$handle = fopen($finalName, 'ab')) {
					         addToDebug("Cannot open file ($finalName)");
					         $error = true;
					   }
					   else
					   {
					   	    addToDebug("Fopen is good ($finalName)");
						   /**
						    * If fopen opened file for appending, try to write our data/chunk
						    */
						   if(fwrite($handle, file_get_contents($temp_part)) === FALSE) {
						        
						         addToDebug("Cannot write to file ($finalName)");
						   	 	 $error = true;
						   }
						   else
						   {
						   	 //File append success !!!
						   	 addToDebug("Success, wrote  to file ($finalName)");
						   	 unlink($temp_part);
						   }
						   //Close fopen
						   fclose($handle);
					   }
						//If last chunk is recieved, AND PROPERLY SAVED, checkout size of gears final and uploaded final file
						if ($last==1)
						{
							clearstatcache();
							$final_file_size = filesize ( $finalName );
							if ($final_file_size != $total_size)
							{
								addToDebug("Error, file size mismatch, NOT passed to complete.php.");
								addToDebug("Gears size: (".$total_size.") is not ".$final_file_size);
								$error = true;
								//Remove junk file
								unlink ( $finalName );
							} else
							{
								addToDebug( "File successfully passed to complete.php");
							}
						}
						
				} //something went wrong in IF above (chunk size isn't good)
				else
				{
					clearstatcache();
					$new_tmp_part_size = filesize ( $temp_part );
					//What is with filesize? Upload again you stupid Gears!
					addToDebug('SENDING RETRY SIGNAL: Tried to send current part by Gears: ' .$currPartByGears . ' (current: ' .$current_part . ') filename:' . $temp_part . ' in size (' . $new_tmp_part_size . ') of  ' . $total_parts . ' but chunk size need to be: ' . $chunk_size . ' (retry attempt:' . $retryAttempt . ')');
					if ($retryAttempt == 2) //attempts can be 0,1,2
					{
						$error = true;
						addToDebug( 'Upload failed with message: Network issue detected. Please retry upload');
					}
					header ( 'X-COMPLETE: ERROR-CHUNK' );
					header ( 'X-CHUNK: ' . ($currPartByGears-1) );
					header ( 'X-CHUNK-SIZE: ' . $new_tmp_part_size );
					header ( 'X-RETURN: Upload error detected. Retrying...'); //Upload error detected. Retrying...
					//header ( 'X-RETURN: Network issue detected. CHUNK NUM: '.($currPartByGears-1).' Please retry upload. Attempt: ' . $retryAttempt );
				
				}
			}
			//Number of Gears Parts is smaler than uploaded parts number
			else if(($currPartByGears-1)<$uploadedPartsNum)
			{
				//Stop/pause is pressed, so script is trying to send previous chunk again
				addToDebug("Stop/pause is pressed, so script is trying to send previous chunk again");
			}
			//Chunk recieved is in past/future tense. Number of gears parts is larger than the uploaded part number, send error signal
			else
			{
				addToDebug("Number of chunks uploaded on the system (calculated by size)".$uploadedPartsNum." is NOT equal to the current part number (sent by Gears):".$currPartByGears);
				addToDebug("CHUNK IS LATE -> CHUNK IS ALREADY APPENDED?");
				addToDebug("-----------------------------------------------------------");
				$error = true;
			}
			clearstatcache();
			addToDebug('Final file size AFTER is:' . filesize ( $finalName ));
		}	
		else
		{
			//Script is trying to append on file that is equal or larger then the source.
			addToDebug( "File size of the final file, can't be larger than the source file.");
			$error = true;
		}
		
} else
{
	addToDebug( "no input data ");
}

//If there is no log dir, we create it
if(!is_dir($LOG_DIR.$partnerId))
{
		exec('mkdir '.$LOG_DIR.$partnerId);
}

$LOG_DIR = $LOG_DIR.$partnerId.'/';

if(!is_dir($LOG_DIR.date("Ymd")))
{
		exec('mkdir '.$LOG_DIR.date("Ymd"));
}
$LOG_DIR = $LOG_DIR.date("Ymd").'/';

//Fill log file with data
if ($flagSaveLog && $partDebug != '')
{
	file_put_contents ( $LOG_DIR . $logFileName, $partDebug, FILE_APPEND );
}

//If error is triggered, we send it to sb.debug
if ($error)
{
	header ( $error_type );
	header ( $error_msg );
	sendDebugEmail ( file_get_contents ( $LOG_DIR . $logFileName ) . "\n" );
}
?>