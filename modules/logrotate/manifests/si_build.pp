# logrotate for si_build
class logrotate::si_build {

    include logrotate

    file { 'si_build':
        ensure  => file,
        path    => '/etc/logrotate.d/si_build',
        content => template('logrotate/si_build.erb'),
        require => Class['logrotate'],
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
    }
}

