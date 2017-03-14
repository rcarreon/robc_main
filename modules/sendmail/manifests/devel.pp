# sendmail::devel
class sendmail::devel inherits sendmail {

    package { 'sendmail-cf':
        ensure  => present,
        require => Package['sendmail'],
        notify  => Service['sendmail'],
    }
}
