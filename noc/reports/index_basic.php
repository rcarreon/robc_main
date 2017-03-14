<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">

<?php
{
 $debug_lvl = 0; /* Verbosity debug level */

  include("include/functions.inc");
  include("include/vars.inc");
  include("include/config.inc");
  include("include/mysql-connect.inc");
  

  date_default_timezone_set('America/Los_Angeles');
  class incidentTableClass
  {
     var $site;
     var $lasttesttime; 
     var $down_timestamp;
     var $status;

     public function  __construct($site) {
       $this->site = $site;
     }
  }
  //echo gethostname();

  $max_inc_show = 300;
  $mysql_link_r = init();
  $a_inc_columns = array(
      "Sites" => 0,
      "LastTest" => 1,
      "LastError" => 2,
      "Status" => 3
   );

  if (!is_object($mysql_link_r)) {
    if ($debug_lvl>0)
      mysqli_connect_error();
    die("Cannot connect to the database");
  }

  //Order by lasttesttime with limit of results
  $query = "SELECT s.name as site, i.id, i.lasttesttime,i.down_timestamp, i.status, i.report_id, i.regrepeat FROM ";
  $query.= "rpt_sites s INNER JOIN rpt_incidents i ON s.id=i.site_id ";
  $query.= "ORDER BY lasttesttime DESC LIMIT $max_inc_show";

  //Order by down_timestamp all results
  //  $query = "SELECT s.name as site, i.down_timestamp as down_t FROM rpt_sites s INNER JOIN rpt_incidents i ON s.id=i.site_id ORDER BY down_timestamp";
 
  //Order by id with limit of results
  //  $query = "SELECT s.name as site, i.down_timestamp as down_t FROM rpt_sites s INNER JOIN rpt_incidents i ON s.id=i.site_id ORDER BY i.id DESC LIMIT $max_inc_show";

  $result = database_query($query, $mysql_link_r);
  //$result = database_query($query, $mysql_link_r);

  if (!$result) {
    if ($debug_lvl > 0)
      echo "query: #$query#\n\n";
    die('Could not query:' . mysqli_error($mysql_link_r));
  }
}
?>

  <html>
	<head>
