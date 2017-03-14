node 'app3v-adops.ap.stg.lax.gnmedia.net' {
  include base
  $project='adops'

  include httpd

  include adops::rbenv
  include adops::devmail

  include newrelic
  include newrelic::params
  include newrelic::sysmond
  include newrelic::nfsiostat

  include ap::app::adoperations
  include ap::app::adoperations::stg

  include pipestash

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


  file {'/etc/httpd/conf.d/ap_passenger_4.conf':
    ensure  => absent,
  }

  file {'/etc/httpd/conf.d/passenger.conf':
    ensure => absent
  }

  # class { 'ap::app::geoip': rails_env => 'staging' }

  common::nfsmount { '/app/shared':
    device  => 'nfsA-netapp1.gnmedia.net:/vol/nac1a_ap_lax_stg_app_shared/adops-shared',
  }

  common::nfsmount { '/app/ugc':
    device  => 'nfsB-netapp1.gnmedia.net:/vol/nac1b_ap_lax_stg_app_ugc/',
    options => 'nfsvers=3,noatime,rw,rsize=32768,wsize=32768,hard,intr,tcp,noexec,nosuid',
  }

  common::nfsmount { '/app/log':
    device  => 'nfsB-netapp1.gnmedia.net:/vol/nac1b_ap_lax_stg_app_log/app3v-adops.ap.stg.lax.gnmedia.net',
  }

  common::nfsromount { '/app/software':
    device  => 'nfsA-netapp1.gnmedia.net:/vol/nac1a_ap_lax_stg_app_shared/ap-software-prd',
  }

  file {'/app/ugc/adops-api-uploads':
    ensure => directory,
    owner  => 'apache',
    group  => 'apache',
    mode   => '0755',
    require => Mount['/app/ugc'],
  }


  ap::vhost {'stg.adops.evolvemediallc.com': uri => '/'}
  ap::vhost {'stg.adops-api.evolvemediallc.com': uri => '/'}
}
