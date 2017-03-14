# Class: logrotate::hadoop
#
# Sample Usage:
# - include logrotate::hadoop
#
class logrotate::hadoop{
    include logrotate
    file{'logrotate-hadoop':
        ensure  => file,
        path    => '/etc/logrotate.d/hadoop',
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        content => template('logrotate/hadoop.erb'),
        require => Package['logrotate'],
    }
}
