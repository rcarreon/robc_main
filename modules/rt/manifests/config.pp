# config class for rt
class rt::config {
    File{
        require => Class['rt::install'],
        owner   => 'root',
        group   => 'root',
        mode    => 644
    }

    file {'/etc/httpd/conf.d/rt3.conf':
        ensure => absent,
    }
}
