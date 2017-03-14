<?php
// #### This file is managed by Puppet, do not modify it directly.

$cs_database['read'] =  array(
                                'host' => 'localhost',
                                'username'  => 'csmovies_r',
                                'password'  => '<%= uid_api_csro %>',
                                'database'  => 'csmovies');
$cs_database['write'] = array(
                                'host' => 'localhost',
                                'username'  => 'csmovies_w',
                                'password'  => '<%= uid_api_csrw %>',
                                'database'  => 'csmovies');
