# sendmail::logroot
class sendmail::logroot inherits sendmail {

    # Force sendmail to send root's mail to a logfile specified at the bottom of /etc/aliases
    file { '/etc/aliases':
        ensure  => file,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        source  => 'puppet:///modules/sendmail/logroot.aliases',
        require => Package['sendmail'],
        notify  => Service['sendmail'],
    }
}
