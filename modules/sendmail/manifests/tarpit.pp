# sendmail::tarpit
# Force sendmail to send all mail to a logfile specified at the bottom of /etc/aliases
class sendmail::tarpit inherits sendmail::devel {

    File ['/etc/mail/sendmail.cf'] {
        source => 'puppet:///modules/sendmail/sink.cf',
    }

    file { '/etc/mail/sink.mc':
        ensure  => file,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        source  => 'puppet:///modules/sendmail/sink.mc',
        require => Package['sendmail-cf'],
        notify  => Service['sendmail'],
    }

    file { '/etc/mail/mailertable':
        ensure  => file,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        source  => 'puppet:///modules/sendmail/sink.mailertable',
        require => Package['sendmail'],
        notify  => Service['sendmail'],
    }

    file { '/etc/aliases':
        ensure  => file,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        source  => 'puppet:///modules/sendmail/sink.aliases',
        require => Package['sendmail'],
        notify  => Service['sendmail'],
    }
}
