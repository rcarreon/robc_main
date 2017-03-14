<?php
// #### This file is managed by Puppet, do not modify it directly.

        //      ****** MASTER DATABASE SERVER NAME AND PORT ******
        //      This is the hostname or IP address and port of the database server.
        //      If you are unsure of what to put here, leave the default values.
$config['MasterServer']['servername'] = 'sql1v-vb-shh.ao.dev.lax.gnmedia.net';
$config['MasterServer']['port'] = 3306;

        //      ****** MASTER DATABASE USERNAME & PASSWORD ******
        //      This is the username and password you use to access MySQL.
        //      These must be obtained through your webhost.
$config['MasterServer']['username'] = 'forums_shh_w';
$config['MasterServer']['password'] = '<%= dev_vb_shhrw %>';

        //      ****** MASTER DATABASE PERSISTENT CONNECTIONS ******
        //      This option allows you to turn persistent connections to MySQL on or off.
        //      The difference in performance is negligible for all but the largest boards.
        //      If you are unsure what this should be, leave it off. (0 = off; 1 = on)
$config['MasterServer']['usepconnect'] = 0;



        //      ****** SLAVE DATABASE CONFIGURATION ******
        //      If you have multiple database backends, this is the information for your slave
        //      server. If you are not 100% sure you need to fill in this information,
        //      do not change any of the values here.
$config['SlaveServer']['servername'] = 'sql1v-vb-shh.ao.dev.lax.gnmedia.net';
$config['SlaveServer']['port'] = 3306;
$config['SlaveServer']['username'] = 'forums_shh_r';
$config['SlaveServer']['password'] = '<%= dev_vb_shhro %>';
$config['SlaveServer']['usepconnect'] = 0;
