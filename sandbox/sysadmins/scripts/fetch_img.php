<?php

/*
 * 
 * 
 * Rationale : fetch a file from a web server if it doesn't exist locally
 * 
 * Try to get it from other server(s), grab it, show it to the user, store it locally
 * 
 * 
*/

// Our servers ip
$ips = array("66.180.202.87", "66.180.202.88", "66.180.202.89", "66.180.202.94", "66.180.202.95");


// We know the file doesn't exist locally, no need to try on that one
//$local_ip = array($_SERVER["LOCAL_ADDR"]);
$local_ip = array();
$ips = array_diff($ips, $local_ip);


// Our Vhost
//$vhost =  $_SERVER["HTTP_HOST"];
$vhost = "hfboards.com";

// Doc root info
$docroot = $_SERVER["DOCUMENT_ROOT"];


// The file we need to fetch, we got the path from the redirect 404 error in apache conf
// ErrorDocument 404 /fetch_img.php
//$query = $_GET['m'];
$query = $_SERVER["REDIRECT_URL"];
if (!preg_match("/\.(png|bmp|jpg|jpeg)$/i",$query)) { 
	exit_404("file not an image");
}


// Let's add some magic (do not hammer always the same server ... first)
shuffle($ips);


$log = $docroot."/fetch.log";


while ($ips) {
	$ip = array_pop($ips);
	if (does_file_exist($ip,$vhost,$query)) break; // We got a winner !
	else $ip = "";				     // Exit the loop properly
}


// Debug
error_log ("ip : $ip\n",3,$log);
error_log ("query : $query\n",3,$log);

// so, if we found our server ip, let's get the file
if ($ip!='') {
	 list($response_headers,$response_body) = explode("\r\n\r\n", get_file($ip,$vhost,$query),2);
}
else {
	exit_404("file really not on servers");
}

// echo $response_headers;
preg_match('/Content-Type: ([\a-z0-9_-]*)$/i',$response_headers, $content_type);

// Debug
//print_r($content_type);echo "";

// Display file to user
Header($content_type[0]);
echo $response_body;



// Save file locally
$filename = $docroot.$query;

// Let's make sure the file exists and is writable first.
if (!$handle = fopen($filename, 'w+b')) {
	exit_404("Cannot open file :$filename");
}


// Write content to our opened file.
if (fwrite($handle, $response_body) === FALSE) {
   	exit;
}
fclose($handle);

/*
 * 
 * 
 *  Functions
 * 
 * 
*/


// Use HEAD to check if a file exist on a server
function does_file_exist ($ip,$vhost,$query) {
	$data = "";
	$fp = fsockopen($ip, 80, $errno, $errstr, 1);
	if (!$fp) {
		return false;
	} else {
		$out = "HEAD $query HTTP/1.1\r\n";
		$out .= "Host: $vhost\r\n";
		$out .= "Connection: Close\r\n\r\n";
		fwrite($fp, $out);
		while (!feof($fp)) {
			$data .= fgets($fp);
		}
		if (ereg('HTTP/1.1 200 OK', $data)) {
			return true;
		} else {
			return false;
		}	
		
		fclose($fp);
	}
}


// Get the file
function  get_file($ip,$vhost,$query) {
        $data = "";
        $fp = fsockopen($ip, 80, $errno, $errstr, 1);
        if (!$fp) {
                return false;
        } else {
                $out = "GET  $query HTTP/1.0\r\n"; // Avoid the 1.1 chunk
                $out .= "Host: $vhost\r\n";
                $out .= "Connection: Close\r\n\r\n";
                fwrite($fp, $out);
                while (!feof($fp)) {
                        $data .= fgets($fp);
	       }
 		
        fclose($fp);
	}
	return $data;
}

// We have a real 404 to deal with
function exit_404 ($msg) {
    	error_log ("$msg\n",3,$log);
	header("HTTP/1.1 404 Not Found");
	echo "Page not found";
	exit;
}




?>

