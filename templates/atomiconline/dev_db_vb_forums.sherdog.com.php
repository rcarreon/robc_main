<?php
// #### This file is managed by Puppet, do not modify it directly.

$config['Database']['dbtype'] = 'mysqli_slave';
$config['Database']['dbname'] = 'vbulletin';
$config['Database']['tableprefix'] = '';
$config['Database']['technicalemail'] = 'matthew.dillon@evolvemediallc.com';
$config['Database']['force_sql_mode'] = false;

$config['MasterServer']['servername'] = 'sql1v-vb-sdc.ao.dev.lax.gnmedia.net';
$config['MasterServer']['username'] = 'sherdog_w';
$config['MasterServer']['password'] = '43q8AJmyr654';
$config['MasterServer']['port'] = 3306;
$config['MasterServer']['usepconnect'] = 0;

$config['SlaveServer']['servername'] = 'sql1v-vb-sdc.ao.dev.lax.gnmedia.net';
$config['SlaveServer']['username'] = 'sherdog_r';
$config['SlaveServer']['password'] = 'q7g6Wv4yux5z';
$config['SlaveServer']['port'] = 3306;
$config['SlaveServer']['usepconnect'] = 0;

$config['Misc']['admincpdir'] = 'admincp';
$config['Misc']['modcpdir'] = 'modcp';
$config['Misc']['cookieprefix'] = 'sd';
$config['Misc']['forumpath'] = '';
$config['Misc']['maxwidth'] = 2592;
$config['Misc']['maxheight'] = 1944;

$config['SpecialUsers']['canviewadminlog'] = '223577';
$config['SpecialUsers']['canpruneadminlog'] = '';
$config['SpecialUsers']['canrunqueries'] = '';
$config['SpecialUsers']['undeletableusers'] = '';
$config['SpecialUsers']['superadministrators'] = '120644,213336';

$config['Datastore']['class'] = 'vB_Datastore_Memcached';
$config['Datastore']['prefix'] = 'sdn';

$config['Misc']['memcacheserver'][0]            = '10.11.234.35';
$config['Misc']['memcacheport'][0]              = 11211;
$config['Misc']['memcachepersistent'][0]        = true;
$config['Misc']['memcacheweight'][0]            = 1;
$config['Misc']['memcachetimeout'][0]           = 1;
$config['Misc']['memcacheretry_interval'][0]    = 15;

$config['Mysqli']['ini_file'] = '';

$config['Sphinx']['host'] = 'spx1v-vb.ao.dev.lax.gnmedia.net';
$config['Sphinx']['port'] = 3313;
