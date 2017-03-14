class jenkinsng::master inherits jenkinsng {

    include yum::jenkins

    package { 'jenkins':
        ensure  => 'installed',
        require => Class['yum::jenkins'],
    }

    file { '/etc/sysconfig/jenkins':
        ensure  => present,
        owner   => root,
        group   => root,
        mode    => '0600',
        content => template('jenkinsng/sysconfig-jenkins.erb')
    }

    file { '/var/cache/jenkins':
        ensure => directory,
        owner  => 'deploy',
        group  => 'deploy',
        mode   => '0750',
    }

}