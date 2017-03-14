<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">

<?php

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
	"Status" => 3,
	"reportid" => 3
);

if (!is_object($mysql_link_r)) {
	if ($debug_lvl>0)
		mysqli_connect_error();
	die("Cannot connect to the database");
}

$query = "SELECT * FROM (";                          //down_timestamp=lasterror column
$query.= "SELECT s.name as site, i.lasttesttime,i.down_timestamp, i.status, i.report_id FROM ";
$query.= "rpt_sites s INNER JOIN rpt_incidents i ON s.id=i.site_id ";

//check within a time frame.
if(!empty($_POST['start-date']) && !empty($_POST['end-date'])){
	$start_date = date('U', strtotime($_POST['start-date']));
	$end_date = date('U', strtotime($_POST['end-date']));

	$query.= "WHERE i.lasttesttime BETWEEN  '$start_date' AND '$end_date' ";
}

$query.= "ORDER BY lasttesttime DESC LIMIT $max_inc_show";

$query.= ") l ORDER BY l.site ASC, l.lasttesttime DESC";

$result = database_query($query, $mysql_link_r);

if (!$result) {
	if ($debug_lvl > 0)
		echo "query: #$query#\n\n";
	die('Could not query:' . mysqli_error($mysql_link_r));
}

?>

<html>
<head>
	<meta http-equiv="content-type" content="text/html; charset=utf-8" />
	<title>NOC Reports</title>
	<style type="text/css">
		@import "css/main.css";
	</style>
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

	<!--Datatables*/-->
	<script type="text/javascript" language="javascript" src="include/jq_dtables/media/js/jquery.js"></script>
	<script type="text/javascript" language="javascript" src="include/jq_dtables/media/js/jquery.dataTables.js"></script>
	<script type="text/javascript" language="javascript" src="include/jq_dtables/media/js/ColVis.js"></script>
	<script type="text/javascript" language="javascript" src="include/jq_dtables/media/js/ColReorder.js"></script>

	<!-- added this in for datepickers -->
	<link rel="stylesheet" href="http://code.jquery.com/ui/1.10.3/themes/smoothness/jquery-ui.css" />
	<script src="http://code.jquery.com/ui/1.10.3/jquery-ui.js"></script>

	<script type="text/javascript" charset="utf-8">
		$(document).ready(function() {

			$("#start-date").datepicker({dateFormat: "yy-mm-dd"});
			$("#end-date").datepicker({dateFormat: "yy-mm-dd"});

			/* When page loaded complete */
			/* Init DataTables */

			var oTable;
			/* Code SEARCH individual Columns*/
			/* Add the events etc before DataTables hides a column */
			$("thead input").keyup( function () {
				/* Filter on the column (the index) of this element */
				oTable.fnFilter( this.value, oTable.oApi._fnVisibleToColumnIndex(
					oTable.fnSettings(), $("thead input").index(this) ) );
			} );

			/*
											 * Support functions to provide a little bit of 'user friendlyness' to the textboxes
											 */
			$("thead input").each( function (i) {
				this.initVal = this.value;
			} );

			$("thead input").focus( function () {
				if ( this.className == "search_init" )
				{
					this.className = "";
					this.value = "";
				}
			} );

			$("thead input").blur( function (i) {
				if ( this.value == "" )
				{
					this.className = "search_init";
					this.value = this.initVal;
				}
			} );

			oTable = $('#example').dataTable({

				//Code DINAMIC COLUMN Appear
				"sDom": 'RC<"clear">lfrtip',
				"aoColumnDefs": [
				<?php printf("{ \"bVisible\": %b, \"aTargets\": [ %d ] },\n", $user->showLastTestCol, $a_inc_columns["LastTest"]); ?>
				<?php printf("{ \"bVisible\": %b, \"aTargets\": [ %d ] },\n", $user->showLastErrorCol, $a_inc_columns["LastError"]); ?>
				<?php printf("{ \"bVisible\": %b, \"aTargets\": [ %d ] }\n", $user->showStatusCol, $a_inc_columns["Status"]); ?>
					//{ "bVisible": false, "aTargets": [ 2 ] }

				],
				"oLanguage": {
					"sSearch": "Search all columns:"
				},
				"bSortCellsTop": true,

				//Code DEFAULT Config
				"aLengthMenu": [[10, 15, 50, 100, 200, -1], [10, 15, 50, 100, 200, "All"]],
				"iDisplayLength": <?php echo $user->tableRows ?>,
				"bSortClasses": false,
				"aaSorting": <?php
			if ($user->orderAsc == 0)
				$sortOrder = "desc";
			else
				$sortOrder = "asc";
			printf("[[ %d, \"%s\" ]]\n", $a_inc_columns[$user->sortBy], $sortOrder);
			?>
			});

			/* Add events */
			$('#example tbody tr').live('click', function () {
				//-Basic Model
				//-$('#example').dataTable( {
				//-	"bPaginate": false,
				//-	"bSort": false
				//-} );
				//-var sMsg;
				var nTds = $('td', this);
				var sSite = $(nTds[<?php echo $colNum_site ?>]).text();
				var sLasttest = $(nTds[<?php echo $colNum_lastTest?>]).text();
				var sDown_t = $(nTds[<?php echo $colNum_lastError ?>]).text();
				var sStatus = $(nTds[<?php echo $colNum_status ?>]).text();
				//var wtf = sLasttest;
				//sMsg = sSite;
				//alert( sSite )
				document.location.href ="report.php?site="+sSite+"&down_lasttest="+sLasttest
			} );

			$("#export-xls").click(function (e) {
				var query = "<?php echo $query; ?>";
				$("#query").val(query);

				$("#frmReportsSearch").attr("action", "export_search.php");
				$("#frmReportsSearch").submit();
			});

		} );
	</script>
	<link href="css/menu.css" rel="stylesheet" type="text/css">
