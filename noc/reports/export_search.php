<?php

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

include("include/functions.inc");
include("include/vars.inc");
include("include/config.inc");
include("include/mysql-connect.inc");

header("Content-type: application/octet-stream");
header("Content-Disposition: attachment; filename=nocreports.xls");
header("Pragma: no-cache");
header("Expires: 0");

$max_inc_show = 300;

$query = $_POST["query"];

$mysql_link_r = init();

$result = database_query($query, $mysql_link_r);

$i=0;
$iresult=array();
$table_text = "<table cellpadding='4' cellspacing='0' border='1'>
		<thead>
			<tr>
				<th>Site</th>
				<th>LastTest</th>
				<th>LastError</th>
				<th>&nbsp;&nbsp;&nbsp;Status&nbsp;&nbsp;&nbsp;&nbsp;</th>
			</tr>
		</thead>";

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
		$table_text .= '<tr>';
		$table_text .= '  <td>'.$isite.'</td>';
		$table_text .= '  <td>'.date('m/d/Y h:i:s a', $ilasttesttime).'</td>';
		$table_text .= '  <td>'.date('m/d/Y h:i:s a', $idown_timestamp).'</td>';
		$table_text .= "<td>";
		switch($istatus)
		{
			case "unconfirmed_down":
				$table_text .= "Warning</td>\n";
				break;
			case "down":
			default:
				$table_text .= "Critical</td>\n";
		}
	}

	$table_text .= '</tr>';
	$i++;
	$ii++;
}

$table_text .= '</table>';

echo $table_text;