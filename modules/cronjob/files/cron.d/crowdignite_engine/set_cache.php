#!/usr/bin/php -q
<?php
$shortopts  = "";
$shortopts .= "k:";  
$shortopts .= "e:"; 
$shortopts .= "t:"; 
$shortopts .= "f:"; 
$options = getopt($shortopts);

$env=($options['e']) ? $options['e'] : 'dev';
$key=$options['k'];
$expire=$options['t'];
$func=$options['f'];

$dev = array(
    array('mem1v-ci.ci.dev.lax.gnmedia.net', 11211)
);

$stg = array(
    array('mem1v-ci.ci.stg.lax.gnmedia.net', 11211),
    array('mem2v-ci.ci.stg.lax.gnmedia.net', 11211),
    array('mem3v-ci.ci.stg.lax.gnmedia.net', 11211),
    array('mem4v-ci.ci.stg.lax.gnmedia.net', 11211),
);

$prd = array(
    array('mem1v-ci.ci.prd.lax.gnmedia.net', 11211),
    array('mem2v-ci.ci.prd.lax.gnmedia.net', 11211),
    array('mem3v-ci.ci.prd.lax.gnmedia.net', 11211),
    array('mem4v-ci.ci.prd.lax.gnmedia.net', 11211),
    array('mem5v-ci.ci.prd.lax.gnmedia.net', 11211),
    array('mem6v-ci.ci.prd.lax.gnmedia.net', 11211),
    array('mem7v-ci.ci.prd.lax.gnmedia.net', 11211),
);

$m = new Memcached();
$m->addServers(${$env});

switch ($func) {
	case 'get':
		echo $m->get($key) or exit(1);
		break;

	case 'set':
		$m->set($key,1,$expire) or exit(1);
		break;
	
	case 'delete':
		$m->delete($key) or exit(1);
		break;

}

exit;
