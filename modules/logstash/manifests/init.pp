class logstash ($template = "logstash-generic", $redis_servers = []) { 
    include logstash::install

    $ls_debug = $fqdn_incr ? {
        /^10/   => "false",    # for prd
        /^20/   => "true",     # for stg
        /^30/   => "true",     # for dev
        default => "true",     # for dev
    }
    $ls_flush_size = $fqdn_incr ? {
        /^10/   => "100",    # for prd
        /^20/   => "2",      # for stg
        /^30/   => "2",      # for dev
        default => "2",      # for dev
    }
    
    file {"/etc/logstash/logstash.conf":
        owner    => "root",
        group    => "root",
        mode     => "0644",
        content  => template("logstash/${template}.conf.erb"),
        require  => [Class["logstash::install"]],
    }

    file {"/etc/logstash/patterns":
        ensure   => directory,
        owner    => "root",
        group    => "root",
        mode     => "0755",
    }
    file {"/etc/logstash/patterns/groks":
        ensure   => file,
        owner    => "root",
        group    => "root",
        mode     => "0644",
        source   => "puppet:///modules/logstash/patterns-groks"
    }
    file {"/etc/sysconfig/logstash":
        owner    => "root",
        group    => "root",
        mode     => "0644",
        content  => "LOGSTASH_LOGLEVEL=none",
    }

    service {"logstash":
        enable    => true,
        hasstatus => true,
        require   => [File["/etc/logstash/logstash.conf"],File["/etc/sysconfig/logstash"]],
    }

    nagios::service {"logstash":
        command	=> "check_tcp!2233",
        normal_check_interval => "3",
        notes_url => "http://docs.gnmedia.net/wiki/Nagios-logstash",
    }
}
