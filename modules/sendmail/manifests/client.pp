# sendmail::client
class sendmail::client inherits sendmail {
    file { '/etc/mail/submit.cf':
        ensure  => file,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        require => Package['sendmail'],
        notify  => Service['sendmail'],
    }
}
