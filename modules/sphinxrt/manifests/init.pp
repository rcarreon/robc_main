class sphinxrt($sphinx_version='2.0.5-1.rhel6') {
    class { 'sphinxrt::install': sphinx_version => $sphinx_version }
    include sphinxrt::monitor

    service { 'searchd':
      enable    => true,
      ensure    => running,
      hasstatus => true,
      require   => [ Package[sphinx], File["/app/shared/sphinx"]],
    }
  
    file { ['/app/shared/sphinx','/app/shared/sphinx/binlog','/app/shared/sphinx/index','/app/shared/sphinx/dicts','/app/log/sphinx']:
      ensure => directory,
      owner  => "sphinx",
      group  => "sphinx",
      mode   => "755",
      require => Package['sphinx'],
    }
  
    file { '/etc/sphinx/sphinx.conf':
      source => "puppet:///modules/sphinxrt/${project}.sphinx.conf",
      owner  => "root",
      group  => "root",
      mode   => "644",
      require => Package[sphinx],
      notify  => Service[searchd],
    }

    file { '/app/shared/sphinx/dicts/en.pak':
      source => "puppet:///modules/sphinxrt/${project}.en.pak",
      owner  => "sphinx",
      group  => "sphinx",
      mode   => "644",
      require => Package[sphinx],
      notify  => Service[searchd],
    }

    # Logrotate We overwrite the default /var/log/sphinx directory
    file { "/etc/logrotate.d/sphinx":
        source => "puppet:///modules/sphinxrt/sphinxrt.logrotate",
        ensure => file,
        owner => root,
        group => root,
        mode => 644,
        require => Package[sphinx],
    }
}
