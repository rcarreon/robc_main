
<html>
<head>
<title> Logging out from NOC Reports </title>

<?php
/* As simple as delete a cookie*/
/* [restrada]  */
setcookie("nocreports_uname", '', time()-3600*365);
?>

<meta http-equiv="REFRESH" content="2;url=index.php">
</head>
</html>




