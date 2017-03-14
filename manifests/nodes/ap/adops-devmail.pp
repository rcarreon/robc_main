# trap outbound email and send to a distribution list
class adops::devmail {
    include sendmail

    file { '/etc/mail/mailertable':
       ensure  => file,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        content => ".\trelay:addevelopers@evolvemediallc.com",
        notify  => Service['sendmail'],
    }
}

