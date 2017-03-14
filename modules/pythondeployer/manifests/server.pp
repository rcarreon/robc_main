class pythondeployer::server {

    $deployreq = ['python-argparse', 'python-paramiko', 'MySQL-python']

    package { $deployreq:
        ensure => installed,
    }

    file { '/etc/pythondeployer':
        ensure => directory,
        owner  => 'deploy',
        group  => 'springboardsvn',
        mode   => '0750',
    }

    file { '/usr/local/bin/deploy.py':
        ensure => file,
        owner  => 'deploy',
        group  => 'springboardsvn',
        mode   => '0775',
        source => 'puppet:///modules/pythondeployer/deploy.py', 
    }

    file { '/etc/pythondeployer/deploy_config':
        ensure  => file,
        owner   => 'deploy',
        group   => 'deploy',
        mode    => '0775',
        source  => 'puppet:///modules/pythondeployer/deploy_config',
        require => File['/etc/pythondeployer'],
    }
}
