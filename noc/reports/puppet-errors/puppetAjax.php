<?php
include("../include/config.inc");
include("../include/mysql-connect.inc");

$mysql_link_r = database_open($mysql_host, "w");

if (!is_object($mysql_link_r)) {
	if ($debug_lvl>0)
		mysqli_connect_error();
	die("Cannot connect to the database");
}
/////////	SEARCH
if (!empty($_GET['searchErrors'])) {
	$start_date = $_GET['start_date'];
	$end_date   = $_GET['end_date'];
    $host       = $_GET['host'];
    $user       = $_GET['user'];
    $centos     = $_GET['centos'];

	$SQL = "SELECT p.*, u.name FROM puppet_errors p LEFT JOIN rpt_user u ON p.resolved_by = u.id WHERE 1";

	if (!empty($start_date)) {
		$SQL .= " AND error_date >= '$start_date'";
	}
	if (!empty($end_date)) {
		$SQL .= " AND error_date <= '$end_date'";
	}
	if (!empty($host)) {
		$SQL .= " AND host_name = '$host'";
	}
	if (!empty($user)) {
		$SQL .= " AND resolved_by = $user";
	}
	if (!empty($centos)) {
		$SQL .= " AND centos_os = '$centos'";
	}

	$SQL .= " ORDER BY error_date DESC, error_time DESC";

	//echo $SQL;

	$q = database_query($SQL, $mysql_link_r);

	$arr_rows = array();

	while ($row = database_fetch_array($q)) {
		$arr_rows[] = array(
			'error_date' => date("m/d/Y H:i:s", strtotime($row['error_date'].' '.$row['error_time'])),
			'host_name'  => $row['host_name'],
			'centos_os'  => $row['centos_os'],
			'action'     => $row['action'],
			'name'       => $row['name']
		);
	}

	$json = json_encode($arr_rows);

	echo $json;
}

/////////	GET ALL ROWS
if (!empty($_GET['getALl'])) {

	$SQL = "SELECT p.*, u.name FROM puppet_errors p LEFT JOIN rpt_user u ON p.resolved_by = u.id ORDER BY error_date DESC, error_time DESC";

	$q = database_query($SQL, $mysql_link_r);

	$arr_rows = array();

	while ($row = database_fetch_array($q)) {
		$arr_rows[] = array(
			'id' => $row['id'],
			'error_date' => date("m/d/Y H:i:s", strtotime($row['error_date'].' '.$row['error_time'])),
			'host_name'  => $row['host_name'],
			'centos_os'  => $row['centos_os'],
			'action'     => html_entity_decode($row['action'], ENT_COMPAT, "UTF-8"),
			'name'       => $row['name']
		);
	}

	$json = json_encode($arr_rows);

	echo $json;
}

/////////	AUTOCOMPLETE
if (!empty($_GET['hostAutocomplete'])) {
	$host = $_GET['term'];
	$SQL_ = "SELECT DISTINCT host_name FROM puppet_errors WHERE host_name LIKE '%".$host."%'";
	$q = database_query($SQL_, $mysql_link_r);

	$arr_host = array();

	while ($row = database_fetch_array($q)) {
		$arr_host[] = array(
			"id" => $row['host_name'],
			"label" => $row['host_name'],
			"value" => $row['host_name'],
		);
	}

	$json = json_encode($arr_host);

	echo $json;
}

/////////	ADD NEW ROW
if (!empty($_GET['newPuppetError'])) {
	//add new puppet error here.
	$error_date  = $_GET['error_date'];
	$error_time  = $_GET['error_time'];
	$host_name   = $_GET['host_name'];
	$centos_os   = $_GET['centos'];
	$action      =  htmlentities($_GET['action'], ENT_COMPAT, "UTF-8");
	$resolved_by = $_GET['user'];

	$sql_duplicate = "SELECT COUNT(DISTINCT id) AS totalRows FROM puppet_errors WHERE error_date = '$error_date' AND error_time ='$error_time' AND host_name='$host_name'";
	$q_duplicate   = database_query($sql_duplicate, $mysql_link_r);
	$row           = database_fetch_row($q_duplicate);

	if ($row[0] > 0) {	//theres a duplicate row
		echo "duplicate";
		return false;
	}

	$sql = "INSERT INTO puppet_errors (error_date, error_time, host_name, centos_os, action, resolved_by) VALUES ('$error_date', '$error_time', '$host_name', '$centos_os', '$action', '$resolved_by')";
	$q = database_query($sql, $mysql_link_r);

	if ($q) {
		echo 'ok';
	}
}