<?php
	include 'settings.php';
	// force download dialog
	header("Content-type: text/plain");
	header('Content-Disposition: attachment; filename="log.txt"');
	header("Content-Type: application/force-download");
	header("Content-Type: application/octet-stream");
	header("Content-Type: application/download");
		
	if(isset($_GET['sid'])){	
		//try to open user session log
		$sid = $_GET['sid'];	
		$user_log = $LOG_DIR.$sid.".log";
		if(!$fp2 = @fopen($user_log, 'r')){
			print "There is no uploaded video files for current session"."\r\n";
			exit;
		}
		$log_data = fread($fp2, filesize($user_log));
		print $log_data;
		fclose($fp2);
	}else {
		print "Invalid session id"."\r\n";
	}
?>
