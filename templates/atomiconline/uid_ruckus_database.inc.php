<?php
// #### This file is managed by Puppet, do not modify it directly.
// #### $Id: uid_ruckus_database.inc.php 16906 2012-05-15 01:34:29Z mdillon $


//----------------------------
// DATABASE CONFIGURATION
//----------------------------

$ruckusing_db_config = array(

    'development' => array(
        'type'      => 'mysql',
        'host'      => 'localhost',
        'port'      => 3306,
        'user'      => 'ruckus',
        'password'  => '<%= uidpbwpruckus %>'
    ),

);


?>
