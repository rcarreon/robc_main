class yum::gnrepo_handler inherits yum::client {
    case $::lsbmajdistrelease {
        '5': {
            $osVer='5'
            $centosVer="$::lsbdistrelease"
        }
        '6': {
            $osVer='6'
            $centosVer="$::lsbdistrelease"
        }
    }

    # Let's start by setting up live repos, because they go everywhere.
    file {'/etc/yum.repos.d/os-live.repo':
        ensure  => present,
        require => File['/etc/yum.repos.d'],
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
    }
    file {'/etc/yum.repos.d/updates-live.repo':
        ensure  => present,
        require => File['/etc/yum.repos.d'],
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
    }
    file {'/etc/yum.repos.d/epel-live.repo':
        ensure  => present,
        require => File['/etc/yum.repos.d'],
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
    }
    file {'/etc/yum.repos.d/gnrepo-live.repo':
        ensure  => present,
        require => File['/etc/yum.repos.d'],
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
    }
    yumrepo {'os-live':
        descr   => 'Gorillanation\'s live mirror of centos os repos',
        baseurl => "http://yum.gnmedia.net/live/centos/${centosVer}/os/",
        enabled => 1,
    }
    yumrepo {'updates-live':
        descr   => 'Gorillanation\'s live mirror of centos updates repos',
        baseurl => "http://yum.gnmedia.net/live/centos/${centosVer}/updates/",
        enabled => 1,
    }
    yumrepo {'epel-live':
        descr   => 'Gorillanation\'s live mirror of epel repos',
        baseurl => "http://yum.gnmedia.net/live/epel/${osVer}/",
        enabled => 1,
    }
    yumrepo {'gnrepo-live':
        descr   => 'Gorillanation\'s live mirror of GN\'s repos',
        baseurl => "http://yum.gnmedia.net/live/gnrepo/${osVer}/",
        enabled => 1,
    }

    if($::fqdn_env != 'prd') {
        if($::fqdn_env == 'dev') {
            $betaEnable='1'
        } else {
            $betaEnable='0'
        }

        # Setup wildwest repos
        file {'/etc/yum.repos.d/os-wildwest.repo':
            ensure  => present,
            require => File['/etc/yum.repos.d'],
            owner   => 'root',
            group   => 'root',
            mode    => '0644',
        }
        file {'/etc/yum.repos.d/updates-wildwest.repo':
            ensure  => present,
            require => File['/etc/yum.repos.d'],
            owner   => 'root',
            group   => 'root',
            mode    => '0644',
        }
        file {'/etc/yum.repos.d/epel-wildwest.repo':
            ensure  => present,
            require => File['/etc/yum.repos.d'],
            owner   => 'root',
            group   => 'root',
            mode    => '0644',
        }
        yumrepo {'os-wildwest':
            descr   => 'Gorillanation\'s wildwest mirror of centos os repos',
            baseurl => "http://yum.gnmedia.net/wildwest/centos/${centosVer}/os/",
            enabled => 0,
        }
        yumrepo {'updates-wildwest':
            descr   => 'Gorillanation\'s wildwest mirror of centos repos',
            baseurl => "http://yum.gnmedia.net/wildwest/centos/${centosVer}/updates/",
            enabled => 0,
        }
        yumrepo {'epel-wildwest':
            descr   => 'Gorillanation\'s wildwest mirror of centos repos',
            baseurl => "http://yum.gnmedia.net/wildwest/epel/${osVer}/",
            enabled => 0,
        }

        # Setup staging repos
        file {'/etc/yum.repos.d/os-beta.repo':
            ensure  => present,
            require => File['/etc/yum.repos.d'],
            owner   => 'root',
            group   => 'root',
            mode    => '0644',
        }
        file {'/etc/yum.repos.d/updates-beta.repo':
            ensure  => present,
            require => File['/etc/yum.repos.d'],
            owner   => 'root',
            group   => 'root',
            mode    => '0644',
        }
        file {'/etc/yum.repos.d/epel-beta.repo':
            ensure  => present,
            require => File['/etc/yum.repos.d'],
            owner   => 'root',
            group   => 'root',
            mode    => '0644',
        }
        file {'/etc/yum.repos.d/gnrepo-beta.repo':
            ensure  => present,
            require => File['/etc/yum.repos.d'],
            owner   => 'root',
            group   => 'root',
            mode    => '0644',
        }
        yumrepo {'os-beta':
            descr   => 'Gorillanation\'s beta mirror of centos os repos',
            baseurl => "http://yum.gnmedia.net/beta/centos/${centosVer}/os/",
            enabled => "$betaEnable",
        }
        yumrepo {'updates-beta':
            descr   => 'Gorillanation\'s beta mirror of centos repos',
            baseurl => "http://yum.gnmedia.net/beta/centos/${centosVer}/updates/",
            enabled => "$betaEnable",
        }
        yumrepo {'epel-beta':
                descr   => 'Gorillanation\'s beta mirror of centos repos',
                baseurl => "http://yum.gnmedia.net/beta/epel/${osVer}/",
                enabled => "$betaEnable",
        }
        yumrepo {'gnrepo-beta':
            descr   => 'Gorillanation\'s beta mirror of centos repos',
            baseurl => "http://yum.gnmedia.net/beta/gnrepo/${osVer}/",
            enabled => "$betaEnable",
        }
    }
}
