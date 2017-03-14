<?php
// #### This file is managed by Puppet, do not modify it directly.

$config['Database']['dbname'] = 'bab_vbulletin';
$config['Database']['dbtype'] = 'mysqli_slave';
$config['Database']['tableprefix'] = '';
$config['Database']['force_sql_mode'] = false;
$config['Database']['technicalemail'] = 'matthew.dillon@evolvemediallc.com';

$config['MasterServer']['servername'] = 'sql1v-vb-bab.ao.dev.lax.gnmedia.net';
$config['MasterServer']['username'] = 'bab_vbulletin_w';
$config['MasterServer']['password'] = 'dTxH3pVBg623';
$config['MasterServer']['port'] = 3306;
$config['MasterServer']['usepconnect'] = 0;

$config['SlaveServer']['servername'] = 'sql1v-vb-bab.ao.dev.lax.gnmedia.net';
$config['SlaveServer']['username'] = 'bab_vbulletin_r';
$config['SlaveServer']['password'] = 'Ue5Rq3aC84Wz';
$config['SlaveServer']['port'] = 3306;
$config['SlaveServer']['usepconnect'] = 0;

$config['Misc']['admincpdir'] = 'admincp';
$config['Misc']['modcpdir'] = 'modcp';
$config['Misc']['cookieprefix'] = 'bb';
$config['Misc']['forumpath'] = '';
$config['Misc']['maxwidth'] = 2592;
$config['Misc']['maxheight'] = 1944;

$config['SpecialUsers']['canviewadminlog'] = '3';
$config['SpecialUsers']['canpruneadminlog'] = '3';
$config['SpecialUsers']['canrunqueries'] = '';
$config['SpecialUsers']['undeletableusers'] = '1';
$config['SpecialUsers']['superadministrators'] = '3,170629';
$config['SpecialUsers']['privatemessageadmin'] = '3,4,1122';

$config['Datastore']['class'] = 'vB_Datastore_Memcached';
$config['Datastore']['prefix'] = 'bnb';

$config['Misc']['memcacheserver'][0]           = '10.11.234.35';
$config['Misc']['memcacheport'][0]             = 11211;
$config['Misc']['memcachepersistent'][0]       = true;
$config['Misc']['memcacheweight'][0]           = 1;
$config['Misc']['memcachetimeout'][0]          = 1;
$config['Misc']['memcacheretry_interval'][0]   = 15;

$config['Mysqli']['ini_file'] = '';

$config['Sphinx']['host'] = 'spx1v-vb.ao.dev.lax.gnmedia.net';
$config['Sphinx']['port'] = 3315;
