node 'app2v-adops.ap.dev.lax.gnmedia.net' {
  include base
  $project='adops'
  include newrelic
  include newrelic::params
  include newrelic::sysmond
  include newrelic::nfsiostat

  include httpd
  include adops::rbenv
  include ap::app::adoperations
  include ap::app::adoperations::dev

  $ap_passenger_module = '/app/software/ruby/rbenv/versions/2.2.2/lib/ruby/gems/2.2.0/gems/passenger-5.0.24/buildout/apache2/mod_passenger.so'
  $ap_passenger_root   = '/app/software/ruby/rbenv/versions/2.2.2/lib/ruby/gems/2.2.0/gems/passenger-5.0.24'
  $ap_passenger_default_ruby = '/app/software/ruby/rbenv/versions/2.2.2/bin/ruby'
  file {'/etc/httpd/conf.d/ap_passenger.conf':
    ensure  => file,
    content => template('adops/ap_passenger.conf.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }


  file {'/etc/httpd/conf.d/passenger-adops.conf':
    ensure => absent
  }

  package { ['php-pear-Net_GeoIP', 'GeoIP']:
    ensure => present,
  }

  common::nfsmount { '/app/shared':
    device  => 'nfsA-netapp1.gnmedia.net:/vol/nac1a_ap_lax_dev_app_shared/adops-new-shared',
  }

  common::nfsmount { '/app/log':
    device  => 'nfsB-netapp1.gnmedia.net:/vol/nac1b_ap_lax_dev_app_log/app2v-adops.ap.dev.lax.gnmedia.net',
  }

  common::nfsmount { '/app/ugc':
    device  => 'nfsB-netapp1.gnmedia.net:/vol/nac1b_ap_lax_dev_app_ugc',
  }

  common::nfsromount { '/app/software':
    device  => 'nfsA-netapp1.gnmedia.net:/vol/nac1a_ap_lax_dev_app_shared/ap-software-prd',
  }

  file {'/app/ugc/adops-api-uploads':
    ensure => directory,
    owner  => 'apache',
    group  => 'apache',
    mode   => '0755',
    require => Mount['/app/ugc'],
  }

  ap::vhost {'dev.adops-api.evolvemediallc.com': uri => '/' }
  ap::vhost {'dev.adops.evolvemediallc.com': uri => '/' }
}
