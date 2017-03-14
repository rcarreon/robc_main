# Class:  jenkins::centos6client
    class jenkins::centos6client inherits jenkins {

    include nagios::client
    include rubygems::flog
    include git::client

    $packages_dev = ['gcc']
    $packages_X = ['firefox', 'xorg-x11-server-Xvfb']

    # java jre for running jenkins.  Compiling java based projects would
    # require the additional installation of openjdk-devel (jdk).
    $packages_java = ['java-1.6.0-openjdk']

    # For python based projects
    $packages_python = ['python-pip', 'pylint', 'python-virtualenv']

    # Required for puppet-lint
    $packages_puppet = ['rubygem-puppet-lint']

    package {[$packages_X, $packages_java, $packages_python, $packages_dev, $packages_puppet]:
        ensure => present,
    }

    package {'bind':
        ensure => present,
    }

    # start/stop xvfb script
    file {'/etc/init.d/xvfb':
        require => Package['xorg-x11-server-Xvfb'],
        source  => 'puppet:///modules/jenkins/init_xvfb',
        mode    => '0755',
        owner   => 'deploy',
        group   => 'deploy',
    }

    include monit::xvfb

    # Data store for job and workspace
    file {"/app/shared/slave-${::hostname}":
        ensure  => directory,
        owner   => 'deploy',
        group   => 'deploy',
        mode    => '0755',
    }

    # Data store for jenkins clients which do git-puppet builds.
    # Due to NFS locking issues, it needs to be on local disk.
    file {'/app/local':
        ensure  => directory,
        owner   => 'deploy',
        group   => 'deploy',
        mode    => '0755',
    }

    # Log dir for various app
    file {"/app/shared/slave-${::hostname}/log":
        ensure  => directory,
        owner   => 'deploy',
        group   => 'deploy',
        require => File["/app/shared/slave-${::hostname}"],
        mode    => '0755',
    }

    # If jmeter needs to be installed in the future, we should build an rpm
    # instead of checking binaries into our vcs.
    #file {'/app/shared/jmeter':
    #    recurse => true,
    #    source  => 'puppet:///modules/jenkins/clients/jakarta-jmeter-2.4',
    #    ignore  => ['.svn'],
    #    owner   => 'deploy',
    #    group   => 'deploy',
    #}

}
