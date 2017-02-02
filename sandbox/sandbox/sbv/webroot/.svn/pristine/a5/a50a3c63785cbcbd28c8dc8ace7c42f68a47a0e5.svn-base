<?php 
	
	include 'settings.php';
	
	foreach($_POST as $key => $value) {
		addToDebug("============================\n");
		addToDebug($key. ": " .$value. "\n");
		addToDebug("============================\n");
	}
	
	sendDebugEmail($partDebug . "\n");
	echo "SUCCESS";
	exit;

	function addToDebug($msg) {
		global $partDebug;
		$partDebug .= date('h:i:s').' - '.$msg."\n";
	}

?>