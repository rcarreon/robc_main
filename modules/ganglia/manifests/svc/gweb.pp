class ganglia::svc::gweb ( $serviceStart = "running", $serviceEnable = "true") {
    service { "gmetad":
        ensure  => $serviceStart, 
        enable  => $serviceEnable,
        require => [Class["ganglia::pkg::gweb"],Service["rrdcached"]]
    }
    service { "rrdcached":
        ensure  => $serviceStart, 
        enable  => $serviceEnable,
        require => Class["ganglia::pkg::gweb"],
    }

    file { '/usr/local/sbin/rrdbackup':
        ensure => $serviceEnable ? { "true" => file, default => absent },
        source => 'puppet:///modules/ganglia/rrdbackup',
        owner  => 'root',
        group  => 'root',
        mode   => '0755',
    }
    file { '/usr/local/sbin/rrdrestore':
        ensure => $serviceEnable ? { "true" => file, default => absent },
        source => 'puppet:///modules/ganglia/rrdrestore',
        owner  => 'root',
        group  => 'root',
        mode   => '0755',
    }
    cron { rrdbackup:
        ensure => $serviceEnable ? { "true" => present, default => absent },
        command => "/usr/local/sbin/rrdbackup",
        user => root,
        hour => '2',
        minute => '8',
    }


}
