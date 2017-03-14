class nagios::client {

    # Config file for nrpe
    file {'/etc/nagios/nrpe.cfg':
        ensure  => present,
        mode    => '0644',
        owner   => 'root',
        group   => 'root',
        content => template ('nagios/nrpe.cfg.erb'),
        backup  => undef,
        require => [Package['nrpe']],
    }

    file { '/etc/xinetd.d/nrpe':
        ensure => absent,
    }

    if ($::architecture == 'x86_64') {
        $nagpluglibdir = 'lib64'
    } else {
        $nagpluglibdir = 'lib'
    }


    group { 'nrpe':
        ensure => 'present'
    }

    user { 'nrpe':
        ensure   => 'present',
        home     => '/',
        shell    => '/sbin/nologin',
        comment  => 'NRPE user for the NRPE service',
        password => '!!',
        gid      => 'nrpe',
        require  => Group['nrpe'],
    }

    # installs nrpe
    # depends on nagios package


    if ($lsbdistrelease == '6.4') {
        # set to version
        $nrpeensure = '2.14-3.el6'
    } else {
        # set to present
        $nrpeensure = 'present'
    }

    package { 'nrpe':
        ensure  => $nrpeensure,
        require => User['nrpe'],
    }

    service{ 'nrpe':
        ensure     => running,
        hasstatus  => true,
        hasrestart => true,
        enable     => true,
        require    => Package['nrpe'],
        subscribe  => File['/etc/nagios/nrpe.cfg'],
    }
    # GN plugins for nrpe client
    file { "/usr/${nagpluglibdir}/nagios/plugins/":
        ensure   => present,
        mode     => '0755',
        owner    => 'root',
        group    => 'root',
        source   => 'puppet:///modules/nagios/plugins_gn',
        force    => true,
        ignore   => '.svn',
        recurse  => true,
        require  => Package['nrpe'],
    }
    # plugins for the nrpe client....
    #  installs nagios-plugins-nrpe
    package { 'nagios-plugins-nrpe':
        ensure  => present,
        require => [Package['nrpe']],
    }
    # installs nagios-plugins-disk
    package { 'nagios-plugins-disk':
        ensure  => present,
        require => [Package['nrpe']],
    }
    # installs nagios-plugins-dummy
    package { 'nagios-plugins-dummy':
        ensure  => present,
        require => [Package['nrpe']],
    }
    # installs nagios-plugins-http
    package { 'nagios-plugins-http':
        ensure  => present,
        require => [Package['nrpe']],
    }
    # installs nagios-plugins-load
    package { 'nagios-plugins-load':
        ensure  => present,
        require => [Package['nrpe']],
    }
    # installs nagios-plugins-ntp
    package { 'nagios-plugins-ntp':
        ensure  => present,
        require => [Package['nrpe']],
    }
    # installs nagios-plugins-procs
    package { 'nagios-plugins-procs':
        ensure  => present,
        require => [Package['nrpe']],
    }
    package { 'nagios-plugins-file_age':
        ensure  => present,
        require => [Package['nrpe']],
    }

    if ( $::lsbmajdistrelease == '6' ) {
        # required for check_nfsmounts
        package { 'perl-Time-HiRes':
            ensure => present,
        }
    }

    # We need to have the host define
    nagios::host{$::fqdn:}
}