</head>

<div id="container">
	<body id="dt_example">
	<?php include ("bodies/menu.bdy"); ?>
	<form id="frmReportsSearch" method="post">
		<div id="search-section">
			<div style="float: left; width: 25%;">Start Date: <input type="text" id="start-date" name="start-date" style="width: 100px;"></div>
			<div style="float: left; width: 25%;">End Date: <input type="text" id="end-date" name="end-date" style="width: 100px;"></div>
			<div style="float: left; width: 25%;"><input class="ColVis_Button-right" type="submit" id="search-date" value="Search By Date"></div>
			<div style="float: right; width: 25%; text-align: right">
				<input class="ColVis_Button-right" type="button" id="export-xls" value="Export Results to Excel">
				<input type="hidden" id="query" name="query" value="">
			</div>
		</div>
	</form>
	<table cellpadding="0" cellspacing="0" border="0" class="display" id="example">
		<thead>
		<tr>
			<th>Site</th>
			<th>LastTest</th>
			<th>LastError</th>
			<th>&nbsp;&nbsp;&nbsp;Status&nbsp;&nbsp;&nbsp;&nbsp;</th>
		</tr>
		</thead>
		<thead>
		<tr>
			<td><input type="text" name="search_engine" value="Search Sites" class="search_init" /></td>
			<td><input type="text" name="search_browser" value="Search LastTest" class="search_init" /></td>
			<td><input type="text" name="search_platform" value="Search LastError" class="search_init" /></td>
			<td><input type="text" name="search_version" value="Search Status" class="search_init" /></td>
		</tr>
		</thead>

		<tbody>
		<?php
		/*
			  while($tr_incidents = database_fetch_array($result)) {
				  echo '<tr>';
				  echo '<form name="forma" action="report.php" method="get">';
				  echo '  <td>'.$tr_incidents["site"].'</td>';
			  echo '  <td>'.date('m/d/Y h:i:s a', $tr_incidents["lasttesttime"]).'</td>';
			  echo '  <td>'.date('m/d/Y h:i:s a', $tr_incidents["down_timestamp"]).'</td>';
				  switch($tr_incidents["status"]) {
					case "unconfirmed_down":
					  echo "  <td><img src=\"$img_dir/$warning_icon\">Warning</td>\n";
					  break;
					case "down":
					default:
					  echo "  <td><img src=\"$img_dir/$critical_icon\">Critical</td>\n";
				  }
			  echo "</form>\n";
			  echo '</tr>';
			   }
				*/
		?>
		<?php
		$i=0;
		$iresult=array();
		while ($tr_incidents = database_fetch_array($result))
		{
			$iresult[$i] = new incidentTableClass($tr_incidents["site"]);
			$iresult[$i]->lasttesttime = $tr_incidents["lasttesttime"];
			$iresult[$i]->down_timestamp = $tr_incidents["down_timestamp"];
			$iresult[$i]->status = $tr_incidents["status"];
			$iresult[$i]->report_id = $tr_incidents["report_id"];
			$i++;
		}

		$num=mysqli_num_rows($result);

		$i=0;
		$ii=1;

		while($i<$num)
		{
			$isite=$iresult[$i]->site;
			$ilasttesttime=$iresult[$i]->lasttesttime;
			$idown_timestamp=$iresult[$i]->down_timestamp;
			$istatus=$iresult[$i]->status;
			$ireport_id=$iresult[$i]->report_id;

			if ($ii != $num)
			{
				$iisite=$iresult[$ii]->site;
				$iilasttesttime=$iresult[$ii]->lasttesttime;
				$iidown_timestamp=$iresult[$ii]->down_timestamp;
				$iistatus=$iresult[$ii]->status;
				$iireport_id=$iresult[$ii]->report_id;
			}
			$iitime=$ilasttesttime - $user->incElapTime *60;

			if ($isite==$iisite && $iitime<=$iilasttesttime && $ii != $num) //using this form instead the other below, we can filter rows with the same values
			{

			}
			else
			{
				echo '<tr class="example_row">';
				echo '<form name="forma" action="report.php" method="get">';
				echo '  <td>'.$isite.'</td>';
				echo '  <td>'.date('m/d/Y h:i:s a', $ilasttesttime).'</td>';
				echo '  <td>'.date('m/d/Y h:i:s a', $idown_timestamp).'</td>';

				$flg_icon=report_icon($ireport_id,$mysql_link_r);//if register exists in rpt_report as UP will show report icon
				if($flg_icon){ $ready_rpt="<img src=\"$img_dir/$report_icon\">";}
				else{ $ready_rpt="";}

				echo "<td>".$ready_rpt;
				switch($istatus)
				{
					case "unconfirmed_down":
						echo "<img src=\"$img_dir/$warning_icon\">Warning</td>\n";
						break;
					case "down":
					default:
						echo "<img src=\"$img_dir/$critical_icon\">Critical</td>\n";
				}
			}
			echo "</form>\n";
			echo '</tr>';
			$i++;
			$ii++;
		}
		?>
		</tbody>
		<tfoot>
		<tr>
			<th>Site</th>
			<th>LastTest</th>
			<th>LastError</th>
			<th>&nbsp;&nbsp;&nbsp;Status&nbsp;&nbsp;&nbsp;&nbsp;</th>
		</tr>
		</tfoot>
	</table>
</div>
<table>
	<strong>System Status:</strong>
	<?php
	if(checkPrc()){
		echo "Online";}
	else{
		echo "Offline";}
	?>
</table>
</body>
</div>
</html>