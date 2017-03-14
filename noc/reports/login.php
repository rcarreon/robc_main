<?php
{
  $debug_lvl = 0; /* Verbosity debug level */

  include("include/functions.inc");
  include("include/vars.inc");
  include("include/config.inc");
  include("include/mysql-connect.inc");
  date_default_timezone_set('America/Los_Angeles');
  //echo gethostname();

  $ldapconn = 0;
  $ldapbind = 0;

  if (isset($_POST["action"]) && $_POST["action"]=="login") {

     $ldaphost="app1v-ldap.tp.prd.lax.gnmedia.net";
     $ldapport=389;

     $ldapconn = ldap_connect($ldaphost, $ldapport);

     if ($ldapconn) {

       $dn = "uid=" . $_POST["userName"] . ",ou=People,dc=gnmedia,dc=net";
       $ldapbind = @ldap_bind($ldapconn, $dn, $_POST["userPasswd"]);

       if ($ldapbind) 
       {

	 $sr=ldap_search($ldapconn, "ou=People,dc=gnmedia,dc=net", "uid=". $_POST["userName"]);
         $info = ldap_get_entries($ldapconn, $sr);

         /* Auto add a new user */
         /* This code will fail if there are two users with the same userName */
         /* based in that you can't have a two users with the same name on ldap */
         $query = "SELECT COUNT(name) AS num FROM rpt_user WHERE name = \"". $_POST["userName"]. "\"";
         $query2= "SELECT * FROM rpt_user WHERE name = \"". $_POST["userName"]. "\"";
         $mysql_link_r = init();
         $result = database_query($query, $mysql_link_r);
	 $result2= database_query($query2, $mysql_link_r);

         //print_r ($result);
         $row = mysqli_fetch_array($result);
	 $raw= mysqli_fetch_array($result2);

         $count = $row["num"];
	 $fname = $raw['fullname'];
         
         if ($fname != $info[0]["cn"][0])
          { 
            $query = "UPDATE rpt_user set fullname=\"".$info[0]["cn"][0]."\" WHERE name=\"". $_POST["userName"]. "\""; 
            
            $mysql_link_w = database_open($mysql_host, "w");
              if (!is_object($mysql_link_w)) {
                if ($debug_lvl>0)
                  mysqli_connect_error();
                die("Cannot connect to the database");
                }
            database_query($query, $mysql_link_w);
          }

         if (!$count)
         {
           $mysql_link_w = database_open($mysql_host, "w");
           if (!is_object($mysql_link_w)) {
             if ($debug_lvl>0)
             mysqli_connect_error();
             die("Cannot connect to the database");
           }

	  $query = "INSERT INTO rpt_user (name, showLastTestCol, showLastErrorCol, showStatusCol, sortBy, orderAsc, tableRows, incElapTime, fullname) VALUES (\"".$_POST["userName"]."\", 1, 1, 1, \"LastTest\", 0, 15, -1, \"". $info[0]["cn"][0] ."\")";

           database_query($query, $mysql_link_w);
         }
         /* End of auto add new user */
         setcookie("nocreports_uname", $_POST["userName"], 0);
       }
     } 
  }

  $mysql_link_r = init();

  if (!is_object($mysql_link_r)) {
    if ($debug_lvl>0)
      mysqli_connect_error();
    die("Cannot connect to the database");
  }

  /* Select list for OrderBy field */
  $select_a = array(
                     "Sites" => "Site Name",
                     "LastTest" => "Time of the last check with an error",
                     "LastError" => "Time of the last \"Confirmed Down\" error",
                     "Status" => "Status (Confirmed Down/Unconfirmed Down)"
      );
}
?>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">

<html>
  <head>
<?php
  if ($ldapconn && $ldapbind) {
?>
    <meta http-equiv="REFRESH" content="2;url=index.php">
  </head>
</html>
<?php
  } else {
?>

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
?>
  <h1>Login</h1>
  <form action="login.php" method="POST">
  <table border="0">
    <tr>
      <td>Username:</td>
      <td><input type="text" name="userName"></td>
    </tr>
    <tr>
      <td>Password</td>
      <td><input type="password" name="userPasswd"></td>
    </tr>
   </table>
  <input type="submit" value="Login">
  <input type="hidden" name="action" value="login">
  </form>

<?php
  if (isset($_POST["action"]) && $_POST["action"]=="login") {

    if ($ldapconn) {
      if ($ldapbind)
        echo "Login successful...\n";
      else {
        echo "Login failed...\n";
        if ($debug_lvl>0) {
          echo "LDAP bind failed...<br />\n" . ldap_error($ldapconn);
          echo "<br />\n$dn<br />\n";
        }
      }
    } else
       echo "Could not connect to LDAP server";
  }
  database_close($mysql_link_r);
  database_close($mysql_link_w);
  ldap_unbind($ldapconn);
?>

</body>
</html>
<?php
}
?>
