# nagios server version 3 manifest
class nagios::serverv3 {
    include nagios::server::config
    include php

    package {'nagios':
      ensure => latest,
    }

    # nagios server should be stopped and disabled by default
    service { 'nagios':
        ensure     => running,
        hasstatus  => true,
        require    => Package[nagios],
        enable     => false,
        hasrestart => true,
    }

    file{'/etc/nagios':
        ensure =>directory,
        owner  => 'root',
        group  => 'root',
        mode   => '0755',
    }

    file{'/etc/nagios/conf.d':
        ensure  =>directory,
        require =>File['/etc/nagios'],
        owner   => 'root',
        group   => 'root',
        mode    => '0755',
    }

    # Nagios is running by default in init.pp

    # Purge obsolete exported resources
    resources {
        [ 'nagios_service', 'nagios_host' ]:
        purge   => true,
        require => File['/etc/nagios/conf.d'],
    }

    # collect all exported nagios configs
    Nagios_host <<| tag == $mon_status_level |>>
    Nagios_service <<| tag == $mon_status_level |>>

    Nagios_service { notify => Exec['Fix_permission_nagios'],}
    Nagios_host    { notify => Exec['Fix_permission_nagios'],}

    # Bug in Nagios_host and services, permissions are not set correctly...
    exec { 'Fix_permission_nagios':
        command     => '/bin/chmod +r -R /etc/nagios/conf.d/',
        notify      => Service['nagios'],
        refreshonly => true,
    }

    # remove all local bucketed files after a day.
    tidy { '/var/lib/puppet/clientbucket/':
        backup  => false,
        recurse => true,
        rmdirs  => true,
        type    => mtime,
        age     => '1d',
    }

    $ensure_if_prd = $mon_status_level ? {
        'production' => present,
        default      => absent,
    }

    file { '/etc/nagios/conf.d/adplatform.cfg':
        ensure  => $ensure_if_prd,
        mode    => '0644',
        owner   => root,
        group   => root,
        notify  => Service['nagios'],
        content => template('nagios/adplatform.cfg.erb'),
    }
    # Hard code some checks for adops archive environment.  To be in place until environment is decomed end of 2015
    file { '/etc/nagios/conf.d/adops-archive.cfg':
        ensure  => $ensure_if_prd,
        mode    => '0644',
        owner   => root,
        group   => root,
        notify  => Service['nagios'],
        content => template('nagios/adops-archive.cfg.erb'),
    }

    # JSON and status2json are for toolshed
    package { 'perl-JSON':
        ensure => present,
    }
    file { '/usr/lib64/nagios/cgi-bin/status2json.cgi':
        ensure  => present,
        mode    => '0755',
        source  => 'puppet:///modules/nagios/status2json.cgi',
        owner   => 'deploy',
        group   => 'deploy',
    }
}
