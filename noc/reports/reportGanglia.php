<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<?php
  include("include/config.inc");
  include("include/functions.inc");
  include("include/vars.inc");
  include("include/mysql-connect.inc");
  include("grafito.php");
?>
<html>
	<head>
  		<meta http-equiv="content-type" content="text/html; charset=utf-8" />
  		<title>NOC Reports</title>
  		<link href="css/menu.css" rel="stylesheet" type="text/css" />
                <link href="css/main.css" rel="stylesheet" type="text/css" />
  		<style type="text/css" title="currentStyle" >
                  <?php include("bodies/stylesheets.bdy"); ?>
                  @import "css/demo_page.css";
                  @import "css/demo_table.css";
                  @import "css/ColReorder.css";
                  @import "css/ColVis.css";
  		</style>
	</head>
	<body id="dt_example">

<?php

  $mysql_link_r = init(); 
  date_default_timezone_set("$timezone");

  if (!is_object($mysql_link_r)) {
    if ($debug_lvl>0)
      mysqli_connect_error();
    die("Cannot connect to the database");
  }

  $site = $_GET["site"]; 
  $down_lasttest =  strtotime ($_GET["down_lasttest"]);  //$down_lasttest is TIMESTAMP

  $report_id=getreportid($site, $down_lasttest, $mysql_link_r); //GET REPORT ID

 if($report_id==!0){ //IF THERE IS A REPORT
    $list=gettimes($report_id,$mysql_link_r);   //GET TIME DOWNTIME AND UPTIME FOR THAT REPORT
    //echo " \$list= ".$list;
    list($downtime, $uptime) = explode("#", $list);
    //$down_lasttest = $downtime;
	  if($downtime!=" "){ $downtime=date('m/d/Y h:i:s a T', $downtime); }
	  if($uptime!=" "){ $uptime=date('m/d/Y h:i:s a T', $uptime); }
    }else{
    $downtime=date('m/d/Y h:i:s a T', $down_lasttest);    
    $uptime="";//EMPTY UPTIME
	}
 
  $host_array_vpv = hostlist_vpv($site);
  //print_r($host_array_vpv);
  $host_array_vtr = gettrace($site);
  //print_r($host_array_vtr);
  $host_array_dtb = hostlist_dtb($site,$mysql_link_r);
  //print_r($host_array_dtb);

  if(isset($_POST["source"])) 
    $source=$_POST["source"]; 
  else
    $source="vpv";

  $evip=extractvip($site);
  $mail_gp="";
  $subject ="[NOC REPORT]:$site{ &#39;DOWN&#39; & &#39;UP&#39; }";


include ("bodies/menu.bdy");
include ("bodies/report_header.bdy");

