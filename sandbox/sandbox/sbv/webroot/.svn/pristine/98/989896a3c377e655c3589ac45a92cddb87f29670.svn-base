<?php
/*print_r($_FILES);

if ($_FILES["fileToUpload"]["error"] > 0) {
	echo "Error: " . $_FILES["fileToUpload"]["error"] . "<br />";
} else {
	echo "Upload: " . $_FILES["fileToUpload"]["name"] . "<br />";
	echo "Type: " . $_FILES["fileToUpload"]["type"] . "<br />";
	echo "Size: " . ($_FILES["fileToUpload"]["size"] / 1024) . " Kb<br />";
	echo "Stored in: " . $_FILES["fileToUpload"]["tmp_name"];
}*/

$headers = getallheaders();
$protocol = $_SERVER['SERVER_PROTOCOL'];
$fnc = isset($_GET['fnc']) ? $_GET['fnc'] : null;
$file = new stdClass();
$file->name = basename($headers['X-File-Name']);
$file->size = $headers['X-File-Size'];
$file->currentChunk = $headers['X-File-Chunk'];
$file->resumeChunk = $headers['X-File-Resume'];

//File size request for paused uploads
if(isset($_GET['file_size']) && $_GET['file_size'] == '1') {
	echo filesize('/mnt/nfs/Sova.com/'.$file->name);
	exit;
}

//Delete if upload was interrupted
if($file->currentChunk == '0' && $file->resumeChunk == '0') {
	if(file_exists('/mnt/nfs/Sova.com/'.$file->name)) {
		unlink('/mnt/nfs/Sova.com/'.$file->name);
	}
}


//echo $file->name ."   +++   ". $file->size; 

$maxUpload = getBytes(ini_get('upload_max_filesize'));
$maxPost = getBytes(ini_get('post_max_size'));
$memoryLimit = getBytes(ini_get('memory_limit'));
$limit = min($maxUpload, $maxPost, $memoryLimit);
if ($headers['Content-Length'] > $limit) {
  header($protocol.' 403 Forbidden');
  exit('File size to big. Limit is '.$limit. ' bytes.');
}
 
$file->content = file_get_contents('php://input');
//$flag = ($fnc == 'resume' ? FILE_APPEND : 0);
//file_put_contents($file->name, $file->content, $flag);
file_put_contents('/mnt/nfs/Sova.com/'.$file->name, $file->content, FILE_APPEND);

echo "OK";
//chmod($dstname, 0777)
 
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