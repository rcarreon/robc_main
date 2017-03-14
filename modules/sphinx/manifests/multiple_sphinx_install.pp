# Shared sphinx installations

#       include sphinx::multiple_sphinx_install
#       $project='sphinx_vb'
#       $project is the folder in template
#       multiple_sphinx_config {'shh': sql_host=>'vip-sql-read.shh.lax2.gnmedia.net', sql_user=>'somusername', sql_pass=>'hola', sql_db=>'vb_dbname', port=>'3312'}
#       multiple_sphinx_config {'sdn': sql_host=>'vip2-sqlro-sdn.ao.prd.lax.gnmedia.net', sql_user=>'holyshi', sql_pass=>'ohreally', sql_db=>'some_vbulletin', port=>'3313'}
#
#       we use logrotate from stock, so make sure to put log in /var/log/sphinx/*log
#
# for cron, add similar line below to manifest, make sure $script_path is above 'include cronjob'
#
#        $script_path='sphinx_vb'
#        include cronjob
#        cronjob::do_cron_dot_d_cron_file {'sphinx.cron': }
#        cronjob::do_cron_dot_d_script {'sphinx-delta.sh': }
#        cronjob::do_cron_dot_d_script {'sphinx-full-index.sh':}


class sphinx::multiple_sphinx_install {
#    include mysqld::client::v5527

        package {'sphinx.x86_64':
            ensure    => installed,
#            require   => Class['mysqld::client::v5527'],
        }

        file { '/sphinx':
            ensure    => directory,
            owner     => 'sphinx',
            group     => 'sphinx',
            mode      => '0664',
            require   => Package['sphinx.x86_64'],
        }

        service {'searchd':
            ensure    => stopped,
            enable    => false,
            require   => Package['sphinx.x86_64'],
        }

}