if((sizeof($host_array_vpv)>1||sizeof($host_array_vtr)>1)){
?>
<form name="mainform" method="POST" action="#">
<table width="1000" border="0">
  <tr>
    
    <td width="170" align="center" valign="top">
        <strong>Host (VipVisual):</strong><br>
        <input type="radio" name="source" value="vpv" 
        <?php if($source=="vpv"){ echo "checked=\"yes\"";}?> 
        onClick="mainform.submit();"><?php echo "Graphite"; ?>
    </td>
    <td width="300" align="left" valign="top">
        <?php
        if($source=="vpv"){
          $mail_st .= hosts($host_array_vpv,"VipVisual");}
        else
          hosts($host_array_vpv,"VipVisual");
        ?>
    </td>
    <?php 
    if(php_uname('n')=="app1v-noc.tp.prd.lax.gnmedia.net"){ ?>

    <td width="170" align="center" valign="top">
      <strong>Host (Database):</strong><br>
      <input type="radio" name="source" value="dtb" 
      <?php if($source=="dtb"){ echo "checked=\"yes\"";}?>  
      onClick="mainform.submit();"><?php echo "Graphite"; ?>
    </td>
    <td width="300" align="left" valign="top">
        <?php
        if($source=="dtb"){
            $mail_st .= hosts($host_array_dtb,"Database");}
        else{
        //print_r($host_array_dtb);  
        hosts($host_array_dtb ,"Database");
        }
        ?>
    </td>

    <?php 
    }
    else { ?>

    <td width="170" align="center" valign="top">
      <strong>Host (Viptrace):</strong><br>
      <input type="radio" name="source" value="vtr" 
      <?php if($source=="vtr") echo "checked=\"yes\"";?>  
      onClick="mainform.submit();">Graphite
    </td>
    <td width="300" align="left" valign="top">
        <?php
        if($source=="vtr"){
            $mail_st .= hosts($host_array_vtr,"VipTrace");}
        else{
        hosts($host_array_vtr,"VipTrace");}
        ?>
    </td>

    <?php } ?>

</table>
<?php
  	$mail_st .="<table border=0>\r\n";
	$mail_st .="<tr><td width=140 height=23>\r\n";
	$mail_st .="<strong>Received From:</strong></td>\r\n";
	$mail_st .="<td></td></tr>";
	$mail_st .="<tr><td width=140 height=23>\r\n";
	$mail_st .="<strong>Monit Alerts:</strong></td>\r\n";
	$mail_st .="<td></td></tr>";
	$mail_st .="<tr><td width=140 height=23>\r\n";
	$mail_st .="<strong>Em Alerts:</strong></td>\r\n";
	$mail_st .="<td></td></tr>";
  	$mail_st .="<tr><td width=140 height=23>\r\n";
  	$mail_st .="<strong>Comments:</strong></td>\r\n";
  	$mail_st .="<td></td></tr></table>\r\n";
?>
</form>
<form id="graphicsform" name="graphicsform" method="POST" action="mail.php">
<table width="1270" height="130" border="0">
  <tr>
    <td width="1270" height="24" >
    <?php

    if($source=="vpv"&&sizeof($host_array_vpv)>1){
      //echo sizeof($host_array_vpv)." "."\$host_array_vpv";
      $host_array=$host_array_vpv;
    }
    if($source=="vtr"&&sizeof($host_array_vtr)>1){
      //echo sizeof($host_array_vtr)." "."\$host_array_vtr";
      $host_array=$host_array_vtr;
    }
    if($source=="dtb"&&sizeof($host_array_dtb)>1){
      //echo sizeof($host_array_vtr)." "."\$host_array_dtb";
      $host_array=$host_array_dtb;
    }

    if(isset($host_array)&&sizeof($host_array)>1)
       $from = date_format(date_create_from_format('m/d/Y h:i:s a T', $downtime), 'm/d/Y h:i a');
       $from = strtotime ($from);
       $from = $from - (28800);
       $from = date('m/d/Y h:i a', $from);
       $until = date_format(date_create_from_format('m/d/Y h:i:s a T', $uptime), 'm/d/Y h:i a');
       gangliaGraph($site, $source, "reports", $from, $until); 
#      grafito($site,$down_lasttest,"reports",NULL,$source,$host_array);
?>
    <input type="submit" value="Mail Preview">
<?php

    }else{
    ?>
    <form id="graphicsform" name="graphicsform" method="POST" action="mail.php">
    <?php
    echo "<td></br><strong>WARNING: No records found for this site</br>";
    echo "Please check documentation<A HREF=\"http://docs.gnmedia.net/wiki/NOC_Guide#Third_party_sites\"TARGET=\"_new\">Third party sites</A></strong></td>";
     $mail_st .="<table border=0>\r\n";
     $mail_st .="<tr><td width=140 height=23>\r\n";
     $mail_st .="<strong>Comments:</strong></td>\r\n";
     $mail_st .="<td></td></tr></table>\r\n";?>

    <input type="hidden" name="mail_st" value='<?php echo $mail_st; ?>'>
    <input type="hidden" name="subject" value="<?php echo $subject; ?>">
    <input type="hidden" name="aaction" value="Mail Preview">
    <input type="submit" value="Mail Preview">
    </form>
    <?php
    }
    ?>
  </td>
  </tr>
  <tr>    
</table>
    <input type="hidden" name="mail_st" value='<?php echo $mail_st; ?>'>
    <input type="hidden" name="subject" value="<?php echo $subject; ?>">
    <input type="hidden" name="aaction" value="Mail Preview">
</form>
<?php database_close($mysql_link_r);  ?>
</html>
