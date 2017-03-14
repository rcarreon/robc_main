# main class for sendmail
class sendmail {
    package { 'sendmail':
        ensure => present,
    }

    package { 'nagios-plugins-mailq':
        ensure => present,
    }

    nagios::service {'check_sendmail_queue':
        command     => 'check_nrpe_args!check_mailq!sendmail',
        notes_url   => 'http://docs.gnmedia.net/wiki/Nagios-sendmail_queue',
    }

    service { 'sendmail':
        ensure      => running,
        enable      => true,
        hasstatus   => true,
        require     => Package['sendmail'],
    }

    file { '/etc/mail/sendmail.cf':
        ensure  => file,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        require => Package['sendmail'],
        notify  => Service['sendmail'],
    }
}

