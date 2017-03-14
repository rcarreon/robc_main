# Class: client
#
# This is the client in the jenkins module.
class jenkins::client inherits jenkins {

    include nagios::client
    include rubygems::flog
    include git::client

    $packages_dev = ['gcc']
    $packages_X = ['vnc-server', 'firefox', 'xorg-x11-fonts-truetype', 'xorg-x11-server-Xvfb']

    # For ruby based projects, rubygems are installed by default with class rubygems of base
    $packages_ruby = ['ruby-devel', 'ruby-rdoc']

    # Package scm (we are alread a subversion::client)
    package {[$packages_X, $packages_ruby, $packages_dev]:
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

    # xvfb and vnc requires a running font server
    service { 'xfs':
        ensure => running,
    }
    include monit::xvfb

    # Data store for job and workspace
    file {"/app/shared/slave-${::hostname}":
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
    #}

}
