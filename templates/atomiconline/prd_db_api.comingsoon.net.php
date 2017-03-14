<?php
// #### This file is managed by Puppet, do not modify it directly.

$cs_database['read'] =  array(
                                'host' => 'vip-sqlro-api-cs.ao.prd.lax.gnmedia.net',
                                'username'  => 'csmovies_r',
                                'password'  => '<%= prd_api_csro %>',
                                'database'  => 'csmovies');
$cs_database['write'] = array(
                                'host' => 'vip-sqlrw-api-cs.ao.prd.lax.gnmedia.net',
                                'username'  => 'csmovies_w',
                                'password'  => '<%= prd_api_csrw %>',
                                'database'  => 'csmovies');
