<?php
// #### This file is managed by Puppet, do not modify it directly.

$dfp_database['read'] =  array(
                                'host' => 'localhost',
                                'username'  => 'dfp_ro',
                                'password'  => '<%= uid_api_dfpro %>',
                                'database'  => 'api_dfp');
$dfp_database['write'] = array(
                                'host' => 'localhost',
                                'username'  => 'dfp_rw',
                                'password'  => '<%= uid_api_dfprw %>',
                                'database'  => 'api_dfp');
