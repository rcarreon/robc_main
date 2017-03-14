# Class: logrotate::mysql55
#
# Sample Usage:
# - include logrotate::mysql55
#
class logrotate::mysql55{
    include logrotate

    file{'logrotate-mysql55':
        ensure  => file,
        path    => '/etc/logrotate.d/mysql',
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        content => template('logrotate/mysqld55.erb'),
        require => Package['logrotate'],
    }
}
