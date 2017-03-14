class ganglia::modules::netapp_api_vertical {
    $netapppasswd=decrypt("I3BV0jDTUi2M1tsqCEm4bA==")
    file { "/etc/ganglia/conf.d/netapp_api_vertical.pyconf":
        ensure  => present,
        owner   => "root",
        group   => "root",
        content => template("ganglia/modules/netapp_api_vertical.pyconf.erb"),
        notify  => Service["gmond"],
    }

    file { "/usr/lib64/ganglia/python_modules/netapp_api_vertical.py":
        ensure  => present,
        owner   => "root",
        group   => "root",
        content => template("ganglia/modules/netapp_api_vertical.py.erb"),
        mode    => "600",  
        notify  => Service["gmond"],
    }
}
