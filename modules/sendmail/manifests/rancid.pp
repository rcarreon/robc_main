# sendmail::rancid
class sendmail::rancid inherits sendmail {

    file { '/etc/aliases':
        ensure  => file,
        owner   => root,
        group   => root,
        mode    => '0644',
        source  => 'puppet:///modules/sendmail/rancid.aliases',
        require => Package['sendmail'],
        notify  => Service['sendmail'],
    }

}
