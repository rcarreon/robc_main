
class kestrel::install {

    # create kestrel user and group

    group { 'kestrel':
        ensure => 'present',
        gid => '110',
    }

    user { 'kestrel':
        ensure   => 'present',
        home     => '/var/run/kestrel',
        shell    => '/sbin/nologin',
        comment  => 'kestrel service account',
        password => '!!',
        uid      => '110',
        gid      => 'kestrel',
        require  => Group["kestrel"],
    }

    # install RPMs.  The kestrel and daemon packages are in the gnrepo-live repo.

    package { ["java-1.6.0-openjdk","kestrel","daemon"]:
        ensure => installed,
    }

    # setup directories and symlinks needed by Kestrel 2.3.1

    # Kestrel uses a capistrano-style current symlink
    # to select the kestrel version to run.
    file { "/usr/local/kestrel/current":
        ensure => link,
        target => "kestrel-2.3.1",
        require => Package['kestrel'],
    }

    # If this directory does not exist, kestrel will not be able to
    # cache configs, and will also log a (harmless?) error.
    file { "/usr/local/kestrel/kestrel-2.3.1/config/target":
        ensure => directory,
        owner => kestrel,
        group => kestrel,
        mode => 755,
        require => Package['kestrel'],
    }

    # The scripts included with kestrel look for the kestrel jars in the 
    # libs/ subdirectory, and in the case of the tests jar, by the wrong name.
    file { ["/usr/local/kestrel/kestrel-2.3.1/kestrel-tests-2.3.1.jar"]:
        ensure => link,
        target => "kestrel_2.9.1-2.3.1-test.jar",
        require => Package['kestrel'],
    }

    file { "/usr/local/kestrel/kestrel-2.3.1/libs/kestrel_2.9.1-2.3.1-javadoc.jar":
        ensure => link,
        target => "/usr/local/kestrel/kestrel-2.3.1/kestrel_2.9.1-2.3.1-javadoc.jar",
        require => Package['kestrel'],
    }
                 
    file { "/usr/local/kestrel/kestrel-2.3.1/libs/kestrel_2.9.1-2.3.1-sources.jar":
        ensure => link,
        target => "/usr/local/kestrel/kestrel-2.3.1/kestrel_2.9.1-2.3.1-sources.jar",
        require => Package['kestrel'],
    }
                 
    file { "/usr/local/kestrel/kestrel-2.3.1/libs/kestrel_2.9.1-2.3.1-test.jar":
        ensure => link,
        target => "/usr/local/kestrel/kestrel-2.3.1/kestrel_2.9.1-2.3.1-test.jar",
        require => Package['kestrel'],
    }
                 
    file { "/usr/local/kestrel/kestrel-2.3.1/libs/kestrel_2.9.1-2.3.1.jar":
        ensure => link,
        target => "/usr/local/kestrel/kestrel-2.3.1/kestrel_2.9.1-2.3.1.jar",
        require => Package['kestrel'],
    }

    # Logrotate
    include logrotate

    file { "kestrel_logrotate":
        path    => "/etc/logrotate.d/kestrel",
        ensure  => file,
        owner   => root,
        group   => root,
        mode    => 644,
        require => Package["logrotate"],
        content => template("kestrel/logrotate.erb"),
    }

}
