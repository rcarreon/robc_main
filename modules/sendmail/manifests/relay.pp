# sendmail::relay
class sendmail::relay inherits sendmail::devel {
    File ['/etc/mail/sendmail.cf'] {
        content => template('sendmail/relay-sendmail.cf'),
    }

    file { '/etc/mail/access':
    # Networks that we will talk to
        ensure  => file,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        source  => 'puppet:///modules/sendmail/relay-access',
        require => Package['sendmail'],
    }

    file { '/etc/mail/relay-domains':
    # Domains that we relay for
        ensure  => file,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        source  => 'puppet:///modules/sendmail/relay-domains',
        require => Package['sendmail'],
        notify  => Service['sendmail'],
    }
}
