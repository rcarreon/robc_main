# sendmail::useGateway
class sendmail::use_gateway inherits sendmail {

    package { 'sendmail-cf':
        ensure => present,
    }

    file { '/etc/mail/sendmail.mc':
        ensure  => file,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        source  => 'puppet:///modules/sendmail/gateway.sendmail.mc',
        require => Package['sendmail'],
        notify  => Service['sendmail'],
    }

}
