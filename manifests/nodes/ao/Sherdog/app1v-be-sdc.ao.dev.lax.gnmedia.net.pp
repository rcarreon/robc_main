node 'app1v-be-sdc.ao.dev.lax.gnmedia.net' {
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
  include mysqld56::client

  sphinx::conf { 'dev-sdc': span => '6', }
  httpd::virtual_host { 'admin.sherdog.com': monitor => false, }

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

  common::nfsmount { '/app/shared':
    device => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ao_lax_dev_app_shared/admin.sherdog.com_shared",
   }

  common::nfsmount { '/app/ugc':
    device => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ao_lax_dev_app_shared/admin.sherdog.com_ugc",
  }

  common::nfsmount { '/app/log':
    device => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ao_lax_dev_app_log/app1v-be-sdc.ao.dev.lax.gnmedia.net",
  }

  cron { 'sherdog_fighter_reindex':
    ensure  => present,
    command => '/usr/bin/indexer --config /etc/sphinx/sphinx.conf --rotate --quiet sherdog_fighters >/dev/null 2>&1',
    user    => root,
    hour  => '0',
    weekday => '0',
  }

  cron { 'sherdog_fighter_articles_reindex':
    ensure  => present,
    command => '/usr/bin/indexer --config /etc/sphinx/sphinx.conf --rotate --quiet sherdog_fighter_articles >/dev/null 2>&1',
    user    => root,
    hour  => '1',
    weekday => '0',
  }
} 
