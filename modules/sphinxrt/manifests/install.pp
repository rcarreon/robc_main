class sphinxrt::install($sphinx_version='2.0.5-1.rhel6') {

    # create sphinx user and group

    group { 'sphinx':
        ensure => 'present',
        gid => '113',
    }

    user { 'sphinx':
        ensure   => 'present',
        home     => '/var/lib/sphinx',
        shell    => '/sbin/nologin',
        comment  => 'Sphinx server',
        password => '!!',
        uid      => '113',
        gid      => 'sphinx',
        require  => Group["sphinx"],
    }

    # install sphinx RPMs

    package { 'sphinx':
        ensure => $sphinx_version,
        require => User["sphinx"],
    }

    # The sphinx rpm's init script sets chkconfig to start too early
    # in the boot process.
    file { '/etc/rc.d/init.d/searchd':
        source => "puppet:///modules/sphinxrt/searchd.init",
        owner  => "root",
        group  => "root",
        mode   => "755",
        require => Package[sphinx],
    }

    # This is needed to reset the init script to an appropriate start priority
    exec { 'bootstart':
        command => "/sbin/chkconfig --level 2345 searchd on",
        require => File["/etc/rc.d/init.d/searchd"],
        unless => "test -x /etc/rc3.d/S85searchd 2>/dev/null"
        #notify  => Service[searchd],
    }

}
