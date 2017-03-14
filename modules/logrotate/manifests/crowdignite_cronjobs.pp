# logrotate for crowdignite cakephp
class logrotate::crowdignite_cronjobs {
    include logrotate
    file {'cronjobs':
        path    => '/etc/logrotate.d/cronjobs',
        content => template('logrotate/crowdignite_cronjobs.erb'),
        require => Class['logrotate'],
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
    }
}
