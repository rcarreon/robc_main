class jenkinsng {

    $reqpkg = ['java-1.7.0-openjdk', 'git', 'rubygems']
    
    package { $reqpkg:
        ensure => installed,
    }

    user { "apache":
        ensure  => present,
        uid     => '48',
        gid     => '48',
        home    => '/var/www',
        shell   => '/sbin/nologin',
        require => Group['apache'],
    }

    group { 'apache':
        ensure => present,
        gid    => '48',
    }

    file { '/app/shared/jenkins':
        ensure => directory,
        owner  => 'deploy',
        group  => 'deploy',
        mode   => '750',
    }

    file { "/app/shared/jenkins/$fqdn":
        ensure => directory,
        owner  => 'deploy',
        group  => 'deploy',
        mode   => '750',
    }

}
