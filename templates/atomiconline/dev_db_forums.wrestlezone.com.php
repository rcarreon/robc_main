<?php
// #### This file is managed by Puppet, do not modify it directly.


//Database Master Config
$config['db']['host'] = 'vip-sqlrw-xf-wz.ao.dev.lax.gnmedia.net';
$config['db']['port'] = '3306';
$config['db']['username'] = 'forums_wz_w';
$config['db']['password'] = '<%= devpbxf_forums_wzrw %>';
$config['db']['dbname'] = 'forums_wz';


//Database Slave config
$config['db']['adapterNamespace'] = 'DigitalPoint';
$GLOBALS['digitalPoint']['SlaveServerAll'][] = 'vip-sqlro-xf-wz.ao.dev.lax.gnmedia.net';
$GLOBALS['digitalPoint']['SlaveUsername'] = 'forums_wz_r';
$GLOBALS['digitalPoint']['SlavePassword'] = '<%= devpbxf_forums_wzro %>';
$GLOBALS['digitalPoint']['SlaveDBname']   = 'forums_wz';
$GLOBALS['digitalPoint']['SlaveDBPort']   = '3306';


//CDN-Akamai config
$config['externalDataUrl'] = 'http://cdn1-dev.forums.wrestlezone.com/data';
$config['javaScriptUrl'] = 'http://cdn1-dev.forums.wrestlezone.com/js';


//Memcache Settings
$config['cache']['enabled'] = true;
$config['cache']['backend'] = 'Memcached';
$config['cache']['cacheSessions'] = true;
$config['cache']['backendOptions'] = array(
                'compression' => false,
                'servers' => array(
                                array(
                                                'host' => 'mem1v-xf-wz.ao.dev.lax.gnmedia.net',
                                                'port' => 11211
                                ),
                                array(
                                                'host' => 'mem2v-xf-wz.ao.dev.lax.gnmedia.net',
                                                'port' => 11211
                                )
                )
);

