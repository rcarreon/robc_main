<?php
// #### This file is managed by Puppet, do not modify it directly.

$dfp_database['read'] =  array(
                                'host' => 'sql1v-api-dfp.ao.dev.lax.gnmedia.net',
                                'username'  => 'dfp_ro',
                                'password'  => '<%= dev_api_dfpro %>',
                                'database'  => 'api_dfp');
$dfp_database['write'] = array(
                                'host' => 'sql1v-api-dfp.ao.dev.lax.gnmedia.net',
                                'username'  => 'dfp_rw',
                                'password'  => '<%= dev_api_dfprw %>',
                                'database'  => 'api_dfp');
