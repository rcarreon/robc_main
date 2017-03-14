<?php
$debug_lvl = 0; /* Verbosity debug level */

include("../include/functions.inc");
include("../include/vars.inc");
include("../include/config.inc");
include("../include/mysql-connect.inc");
date_default_timezone_set('America/Los_Angeles');

$mysql_link_r = database_open($mysql_host, "w");

if (!is_object($mysql_link_r)) {
	if ($debug_lvl>0)
		mysqli_connect_error();
	die("Cannot connect to the database");
}

if (isset($_COOKIE['nocreports_uname'])) {
	$user = $user->getUserSettings($_COOKIE['nocreports_uname'], $mysql_link_r);
} else {
	$user->name = "jdoe";
}

/*
 * This function returns the list of rpt_users to use as user select options
 * @params is_search BOOL if true use logged in user as default user, if false ignore
 * @returns option string
 */
function getUsersOptions($is_search = false) {
	global $mysql_link_r;
	global $user;

	$sql_users = 'SELECT id, name FROM rpt_user ORDER BY name';
	$q_users   = database_query($sql_users, $mysql_link_r);
	$option    = '';

	while ($row = database_fetch_array($q_users)) {
		if ($user->id == $row['id'] && $is_search) {
			$option .= '<option value="'.$row['id'].'" selected="selected">'.$row['name'].'</option>';
		} else {
			$option .= '<option value="'.$row['id'].'">'.$row['name'].'</option>';
		}
	}

	return $option;
}

/*
 * This function returns all the puppet errors in the database.
 */
function getAll() {
	global $mysql_link_r;

	$sql = "SELECT p.*, u.name FROM puppet_errors p LEFT JOIN rpt_user u ON p.resolved_by = u.id ORDER BY error_date DESC, error_time DESC";
	$q = database_query($sql, $mysql_link_r);
	while ($row = database_fetch_object($q)) {
	?>
		<tr>
			<td><?php echo date('m/d/Y H:i:s', strtotime($row->error_date.' '.$row->error_time)); ?></td>
			<td><?php echo $row->host_name; ?></td>
			<td><?php echo $row->centos_os; ?></td>
			<td><?php echo $row->action; ?></td>
			<td><?php echo $row->name; ?></td>
		</tr>
	<?php }
}
