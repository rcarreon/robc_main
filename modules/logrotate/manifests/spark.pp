# Class: logrotate::spark
#
# Sample Usage:
# - include logrotate::spark
#
class logrotate::spark{
    include logrotate
    file{'logrotate-spark':
        ensure  => file,
        path    => '/etc/logrotate.d/spark',
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        content => template('logrotate/spark.erb'),
        require => Package['logrotate'],
    }
}
