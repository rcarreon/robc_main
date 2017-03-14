<?php
// #### This file is managed by Puppet, do not modify it directly.

$cs_database['read'] =  array(
                                'host' => 'vip-sqlro-api-cs.ao.stg.lax.gnmedia.net',
                                'username'  => 'csmovies_r',
                                'password'  => '<%= stg_api_csro %>',
                                'database'  => 'csmovies');
$cs_database['write'] = array(
                                'host' => 'vip-sqlrw-api-cs.ao.stg.lax.gnmedia.net',
                                'username'  => 'csmovies_w',
                                'password'  => '<%= stg_api_csrw %>',
                                'database'  => 'csmovies');
