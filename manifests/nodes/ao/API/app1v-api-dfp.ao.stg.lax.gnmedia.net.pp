node 'app1v-api-dfp.ao.stg.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
        include base

        $username="deploy"
        $project="api-dfp"
        $httpd="api-dfp"
        include ao::api::dfp
        include ao::api::dfp::stg_configs
        include yum::ius
        class { 'php::install': version => '5.6', ini_template => 'atomiconline/php.ini-pbwp.erb', extra_packages => ["php56u-pecl-memcached", "php56u-mcrypt", "php56u-pecl-apcu", "php56u-soap"] }
        package {'mysql':
                ensure=> present,
        }


        common::nfsmount { "/app/log":
                device => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ao_lax_stg_app_log/app1v-api-dfp.ao.stg.lax.gnmedia.net",
        }

        common::nfsmount { "/app/software":
                device => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ao_lax_stg_app_shared/ao-software-shared",
        }

        common::nfsmount { "/app/storage":
                device => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ao_lax_stg_app_shared/api-dfp-storage",
        }

        common::nfsmount { "/app/shared":
                device => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ao_lax_stg_app_shared/api-dfp-shared",
        }

        common::nfsmount { "/app/ugcapipics":
                device => "nfsB-netapp1.gnmedia.net:/vol/nac1b_ao_lax_stg_app_ugc/api-ugc/api.dfp.gnmedia.net",
        }

       file { '/app/log/dfp_crontab.log':
           ensure  => 'present',
           owner   => 'deploy',
           group   => 'apache',
           mode    => '0775',
        }
}
