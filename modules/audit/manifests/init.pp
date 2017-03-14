class audit {
    package {"audit":
        ensure => installed,
    }
    service {"auditd":
        hasstatus => true,
        enable => true,
        ensure => running,
        require => Package["audit"],
    }

    file {"/etc/audisp/plugins.d/syslog.conf":
        ensure => file,
        content => "# This file is written by the audit module in puppet
        active = yes
        direction = out
        path = builtin_syslog
        type = builtin
        args = LOG_LOCAL5 LOG_INFO
        format = string",
        owner => "root",
        group => "root",
        mode => '0644',
        notify => Service["auditd"],
        require => Package["audit"],
    }
    file {"/etc/audit/audit.rules":
        ensure => file,
        source => "puppet:///modules/audit/audit.rules",
        mode => '0600',
        owner => "root",
        group => "root",
        notify => Service["auditd"],
        require => Package["audit"],
    }

}
