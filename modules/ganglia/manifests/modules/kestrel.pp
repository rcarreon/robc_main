class ganglia::modules::kestrel {
    file { "/etc/ganglia/conf.d/kestrel.pyconf":
        ensure  => present,
        owner   => "root",
        group   => "root",
        content => template("ganglia/modules/kestrel.pyconf.erb"),
        notify  => Service["gmond"],
    }
    file { "/usr/lib64/ganglia/python_modules/kestrel.py":
        ensure  => present,
        owner   => "root",
        group   => "root",
        content => template("ganglia/modules/kestrel.py.erb"),
        notify  => Service["gmond"],
    }
}
