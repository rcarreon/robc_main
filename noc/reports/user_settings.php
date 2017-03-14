<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">

<?php
{
  $debug_lvl = 0; /* Verbosity debug level */

  include("include/functions.inc");
  include("include/vars.inc");
  include("include/config.inc");
  include("include/mysql-connect.inc");
  date_default_timezone_set('America/Los_Angeles');
  //echo gethostname();

  $mysql_link_r = database_open($mysql_host, "r");

  if (!is_object($mysql_link_r)) {
    if ($debug_lvl>0)
      mysqli_connect_error();
    die("Cannot connect to the database");
  }

  if (isset($_COOKIE['nocreports_uname']))
    $user->name = $_COOKIE['nocreports_uname'];
  else
    $user->name = "jdoe";

  $user->getUserSettings($user->name, $mysql_link_r);  /* Get user settings */

  /* Select list for OrderBy field */
  $select_a = array(
                     "Sites" => "Site Name",
                     "LastTest" => "Time of the last check with an error",
                     "LastError" => "Time of the last \"Confirmed Down\" error",
                     "Status" => "Status (Confirmed Down/Unconfirmed Down)"
      );
}
?>

<html>
  <head>
		<meta http-equiv="content-type" content="text/html; charset=utf-8" />
		<title>NOC Reports - User settings</title>
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
                        background-color: #FFFF00!important;
                        cursor: pointer;
                        cursor: hand; }
                </style>
                <link href="css/menu.css" rel="stylesheet" type="text/css">
  </head>

<body id="dt_example">
<?php 
include("bodies/menu.bdy");

  $user->getUserSettings($user->name, $mysql_link_r);  /* Get user settings */

  if (isset($_POST["action"]) && $_POST["action"]=="save") {
    $mysql_link_w = database_open($mysql_host, "w");

    if (!is_object($mysql_link_w)) {
      if ($debug_lvl>0)
        mysqli_connect_error();
      die("Cannot connect to the database");
    }

    $user->showLastTestCol = isset($_POST["showLastTestCol"]);
    $user->showLastErrorCol = isset($_POST["showLastErrorCol"]);
    $user->showStatusCol = isset($_POST["showStatusCol"]);
    if (isset($_POST["sortBy"]))
      $user->sortBy = $_POST["sortBy"];
    if (isset($_POST["orderAsc"]))
      $user->orderAsc = $_POST["orderAsc"];
    if (isset($_POST["tableRows"])) {
      $user->tableRows = $_POST["tableRows"];
    }
    if (isset($_POST["incElapTime"])) {
      $user->incElapTime = $_POST["incElapTime"];
    }

    $setUserSuccess = $user->setUserSettings($mysql_link_w);
    if ($setUserSuccess == -1)
      $errorst_setUser = mysqli_error($mysql_link_w);

  }
?>
  <h1> Settings</h1>
  <h2>Incidents list</h2>
  <form action=<?php  printf("\"%s\"", $_SERVER['PHP_SELF']) ?> method="POST">
  <table border="0">
    <tr>
      <td>Show Last Test</td>
      <td><input type="checkbox" name="showLastTestCol" <?php if($user->showLastTestCol) echo "checked" ?>></td>
    </tr>
    <tr>
      <td>Show Last Error</td>
      <td><input type="checkbox" name="showLastErrorCol" <?php if($user->showLastErrorCol) echo "checked" ?>></td>
    </tr>
    <tr>
      <td>Show Status</td>
      <td><input type="checkbox" name="showStatusCol" <?php if($user->showStatusCol) echo "checked" ?>></td>
    </tr>
    <tr>
      <td>Sort By</td>
      <td>
         <select name="sortBy">
<?php
  while(list($idx, $text) = each($select_a)) {
    if ($user->sortBy == $idx)
      $is_selected = "selected";
    else
      $is_selected = "";

    printf("           <option value=\"%s\" %s>%s</option>\n", $idx, $is_selected, $text);
  }
?>
         </select>
      </td>
    </tr>
    <tr>
      <td>Order</td>
      <td>
        <select name="orderAsc">
          <option value="1">Asc</option>
          <option value="0"<?php if ($user->orderAsc==0) echo " selected"?>>Desc</option>
        </select>
      </td>
    </tr>
    <tr>
      <td>Lines per page</td>
      <td><input type="text" name="tableRows" value="<?php echo $user->tableRows ?>"></td>
    </tr>
    <tr>
      <td>Diference in minutes between incidents</td>
      <td><input type="text" name="incElapTime" value="<?php echo $user->incElapTime ?>"></td>
    </tr>
   </table>
  <input type="submit" value="Save">
  <input type="hidden" name="action" value="save">
  </form>
<?php

  if (isset($_POST["action"]) && $_POST["action"]=="save") {
    if ($setUserSuccess == 0)
      echo "User settings saved<br />\n";
    else {
      echo "Saving failed<br />\n";
      if ($debug_lvl>0)
        echo "MySQL error msg: $errorst_setUser<br />\n";
    }
  }

?>

</body>
</html>
