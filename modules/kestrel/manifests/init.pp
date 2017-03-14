
class kestrel {

    include kestrel::install
    include kestrel::monitor

    # these are the only directories into which kestrel should write files.
    file { ["/app/log/kestrel","/var/run/kestrel","/app/shared/kestrel","/app/shared/kestrel/queue"]:
        ensure => directory,
        owner => kestrel,
        group => kestrel,
        mode => 755,
    }

    # JVM settings and the name of the scala config file can be set here and
    # will override the defaults in the init script.
    file { "kestrel_sysconfig":
        content => template("kestrel/${project}/${kestrelenv}.sysconfig"),
        path    => "/etc/sysconfig/kestrel",
        owner   => 'root',
        group   => 'root',
        mode    => "0644",
    }

    # The scala config file is a list of scala expressions loaded at runtime.
    file { "kestrel_scala_config":
        content => template("kestrel/${project}/${kestrelenv}.scala"),
        path    => "/usr/local/kestrel/current/config/${project}.scala",
        owner   => 'root',
        group   => 'root',
        mode    => "0644",
        require => Class["kestrel::install"],
    }

}
