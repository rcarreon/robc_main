# logrotate for sbv
class logrotate::sbv {

    include logrotate

    file { '/app/shared/cms-logs':
        ensure => directory,
        mode   => '0755',
        owner  => 'apache',
        group  => 'apache',
    }

    file { 'sbv':
        ensure  => file,
        path    => '/etc/logrotate.d/sbv',
        content => template('logrotate/sbv.erb'),
        require => Class['logrotate'],
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
    }
}
