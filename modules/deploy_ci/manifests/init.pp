class deploy_ci {

    file { '/usr/local/bin/deploy_ci.sh':
        ensure  => 'present',
        owner   => 'root',
        group   => 'root',
        mode    => '0755',
        source  => 'puppet:///modules/deploy_ci/deploy_ci.sh',
    }

    file { '/usr/local/yuicompressor':
        ensure => directory,
        owner  => 'root',
        group  => 'root',
        mode   => '0744',
    }

    file { '/usr/local/yuicompressor/yuicompressor-2.4.8.jar':
        ensure => 'present',
        owner  => 'root',
        group  => 'root',
        mode   => '0744',
        source => 'puppet:///modules/deploy_ci/yuicompressor-2.4.8.jar',
        require => File['/usr/local/yuicompressor'],
    }

}
