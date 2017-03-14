
# Class: carbon
#
# This class contains all carbon-cache configuration files
#

class carbon {

    file {'/app/log/carbon-cache':
            ensure  => directory,
            owner   => 'carbon',
            group   => 'carbon',
            mode    => '0755',
            require => [ Package['carbon'], Mount['/app/log'] ],
    }

    # /app/data is node manifest

    file { '/etc/sysconfig/carbon':
        ensure => file,
        source => 'puppet:///modules/carbon/carbon.sysconfig',
        owner  => 'root',
        group  => 'root',
        mode   => '0644',
        require => Package['carbon'],
    }

  # need this cos ace can't balance persistence connection if 1 server die
  # stop will drop connections and sleep 30 to wait for all connections to be
  # clear and start it back up, and let ace lb new connections

  package { 'carbon': ensure => installed }
  package { 'whisper': ensure => installed }

  file {'/etc/carbon/carbon.conf':
      ensure  => present,
      owner   => root,
      group   => root,
      mode    => '0644',
      source  => 'puppet:///modules/carbon/carbon-cache.conf',
      require => Package['carbon'],
  }
  file {"/etc/carbon/storage-schemas.conf":
      ensure  => present,
      owner   => root,
      group   => root,
      mode    => '0644',
      source  => 'puppet:///modules/carbon/storage-schemas.conf',
      require => Package['carbon'],
  }
  file {'/etc/init.d/carbon-cache':
      ensure  => file,
      source  => 'puppet:///modules/carbon/init-carbon-cache',
      owner   => root,
      group   => root,
      mode    => '0775',
      require => Package['carbon'],
  }
  service {'carbon-cache':
      ensure    => running,
      enable    => true,
      hasstatus => true,
      subscribe => File['/etc/carbon/carbon.conf'],
      require   => [ Package['carbon'], File['/etc/init.d/carbon-cache'] ],
  }

}
