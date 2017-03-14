<?php
$server = "http://192.168.12.45/cgi-bin/speedtest.cgi";
$speed = file_get_contents($server);

$i=1;
$speed_a = explode(" ", $speed);
$speed_c="";
foreach ($speed_a as $speed_b)
{
  if ($i==1 OR $i==2 OR $i==3)
  {
    #$speed_c.="OO".$speed_b."OO";
  }
  else
  {
    $speed_c.=$speed_b." ";
  }
  $i++;
}

if ($speed === FALSE)
{
  echo "Error while doing the Speedtest";
}
else
{
  #echo $speed;
  echo $speed_c;
}
?>
