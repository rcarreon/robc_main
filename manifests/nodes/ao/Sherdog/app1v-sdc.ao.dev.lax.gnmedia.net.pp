node 'app1v-sdc.ao.dev.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base
  $project='atomiconline'
  $httpd='sherdogc6'
  $site='sherdog'

  include subversion::client
  include httpd
  include memcached

  class { 'php::install':
    version        => '5.3',
    ini_template   => 'php.ini-sdc.erb',
    extra_packages => [ 'php-tidy', 'php-pecl-apc' ],
  }

  httpd::virtual_host { 'www.sherdog.com': monitor   => false, }
  httpd::virtual_host { 'm.sherdog.com':   monitor   => false, }
  httpd::virtual_host { 'dev.media.sherdog.com': monitor => false, }

  file { '/app/ugc':
    ensure => directory,
    owner  => deploy,
    group  => apache,
    mode   => '0775',
  }

  common::nfsmount { '/app/shared':
    device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ao_lax_dev_app_shared/www.sherdog.com_shared",
  }

  common::nfsmount { '/app/log':
    device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ao_lax_dev_app_log/app1v-sdc.ao.dev.lax.gnmedia.net",
  }

  common::nfsmount { '/app/ugc':
    device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ao_lax_dev_app_shared/admin.sherdog.com_ugc",
  }

  file { '/app/shared/docroots/static':
    ensure => directory,
  }

  common::nfsmount { '/app/shared/docroots/static':
    device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ao_lax_dev_app_shared/www.sherdog.com_shared/docroots/sherdog.com/public",
  }
}