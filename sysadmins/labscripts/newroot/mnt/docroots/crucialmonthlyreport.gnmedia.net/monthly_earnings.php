
<html>

<head>
<title>Crucial Monthly Earnings</title>
</head>
<body>
<h1>Crucial Monthly Earnings</h1>

<?php

//  grant all on labMonthly.* to lab@localhost identified 'omg';

mysql_connect("localhost", "lab", "omg") or die(mysql_error());
mysql_select_db("labMonthly") or die(mysql_error());

$query="SELECT name FROM statements";

$result=mysql_query($query);
$num=mysql_num_rows($result);

$i=0;
while ($i < $num) {
    $name=mysql_result($result,$i,"name");
    $i++;
    echo "The current monthly earnings are: <b> \$$name</b>";

}


?>

</body>
</html>
