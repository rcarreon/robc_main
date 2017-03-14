<?php
// #### This file is managed by Puppet, do not modify it directly.


//Database Master Config
$config['db']['host'] = 'vip-sqlrw-xf-sdc.ao.dev.lax.gnmedia.net';
$config['db']['port'] = '3306';
$config['db']['username'] = 'forums_sdc_w';
$config['db']['password'] = '<%= devpbxf_forums_sdcrw %>';
$config['db']['dbname'] = 'forums_sdc';


//Database Slave config
$config['db']['adapterNamespace'] = 'DigitalPoint';
$GLOBALS['digitalPoint']['SlaveServerAll'][] = 'vip-sqlro-xf-sdc.ao.dev.lax.gnmedia.net';
$GLOBALS['digitalPoint']['SlaveUsername'] = 'forums_sdc_r';
$GLOBALS['digitalPoint']['SlavePassword'] = '<%= devpbxf_forums_sdcro %>';
$GLOBALS['digitalPoint']['SlaveDBname']   = 'forums_sdc';
$GLOBALS['digitalPoint']['SlaveDBPort']   = '3306';


//CDN-Akamai config
$config['externalDataUrl'] = 'http://cdn1-dev.forums.sherdog.com/data';
$config['javaScriptUrl'] = 'http://cdn1-dev.forums.sherdog.com/js';


//Memcache Settings
$config['cache']['enabled'] = true;
$config['cache']['backend'] = 'Memcached';
$config['cache']['cacheSessions'] = true;
$config['cache']['backendOptions'] = array(
                'compression' => false,
                'servers' => array(
                                array(
                                                'host' => 'mem1v-xf-sdc.ao.dev.lax.gnmedia.net',
                                                'port' => 11211
                                ),
                                array(
                                                'host' => 'mem2v-xf-sdc.ao.dev.lax.gnmedia.net',
                                                'port' => 11211
                                )
                )
);
