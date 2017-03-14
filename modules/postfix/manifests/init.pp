# postfix is used on the app-mta servers
class postfix {

    service { 'sendmail':
        ensure      => stopped,
        enable      => false,
        hasstatus   => true,
    }

    package { 'sendmail':
        ensure => absent,
    }

    package { 'nagios-plugins-mailq':
        ensure => present,
    }

    nagios::service {'check_postfix_queue':
        command     => 'check_nrpe_args!check_mailq!postfix',
        notes_url   => 'http://docs.gnmedia.net/wiki/Nagios-postfix_queue',
    }

}
