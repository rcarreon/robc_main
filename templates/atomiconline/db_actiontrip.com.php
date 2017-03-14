<?php

//############################################# SERVER CONFIGURATIONS ############################################
if ($_SERVER['SERVER_ADDR'] == '10.11.234.33') {                                                // DEV
        $dbconfig['host_read'] = 'localhost';
        $dbconfig['user_read'] = 'dejan';
        $dbconfig['pass_read'] = '<%= actiontripdevropw %>';
        $dbconfig['host_write'] = 'localhost';
        $dbconfig['user_write'] = 'dejan';
        $dbconfig['pass_write'] = '<%= actiontripdevrwpw %>';
        $dbconfig['db'] = 'atrip';
        $dbconfig['cdn'] = '';
        } else if (preg_match('@stg\.@', @$_SERVER['HTTP_HOST'])) {                             // STG
        $dbconfig['host_read'] = 'vip-sqlro-atp.ao.stg.lax.gnmedia.net';
        $dbconfig['user_read'] = 'atrip_r';
        $dbconfig['pass_read'] = '<%= actiontripstgropw %>';
        $dbconfig['host_write'] = 'vip-sqlrw-atp.ao.stg.lax.gnmedia.net';
        $dbconfig['user_write'] = 'atrip_w';
        $dbconfig['pass_write'] = '<%= actiontripstgrwpw %>';
        $dbconfig['db'] = 'atrip';
        $dbconfig['cdn'] = '';
        } else {                                                                                // PRD
        $dbconfig['host_read'] = 'vip-sqlro-atp.ao.prd.lax.gnmedia.net';
        $dbconfig['user_read'] = 'atrip_r';
        $dbconfig['pass_read'] = '<%= actiontripprdropw %>';
        $dbconfig['host_write'] = 'vip-sqlrw-atp.ao.prd.lax.gnmedia.net';
        $dbconfig['user_write'] = 'atrip_w';
        $dbconfig['pass_write'] = '<%= actiontripprdrwpw %>';
        $dbconfig['db'] = 'atrip';
        $dbconfig['cdn'] = 'http://www.cdn.actiontrip.com';
        }
