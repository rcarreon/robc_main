# default limit set to not effect behavior 
class security::flume_nofile($hard_file_limit = 65536, $soft_file_limit = 4096)  {

    file {'/etc/security/limits.d/flume_nofile.conf':
        content => template('security/flume_nofile.conf.erb'),
        owner   => root,
        group   => root,
        mode    => 664,
        ensure  => present,
    }
}
