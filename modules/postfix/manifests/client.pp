# postfix::client class
# NOTE:  this class does not work.  It has dependencies on the postfix package
#        and service, but they are not configured either here or in init.pp.
#        I'm leaving the file in place in case it is someone's work-in-progress.
#
class postfix::client inherits postfix {
    file { '/etc/postfix/main.cf':
        ensure  => file,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        require => Package['postfix'],
        notify  => Service['postfix'],
        source  => 'puppet:///modules/postfix/client-main.cf',
    }

    file { '/etc/postfix/master.cf':
        ensure  => file,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        require => Package['postfix'],
        notify  => Service['postfix'],
        source  => 'puppet:///modules/postfix/client-master.cf',
    }

}
