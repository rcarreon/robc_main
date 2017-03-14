# sendmail monitor nagios check wrapping check_smtp
class sendmail::monitor {

    package { 'nagios-plugins-smtp':
        ensure => present,
    }

    nagios::service { 'mailcheck':
        ensure    => 'present',
        command   => 'check_nrpe!check_localhost_smtp',
        notes_url => 'http://docs.gnmedia.net/wiki/Nagios-mailcheck'
    }
}

