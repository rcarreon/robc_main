<?php
// #### This file is managed by Puppet, do not modify it directly.

$dfp_database['read'] =  array(
                                'host' => 'vip-sqlro-api-dfp.ao.stg.lax.gnmedia.net',
                                'username'  => 'dfp_ro',
                                'password'  => '<%= stg_api_dfpro %>',
                                'database'  => 'api_dfp');
$dfp_database['write'] = array(
                                'host' => 'vip-sqlrw-api-dfp.ao.stg.lax.gnmedia.net',
                                'username'  => 'dfp_rw',
                                'password'  => '<%= stg_api_dfprw %>',
                                'database'  => 'api_dfp');
