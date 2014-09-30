<?php 
$con=mysqli_connect("localhost","admin","admin","cellcity");  
if (!$con)
{
    die('Could not connect: ' . mysqli_connect_error());
}   
$con2=mysql_connect("localhost", "admin", "admin");
if (!$con2){
	die('Could not connect: ' . mysql_error());
}
?>
