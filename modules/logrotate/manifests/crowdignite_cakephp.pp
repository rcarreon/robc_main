# logrotate for crowdignite cakephp
class logrotate::crowdignite_cakephp {
    include logrotate
    file {'cakephp':
        path    => '/etc/logrotate.d/cakephp',
        content => template('logrotate/crowdignite_cakephp.erb'),
        require => Class['logrotate'],
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
    }
}
