<?php
// #### This file is managed by Puppet, do not modify it directly.


//Database Master config
$config['db']['host'] = 'localhost';
$config['db']['port'] = '3306';
$config['db']['username'] = 'forums_wz_w';
$config['db']['password'] = '<%= uidpbxf_forums_wzrw %>';
$config['db']['dbname'] = 'forums_wz';


//Database Slave config
$config['db']['adapterNamespace'] = 'DigitalPoint';
$GLOBALS['digitalPoint']['SlaveServerAll'][] = 'localhost';
$GLOBALS['digitalPoint']['SlaveUsername'] = 'forums_wz_r';
$GLOBALS['digitalPoint']['SlavePassword'] = '<%= uidpbxf_forums_wzro %>';
$GLOBALS['digitalPoint']['SlaveDBname']   = 'forums_wz';
$GLOBALS['digitalPoint']['SlaveDBPort']   = '3306';


//CDN-Akamai config
$config['externalDataUrl'] = 'http://cdn1-sbx.forums.wrestlezone.com/data';
$config['javaScriptUrl'] = 'http://cdn1-sbx.forums.wrestlezone.com/js';


//Memcache config
$config['cache']['enabled'] = true;
$config['cache']['backend'] = 'Memcached';
$config['cache']['cacheSessions'] = true;
$config['cache']['backendOptions'] = array(
                'compression' => false,
                'servers' => array(
                                array(
                                                'host' => 'localhost',
                                                'port' => 11211
                                     ),
                                  )
);
