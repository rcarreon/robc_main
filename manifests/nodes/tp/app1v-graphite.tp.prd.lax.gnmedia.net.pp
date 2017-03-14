node 'app1v-graphite.tp.prd.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base
        $project="admin"
       #include graphite::ssl_certs
       include httpd::ssl
       # include memcached
       httpd::ssl::virtual_host {"graphite.gnmedia.net": expect => "frameset"}
       # include python::mod_wsgi
       # include yum::gnrepo_beta

       file {
           # gorillanation.com wildcard cert
           "/etc/pki/tls/certs/graphite.gnmedia.net.cert":
               owner  => "deploy",
               group  => "deploy",
               mode   => "0644",
               source => "puppet:///modules/httpd/certificates/graphite.gnmedia.net.cert";
           "/etc/pki/tls/private/graphite.gnmedia.net.key":
               owner  => "deploy",
               group  => "deploy",
               mode   => "0644",
               source => "puppet:///modules/httpd/certificates/graphite.gnmedia.net.key";
        }

        # archive job.
        $script_path='graphite_archive'
        include cronjob
        cronjob::do_cronjob { 'archive.pl': cron_folder => 'cron.weekly' }

        package { ['Django', 'pyparsing', 'python-django-tagging', 'python-zope-interface']: ensure => present }
        package { [ 'python-memcached', 'python-carbon', 'python-whisper']: ensure => present }
        package { [ 'mod_wsgi', 'pycairo', 'python-ldap' ]: ensure => present }
        #package { 'graphite-web': ensure => present, }

        common::nfsmount { "/app/shared":
            device => "nfsA-netapp1.gnmedia.net:/vol/nac1a_tp_lax_prd_app_shared/graphite",
        }

        common::nfsmount { "/app/data":
            device => "nfsA-netapp1.gnmedia.net:/vol/nac1a_tp_lax_prd_app_data/carbon",
        }

        common::nfsmount { "/app/log":
            device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_tp_lax_prd_app_log/app1v-graphite.tp.prd.lax.gnmedia.net",
        }
}
