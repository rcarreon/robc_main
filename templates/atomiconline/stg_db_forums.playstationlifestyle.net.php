<?php
// #### This file is managed by Puppet, do not modify it directly.


//Database Master Config
$config['db']['host'] = 'vip-sqlrw-xf-psl.ao.stg.lax.gnmedia.net';
$config['db']['port'] = '3306';
$config['db']['username'] = 'forums_psl_w';
$config['db']['password'] = '<%= stgpbxf_forums_pslrw %>';
$config['db']['dbname'] = 'forums_psl';


//Database Slave config
$config['db']['adapterNamespace'] = 'DigitalPoint';
$GLOBALS['digitalPoint']['SlaveServerAll'][] = 'vip-sqlro-xf-psl.ao.stg.lax.gnmedia.net';
$GLOBALS['digitalPoint']['SlaveUsername'] = 'forums_psl_r';
$GLOBALS['digitalPoint']['SlavePassword'] = '<%= stgpbxf_forums_pslro %>';
$GLOBALS['digitalPoint']['SlaveDBname']   = 'forums_psl';
$GLOBALS['digitalPoint']['SlaveDBPort']   = '3306';


//CDN-Akamai Config
$config['externalDataUrl'] = 'http://cdn1-stg.forums.playstationlifestyle.net/data';
$config['javaScriptUrl'] = 'http://cdn1-stg.forums.playstationlifestyle.net/js';


//Memcache settings
$config['cache']['enabled'] = true;
$config['cache']['backend'] = 'Memcached';
$config['cache']['cacheSessions'] = true;
$config['cache']['backendOptions'] = array(
                'compression' => false,
                'servers' => array(
                                array(
                                                'host' => 'mem1v-xf-psl.ao.stg.lax.gnmedia.net',
                                                'port' => 11211
                                ),
                                array(
                                                'host' => 'mem2v-xf-psl.ao.stg.lax.gnmedia.net',
                                                'port' => 11211
                                )
                )
);

