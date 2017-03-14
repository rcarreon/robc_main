<?php
// #### This file is managed by Puppet, do not modify it directly.


//Database Master config
$config['db']['host'] = 'localhost';
$config['db']['port'] = '3306';
$config['db']['username'] = 'forums_ae_w';
$config['db']['password'] = '<%= uidpbxf_forums_aerw %>';
$config['db']['dbname'] = 'forums_ae';


//Database Slave config
$config['db']['adapterNamespace'] = 'DigitalPoint';
$GLOBALS['digitalPoint']['SlaveServerAll'][] = 'localhost';
$GLOBALS['digitalPoint']['SlaveUsername'] = 'forums_ae_r';
$GLOBALS['digitalPoint']['SlavePassword'] = '<%= uidpbxf_forums_aero %>';
$GLOBALS['digitalPoint']['SlaveDBname']   = 'forums_ae';
$GLOBALS['digitalPoint']['SlaveDBPort']   = '3306';


//CDN-Akamai config
$config['externalDataUrl'] = 'http://cdn1-sbx.forums.afterellen.com/data';
$config['javaScriptUrl'] = 'http://cdn1-sbx.forums.afterellen.com/js';


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
