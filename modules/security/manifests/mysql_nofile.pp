# usage: 	class security::mysql_nofile(32768,24576)

# default limit set to not effect behavior 
class security::mysql_nofile( $hard_file_limit = 1024, $soft_file_limit = 1024)  {

    file {'/etc/security/limits.d/mysql_nofile.conf':
        content => template('security/mysql_nofile.conf.erb'),
        owner   => root,
        group   => root,
        mode    => 664,
        ensure  => present,
    }
}
