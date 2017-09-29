<?php
// This file is managed by Puppet 
// $Id: healthcheck.php 278 2009-04-17 22:43:56Z jrottenberg $

/**
* This is a _internal_ health check
*/
if (isset($_SERVER["HTTP_X_FORWARDED_FOR"]))
{
    exit();
}


/**
* Placeholder for all our healthchecks
* The goal is to use that code to gather status via nagios check_http
*
*/


function testConnectivity ($url)
{
    /**
    * Initialize the cURL session
    */
    $ch = curl_init();
    /**
    * Set the URL of the page or file to download.
    */
    curl_setopt ($ch, CURLOPT_URL,$url);

    /**
    * We need the status along with the content, we won't wait too long 
    */
    curl_setopt ($ch, CURLOPT_RETURNTRANSFER, 1);
    curl_setopt ($ch, CURLOPT_TIMEOUT, 2);

    /**
    * Execute the cURL session
    */
    curl_exec ($ch);

    /**
    * Get the status code
    */
    $httpcode = curl_getinfo($ch, CURLINFO_HTTP_CODE);

    /**
    * Close cURL session
    */
    curl_close ($ch);

    if($httpcode>=200 && $httpcode<400) return true;
    else return false;
}





/**
* Test external connectivity
*/
$url="http://www.google.com/";
if (testConnectivity($url)) 
{
    echo "External: OK\n";
}
else 
{
    echo "External: Error, No conection to $url\n";
}


/**
* Test internal connectivity
*/
$url="http://forums.wrestlezone.com/clear.gif";

if (testConnectivity($url))
{
    echo "Internal: OK\n";
}
else
{
    echo "Internal: Error, No connection to $url\n";
}

?>
