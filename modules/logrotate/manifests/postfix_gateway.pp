# logrotate for postfix files
class logrotate::postfix_gateway{
    include logrotate

    file{'logrotate-postfix':
        ensure  => file,
        path    => '/etc/logrotate.d/postfix',
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        content => template('logrotate/postfix.erb'),
        require => Package['logrotate'],
    }

    file{'logrotate-amavisd':
        ensure  => file,
        path    => '/etc/logrotate.d/amavisd',
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        content => template('logrotate/amavisd.erb'),
        require => Package['logrotate'],
    }
}
