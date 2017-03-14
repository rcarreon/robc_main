# This class installs and configures sssd for our envrionment
class sssd {


    package { 'sssd':
        ensure => present,
    }


    # Even though nscd is installed by xcat gn-vmconfigs
    # postscript, package is described here so that we can
    # ensure and restart the service below.
    package { 'nscd':
        ensure => installed,
    }


    service { 'sssd':
        ensure    => running,
        enable    => true,
        hasstatus => true,
        require   => Package['sssd'],
    }


    # Even though nscd is installed by xcat gn-vmconfigs
    # postscript, package is described here so that we can
    # ensure and restart the service below.
    service { 'nscd':
        ensure    => running,
        enable    => true,
        hasstatus => true,
        require   => Package['nscd'],
    }


    # NOTE sssd will not start if perms too lax on this file.
    file { '/etc/sssd/sssd.conf':
        ensure  => file,
        owner   => 'root',
        group   => 'root',
        mode    => '0600',
        require => Package['sssd'],
        notify  => Service['sssd'],
        source  => 'puppet:///modules/sssd/sssd.conf',
    }


    file { '/etc/nsswitch.conf':
        ensure  => file,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        require => Package['sssd'],
        notify  => Service['sssd'],
        source  => 'puppet:///modules/sssd/nsswitch.conf',
    }


    file { '/etc/nscd.conf':
        ensure  => file,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        require => [ Package['nscd'], Package['sssd'], ],
        notify  => [ Service['nscd'], Service['sssd'], ],
        source  => 'puppet:///modules/sssd/nscd.conf',
    }


    exec {'enablepamsssd':
        path    => ['/usr/bin', '/usr/sbin'],
        command => 'authconfig --enablemkhomedir --enablesssd --enablesssdauth --disablekrb5 --enablecache --enablemd5 --disablenis --disableldap --disablesmartcard --disablewins --nostart --update 2>&1',
        unless  => '/bin/grep -q pam_sss /etc/pam.d/system-auth',
        require => [ Package['nscd'], Package['sssd'], ],
    }


    #  This is included here because it was part of auth::noldap,
    #  yet we need it on every machine. it can be moved back to auth
    #  when we cut over fully and clean up the auth module.
        file {'/etc/security/access.conf':
        owner   =>      'root',
        group   =>      'root',
        mode    =>      '0644',
        content =>      template('auth/access.conf.erb'),
    }




}
