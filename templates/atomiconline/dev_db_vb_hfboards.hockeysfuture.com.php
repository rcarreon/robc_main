<?php
// #### This file is managed by Puppet, do not modify it directly.

$config['Database']['dbtype'] = 'mysqli_slave';
$config['Database']['dbname'] = 'hfboards';
$config['Database']['tableprefix'] = '';
$config['Database']['technicalemail'] = 'matthew.dillon@evolvemediallc.com';
$config['Database']['force_sql_mode'] = false;

$config['MasterServer']['servername'] = 'sql1v-vb-hfb.ao.dev.lax.gnmedia.net';
$config['MasterServer']['username'] = 'hfboards_w';
$config['MasterServer']['password'] = '4ahUE2579bt8';
$config['MasterServer']['port'] = 3306;
$config['MasterServer']['usepconnect'] = 0;

$config['SlaveServer']['servername'] = 'sql1v-vb-hfb.ao.dev.lax.gnmedia.net';
$config['SlaveServer']['username'] = 'hfboards_r';
$config['SlaveServer']['password'] = 'y93m8n7A3uy4';
$config['SlaveServer']['usepconnect'] = 0;
$config['SlaveServer']['port'] = 3306;

$config['Misc']['admincpdir'] = 'admincp';
$config['Misc']['modcpdir'] = 'modcp';
$config['Misc']['cookieprefix'] = 'bb';
$config['Misc']['forumpath'] = '';
$config['Misc']['maxwidth'] = 2592;
$config['Misc']['maxheight'] = 1944;

$config['SpecialUsers']['canviewadminlog'] = '171';
$config['SpecialUsers']['canpruneadminlog'] = '171';
$config['SpecialUsers']['canrunqueries'] = '171';
$config['SpecialUsers']['undeletableusers'] = '';
$config['SpecialUsers']['superadministrators'] = '171';

$config['Datastore']['prefix'] = 'hfb';
$config['Datastore']['class'] = 'vB_Datastore_Memcached';

$config['Misc']['memcacheserver'][0]           = '10.11.234.35';
$config['Misc']['memcacheport'][0]             = 11211;
$config['Misc']['memcachepersistent'][0]       = true;
$config['Misc']['memcacheweight'][0]           = 1;
$config['Misc']['memcachetimeout'][0]          = 1;
$config['Misc']['memcacheretry_interval'][0]   = 15;

$config['Mysqli']['ini_file'] = '';

$config['Sphinx']['host'] = 'spx1v-vb.ao.dev.lax.gnmedia.net';
$config['Sphinx']['port'] = 3314;
