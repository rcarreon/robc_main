class pythondeployer {

    package { 'python-argparse':
        ensure => installed,
    }

    file {'/usr/local/bin/deploy-agent.py':
        ensure => file,
        owner  => 'deploy',
        group  => 'deploy',
        mode   => '0550',
        source => 'puppet:///modules/pythondeployer/deploy-agent.py',
    }
}
