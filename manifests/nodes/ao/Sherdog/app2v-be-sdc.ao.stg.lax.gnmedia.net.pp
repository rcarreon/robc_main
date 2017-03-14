node 'app2v-be-sdc.ao.stg.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base
  $project='atomiconline'
  $site='sherdog'

  include subversion::client
  include httpd
  include php::sherdog::backend
  include memcached

  sphinx::conf { 'stg-sdc': }
  httpd::virtual_host { 'admin.sherdog.com': monitor => false}

  file { '/etc/httpd/conf.d/admin.sherdog.com_auth':
    source => 'puppet:///modules/httpd/htpasswords/atomic-sites/admin.sherdog.logins',
    owner  => "deploy",
    group  => "deploy",
  }

  file { '/app/ugc':
    ensure => directory,
    owner  => "deploy",
    group  => "apache",
  }


  common::nfsmount {'/app/shared':
    device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ao_lax_stg_app_shared/admin.sherdog.com_shared",
  }

  common::nfsmount {'/app/ugc':
    device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_ao_lax_stg_app_ugc/admin.sherdog.com_ugc",
  }

  common::nfsmount {'/app/log':
    device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_ao_lax_stg_app_log/app2v-be-sdc.ao.stg.lax.gnmedia.net",
  }
}
