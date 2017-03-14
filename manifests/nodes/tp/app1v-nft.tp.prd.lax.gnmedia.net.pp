node 'app1v-nft.tp.prd.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base
    include sendmail::client
    include monit::nft

    file { '/var/fnet':
        ensure  => symlink,
        target  => '/data/fnet',
        require => File['/data/fnet']
    }

    file { '/data':
        ensure => directory,
        owner  => 'root',
        group  => 'root',
        mode   => '0755',
    }

    file { '/data/fnet':
        ensure  => directory,
        owner   => 'root',
        group   => 'bin',
        mode    => '0755',
        require => File['/data'],
    }

    package { [ 'glibc.i686', 'ncurses-libs.i686', 'libgcc.i686' ]:
        ensure  => installed,
    }

    package {'nftracker.i386':
        ensure  => installed,
        require => Package['glibc.i686', 'ncurses-libs.i686', 'libgcc.i686'],
    }

    common::nfsmount { '/data/fnet':
        device  => 'nfsB-netapp1.gnmedia.net:/vol/nac1b_app1v_nft_tp_lax_prd_fnet',
    }
}
