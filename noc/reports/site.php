<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
	<head>
		<meta http-equiv="content-type" content="text/html; charset=utf-8" />
		<title>Site Analyzer</title>
                <style type="text/css">
                  @import "css/main.css";
                </style>
		<link href="css/menu.css" rel="stylesheet" type="text/css">
    <script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.8.3/jquery.min.js"></script>
    <link rel="stylesheet" href="include/jquery-ui.css" />   <!-- autocomplete -->
    <script src="http://code.jquery.com/ui/1.10.0/jquery-ui.js"></script>    <!-- autocomplete -->
    <script type="text/javascript" src="include/sites.js.php"></script>   <!-- autocomplete -->
	<style type="text/css" title="currentStyle">
		@import "css/demo_page.css";
		@import "css/demo_table.css";
		@import "css/ColReorder.css";
		@import "css/ColVis.css";
			/*Search columns*/
		thead input { width: 100% }
		input.search_init { color: #999 }

		.dataTables_wrapper tbody tr:hover {
			/*background-color: #FFFF00!important;*/
			background-color: #ff903d!important;
			cursor: pointer;
			cursor: hand;}
	</style>
    <style type="text/css" title="currentStyle">
    body{background-color: f0f0f0;}  
    td {
        font: 80%/1.45em "Lucida Grande", Verdana, Arial, Helvetica, sans-serif;}
	 </style>
	</head>

<body id="dt_example">
<div id="container-wide">
<?php
  $debug_lvl = 0;
 
  include("include/functions.inc");
  include("include/vars.inc");
  include("include/config.inc");
  include("include/mysql-connect.inc");
  $mysql_link_r = init(); 
  date_default_timezone_set("$timezone");

  if (!is_object($mysql_link_r)) {
    if ($debug_lvl>0)
      mysqli_connect_error();
    die("Cannot connect to the database");
  }

  $link = database_open("$mysql_host", "r");

  /* Graphics size */
  $gr_width=600;
  $gr_height=300;
  $mail_st="";

  if (isset($_POST['site'])) {
    // POST LIST OF HOSTS FROM VIPVISUAL
    //$site1=$_POST['site'];

    /**************** replace next line for $site = ltrim_www($_POST['site']); */
    $site = str_replace('www.','',$_POST['site']);
    if(isset($_POST["source"])) 
      $source=$_POST["source"];
    else
      $source="vpv";
    
    $host_array_vpv = hostlist_vpv($site);
    //print_r($host_array_vpv);
    $host_array_vtr = gettrace($site);
    //print_r($host_array_vtr);
    $host_array_dtb = hostlist_dtb($site,$link);
    //print_r($host_array_dtb);
  }
  else
    $site="";

  if (isset($_POST['time']))
    $time=$_POST['time']*3600;
  else
    $time=0;

  include ("bodies/menu.bdy");
  $subject ="Graphics Report: ".$site;

?>


<form method="POST" action="#">
<table width="1200" height="50" border="0" class="Estilo11">
  <tr>
     <td width="122"><strong>Site:<input name="site" type="text" id="inputbox" size=30 <?php if (isset($_POST['site'])){ echo "value=\"".$site."\""; }?> >
     <input type="submit" name="submit" value="GO!" >Time:<select name="time"></strong>
	   <option value=1>1 hr</option>
	   <option value=2>2 hr</option>
     <option value=3>3 hr</option>
	   <option value=4 selected="selected">4 hr</option>
	   <option value=8>8 hr</option>
	   <option value=12>12 hr</option>
	   <option value=24>24 hr</option>
	</select>
     <input type="hidden" name="source" <?php if (isset($_POST['source'])){ echo "value=\"".$source."\""; } else { echo "value=vpv"; }?> > 
     </td>  
  </form>
  </tr>
</table>

<?php
if(isset($_POST["site"])) {
  $mysql_link_r = database_open($mysql_host, "r");
  include("grafito.php");

  if (!is_object($mysql_link_r)) {
    if ($debug_lvl>0)
      mysqli_connect_error();
    die("Cannot connect to the database");
  }
?>

<form name="mainform" method="POST" action="#">
<table width="1270" height="45" border="0" class="Estilo11" >
<tr>
	<td width="1000" align="left" valign="top"><strong>Site:</strong>
        <?php echo $site ?>
        </td>
</tr>
<?php
if((sizeof($host_array_vpv)>1||sizeof($host_array_vtr)>1)){
?>
<tr>
        <td width="1000" align="left" valign="top"><strong>VIP:</strong>
        <?php echo extractvip($site); ?>
        </td>

</tr>
        <input type="hidden" name="site" value="<?php echo $site; ?>">
        <input type="hidden" name="time" value="<?php echo $_POST["time"]; ?>">
</table>

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
        else{
        hosts($host_array_vpv,"VipVisual");}
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
      <?php if($source=="vtr"){ echo "checked=\"yes\"";}?>  
      onClick="mainform.submit();"><?php echo "Graphite"; ?>
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
</form><!--GRAPHICS-->
<form id="graphicsform" name="graphicsform" method="POST" action="mail.php">
<table width="1270" height="130" border="0">
  <tr>
    <td width="1270" height="24" >
    <?php
    if($source=="vpv"&&sizeof($host_array_vpv)>1){
      //echo sizeof($host_array_vpv)." "."\$host_array_vpv";
      $host_array=$host_array_vpv;}
    if($source=="vtr"&&sizeof($host_array_vtr)>1){
      //echo sizeof($host_array_vtr)." "."\$host_array_vtr";
      $host_array=$host_array_vtr;}
    if($source=="dtb"&&sizeof($host_array_dtb)>1){
      //echo sizeof($host_array_vtr)." "."\$host_array_dtb";
      $host_array=$host_array_dtb;}
    $mail_st .="<table width=1170 border=0>\n";
    $mail_st .="<tr><td width=140 height=23>\n";
    $mail_st .="<strong>Comments:</strong></td>\n";
    $mail_st .="<td></td></tr></table>\n";
    if(isset($host_array)&&sizeof($host_array)>1){
    grafito($site,NULL,"analyzer",$time,$source,$host_array);
    }
    }else{
    echo "<td></br><strong>WARNING: No records found for this site</br>";
    echo "Please check documentation<A HREF=\"http://docs.gnmedia.net/wiki/NOC_Guide#Third_party_sites\"TARGET=\"_new\">Third party sites</A></strong></td>";}}
    ?>
  </td>
  </tr>
  <tr>    
</table>
    <input type="hidden" name="mail_st" value="<?php echo $mail_st; ?>">
    <input type="hidden" name="subject" value="<?php echo $subject; ?>">
    <input type="hidden" name="aaction" value="Mail Preview">
</form>
</div>
</body>
<?php database_close($mysql_link_r);  ?>
</html>
