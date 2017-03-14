#!/usr/bin/php
<?php
    date_default_timezone_set('America/Los_Angeles');
    ini_set('memory_limit','256M');
    require_once("dbcode_monitor.php");

    $db_server = new DBManager();
    $sql_access = array (
                         'host' => 'sql1v-56-dbops.tp.prd.lax.gnmedia.net',
                         'dbname' => 'db_system',
                         'user' => 'dbops',
                         'password' => 'ZXZvbHZlZ2VuaXVzOTg3'
                        );    

    try{
        $db_server->connect($sql_access);
        $query = sprintf("SELECT hostname, monitor_interval
                          FROM db_system.dbcode_monitor
                          WHERE (executed_at + monitor_interval) < UNIX_TIMESTAMP()");
        $hosts = $db_server->execute($query);

    }
    catch  (Exception $e){
        $db_server->close_connection();
        die();
    }

    foreach ($hosts as $hostentry) {
        MainProcess::main($hostentry["hostname"], $hostentry["monitor_interval"]);
        $query = sprintf("UPDATE db_system.dbcode_monitor SET executed_at = UNIX_TIMESTAMP()
                          WHERE hostname = '%s'", $hostentry["hostname"]);
        $db_server->execute($query);
    }

    $db_server->close_connection();

?>