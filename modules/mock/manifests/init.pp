#
# Set up a host as one of our mock build hosts.
#
class mock {

    group { 'mock':
        ensure => present,
        gid    => '20065',
    }

    package { 'mock':
        ensure  => present,
        require => Group['mock']
    }

    common::nfsmount { '/mnt/yum_repos':
        device => 'nfsA-netapp1.tp.prd.lax.gnmedia.net:/vol/nac1a_tp_lax_prd_app_yumrepos'
    }

    file { "/etc/mock/gn-${::lsbmajdistrelease}-x86_64.cfg":
        ensure  => file,
        owner   => 'root',
        group   => 'root',
        source  => "puppet:///modules/mock/gn-${::lsbmajdistrelease}-x86_64.cfg",
        mode    => '0644',
    }

    file { "/etc/mock/gnbeta-${::lsbmajdistrelease}-x86_64.cfg":
        ensure  => file,
        owner   => 'root',
        group   => root,
        source  => "puppet:///modules/mock/gnbeta-${::lsbmajdistrelease}-x86_64.cfg",
        mode    => '0644',
    }

    file { '/etc/mock/default.cfg':
        ensure  => link,
        owner   => 'root',
        group   => 'root',
        target  => "/etc/mock/gn-${::lsbmajdistrelease}-x86_64.cfg",
    }

    file { '/etc/mock/gn.cfg':
        ensure  => link,
        owner   => 'root',
        group   => 'root',
        target  => "/etc/mock/gn-${::lsbmajdistrelease}-x86_64.cfg",
    }

    file { '/etc/mock/gnbeta.cfg':
        ensure  => link,
        owner   => 'root',
        group   => 'root',
        target  => "/etc/mock/gnbeta-${::lsbmajdistrelease}-x86_64.cfg",
    }

    file { '/usr/local/bin/rpm_build_post':
        ensure  => file,
        owner   => 'root',
        group   => 'root',
        source  => 'puppet:///modules/mock/rpm_build_post',
        mode    => '0755',
    }
}