<!--		<meta http-equiv="content-type" content="text/html; charset=utf-8" />
		<title>NOC Reports</title>
		<style type="text/css" title="currentStyle">
			@import "include/jq_dtables/media/css/demo_page.css"; 
			@import "include/jq_dtables/media/css/demo_table.css";
			@import "include/jq_dtables/media/css/ColReorder.css";
     			@import "include/jq_dtables/media/css/ColVis.css";

			.dataTables_wrapper tbody tr:hover {
                        background-color: #FFFF00!important;
                        cursor: pointer;
                        * cursor: hand;}

                        /*Search columns*/
			thead input { width: 100% }
                        input.search_init { color: #999 }

		</style>
		<script type="text/javascript" language="javascript" src="include/jq_dtables/media/js/jquery.js"></script>
		<script type="text/javascript" language="javascript" src="include/jq_dtables/media/js/jquery.dataTables.js"></script>
		<script type="text/javascript" language="javascript" src="include/jq_dtables/media/js/ColVis.js"></script>
		<script type="text/javascript" language="javascript" src="include/jq_dtables/media/js/ColReorder.js"></script>

		<script type="text/javascript" charset="utf-8">
			$(document).ready(function() { 

				/* When page loaded complete */
				/* Init DataTables */

				var oTable;
					

				oTable = $('#example').dataTable({


					//"sDom": 'C<"clear">lfrtip',
					//"oColVis": {
					//"aiExclude": [ 0 ]
					//},
	
					//Code Search individual


					//Code Dynamic Colums appear
					//"sDom": 'RC<"clear">lfrtip',
					//"aoColumnDefs": [
					//	{ "bVisible": false, "aTargets": [ 2 ] }
					//],
					//"oLanguage": {
					//	"sSearch": "Search all columns:"
					//},
					//"bSortCellsTop": true,
					
					//Code Default Config			
					//"aLengthMenu": [[10, 50, 100, 200, -1], [10, 50, 100, 200, "All"]],
					//iDisplayLength: <?php echo $user->tableRows ?>,
					//"bSortClasses": false,
					"aaSorting": [[ 1, "desc" ]]
				});

				/* Add events */
				//$('#example tbody tr').live('click', function () {
  				//-Basic Model
				//-$('#example').dataTable( {
   				//-	"bPaginate": false,
    				//-	"bSort": false
  				//-} );		
					//var sMsg;
					var nTds = $('td', this);
					var sSite = $(nTds[0]).text();
					var sLasttest = $(nTds[1]).text();					
					var sDown_t = $(nTds[2]).text();
					var sStatus = $(nTds[3]).text();
					//$site="<script> sSite <script>";
                                        //$down_t_alert="<script> sdown_timestamp <script>";
					//sMsg = sSite;
					//alert( sSite )
					//document.location.href ="report.php?site="+sSite+"&down_t_alert="+sLasttest
				//} );
			} );
		</script>
	</head>
	
	<body id="dt_example">
	
	<script type="text/javascript">
	//(function(){
  	//var bsa = document.createElement('script');
     	//bsa.type = 'text/javascript';
     	//bsa.async = true;
     	//bsa.src = '//s3.buysellads.com/ac/bsa.js';
  	//(document.getElementsByTagName('head')[0]||document.getElementsByTagName('body')[0]).appendChild(bsa);
	//})();
	</script>


	<div id="container">
	<table width="1027" border="0">
  	<tr>
    		<td width="378">
        	<div class="full_width big"><strong>
                NOC REPORTS
        	</strong></div>
		</td>
		<td width="182"><strong>Status:</strong>
    		<?php
      		if(checkPrc()){
        		echo "Online";}
      		else{
        		echo "Offline";}
    		?>
      		<form action="site.php">
        	<input type="Submit" value="Visual Grafito®">
      		</form>
    		</td>
  	</tr>
	</table>
-->

<div id="container">
<body id="dt_example">

	<div id="demo">
	<table cellpadding="0" cellspacing="0" border="0" class="display" id="example">
	<thead>
		<tr>
			<th>Site</th>
			<th>LastTest</th>
			<th>LastError</th>
			<!--<th>Recovery Time</th>-->
			<th>Repeat</th>
         <th>&nbsp;&nbsp;&nbsp;Status&nbsp;&nbsp;&nbsp;&nbsp;</th>
         <th>DowntimeReport</th>
			<th>UptimeReport</th>
		<!--<th>Report</th>
		<th>Engine version</th>
		<th>CSS grade</th>
		</tr>
		<tr>
			<td><input type="text" name="search_engine" value="Search engines" class="search_init" /></td>
			<td><input type="text" name="search_browser" value="Search browsers" class="search_init" /></td>
			<td><input type="text" name="search_platform" value="Search platforms" class="search_init" /></td>
			<td><input type="text" name="search_version" value="Search versions" class="search_init" /></td>
		</tr>-->
	</thead>
	<tbody>
  <?php
  while($tr_incidents = database_fetch_array($result)) {
	echo '<tr>';
        	echo '<form name="forma" action="report.php" method="get">';
		echo '<td>'.$tr_incidents["site"].'</td>';
		echo '<td>'.date('m/d/Y h:i:s a', $tr_incidents["lasttesttime"]).'</td>';
		echo '<td>'.date('m/d/Y h:i:s a', $tr_incidents["lasttesttime"]).'</td>';
		echo '<td align="center">'.$tr_incidents["regrepeat"].'</td>';		
        
        $status_st='<td><img src="images/';
		if($tr_incidents["status"]=="down"){	$status_st=$status_st.'critical.png">Critical';}
		if($tr_incidents["status"]=="unconfirmed_down"){	$status_st=$status_st.'warning.png">Warning';}
		if($tr_incidents["status"]==null){	$status_st=$status_st.'critical.png">Critical';}
		$status_st=$status_st.'</td>';
		echo $status_st;$status_st="";

        if($tr_incidents["report_id"]!=0){		
		$list=gettimes($tr_incidents["report_id"],$mysql_link_r);
        //echo " \$list= ".$list;
        list($downtime, $uptime) = explode("#", $list);
        //$downtime=intval($downtime);$uptime=intval($uptime);
	    //echo "\$downtime".$downtime;echo "\$uptime".$uptime;
		if($downtime!=" "&&$uptime!=" "){
		echo '<td>'.date('m/d/Y h:i:s a', $downtime).'</td>';
		echo '<td>'.date('m/d/Y h:i:s a', $uptime).'</td>';}
        }
        
		//echo '<input type="hidden" name="site" value=" ">';
                //echo '<input type="hidden" name="down_t_alert" value=" "></td>';
		echo '</form>';	
	
		//echo '<td><input type="button" onClick="parent.location=\'report.php\'" value="Report"></td>';
		//echo '<td><input de="submit" name="submit" method="get" action="report.php"></td>';
		//echo '<input type="hidden" name="site" id="site" value="" >
		//echo '<td> <button type="submit"><b>Boton</b></button></td>';
		//echo '<td> <input type="image" src="images/images.jpg" name="submit" value="Report"> </td>'; 
	echo '</tr>';
   }
   ?>
	</tbody>
	<tfoot>
		<tr>
			<th>Site</th>
			<th>LastTest</th>
         <th>LastError</th>
			<!--<th>Recovery Time</th>-->
         <th>Repeat</th>
         <th>   Status   </th>
         <th>DowntimeReport</th>
			<th>UptimeReport</th>
		</tr>
	</tfoot>
  </table>
  </body>
  </html>
