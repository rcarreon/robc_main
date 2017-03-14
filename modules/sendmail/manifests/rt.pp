# sendmail::rt
class sendmail::rt inherits sendmail {
    package { 'sendmail-cf':
        ensure => present,
    }

    file { '/etc/aliases':
        ensure  => file,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        source  => 'puppet:///modules/sendmail/rt.aliases',
        require => Package['sendmail'],
        notify  => Service['sendmail'],
    }

    file { '/etc/mail/local-host-names':
        ensure  => file,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        source  => 'puppet:///modules/sendmail/rt.local-host-names',
        require => Package['sendmail'],
        notify  => Service['sendmail'],
    }

    file { '/etc/mail/sendmail.mc':
        ensure  => file,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        source  => 'puppet:///modules/sendmail/rt.sendmail.mc',
        require => Package['sendmail'],
        notify  => Service['sendmail'],
    }

    file { '/etc/smrsh/tnef-filter':
        ensure  => file,
        owner   => 'root',
        group   => 'root',
        mode    => '0755',
        source  => 'puppet:///modules/sendmail/tnef-filter',
        require => Package['sendmail'],
        notify  => Service['sendmail'],
    }

    file { '/etc/smrsh/tnef-wrapper':
        ensure  => file,
        owner   => 'root',
        group   => 'root',
        mode    => '0755',
        source  => 'puppet:///modules/sendmail/tnef-wrapper',
        require => Package['sendmail'],
        notify  => Service['sendmail'],
    }

    file { '/etc/mail/virtusertable':
        ensure  => file,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        source  => 'puppet:///modules/sendmail/rtqt.virtusertable',
        require => Package['sendmail'],
        notify  => Service['sendmail'],
    }
}