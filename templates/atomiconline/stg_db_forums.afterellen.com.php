<?php
// #### This file is managed by Puppet, do not modify it directly.


//Database Master Config
$config['db']['host'] = 'vip-sqlrw-xf-ae.ao.stg.lax.gnmedia.net';
$config['db']['port'] = '3306';
$config['db']['username'] = 'forums_ae_w';
$config['db']['password'] = '<%= stgpbxf_forums_aerw %>';
$config['db']['dbname'] = 'forums_ae';


//Database Slave config
$config['db']['adapterNamespace'] = 'DigitalPoint';
$GLOBALS['digitalPoint']['SlaveServerAll'][] = 'vip-sqlro-xf-ae.ao.stg.lax.gnmedia.net';
$GLOBALS['digitalPoint']['SlaveUsername'] = 'forums_ae_r';
$GLOBALS['digitalPoint']['SlavePassword'] = '<%= stgpbxf_forums_aero %>';
$GLOBALS['digitalPoint']['SlaveDBname']   = 'forums_ae';
$GLOBALS['digitalPoint']['SlaveDBPort']   = '3306';


//CDN-Akamai Config
$config['externalDataUrl'] = 'http://cdn1-stg.forums.afterellen.com/data';
$config['javaScriptUrl'] = 'http://cdn1-stg.forums.afterellen.com/js';


//Memcache settings
$config['cache']['enabled'] = true;
$config['cache']['backend'] = 'Memcached';
$config['cache']['cacheSessions'] = true;
$config['cache']['backendOptions'] = array(
                'compression' => false,
                'servers' => array(
                                array(
                                                'host' => 'mem1v-xf-ae.ao.stg.lax.gnmedia.net',
                                                'port' => 11211
                                ),
                                array(
                                                'host' => 'mem2v-xf-ae.ao.stg.lax.gnmedia.net',
                                                'port' => 11211
                                )
                )
);
