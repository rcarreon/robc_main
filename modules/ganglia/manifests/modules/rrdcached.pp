class ganglia::modules::rrdcached {
    file { "/etc/ganglia/conf.d/rrdcached.pyconf":
        ensure  => present,
        owner   => "root",
        group   => "root",
        content => template("ganglia/modules/rrdcached.pyconf.erb"),
        notify  => Service["gmond"],
    }
    file { "/usr/lib64/ganglia/python_modules/rrdcached.py":
        ensure  => present,
        owner   => "root",
        group   => "root",
        content => template("ganglia/modules/rrdcached.py.erb"),
        notify  => Service["gmond"],
    }
}
