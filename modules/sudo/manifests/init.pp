class sudo {

    package { sudo: ensure => installed }

    file { '/etc/sudoers':
        ensure  => present,
        owner   => 'root',
        group   => 'root',
        mode    => '0440',
    	content => template('sudo/sudoers'),
        require => Package['sudo'],
    }

    file { '/etc/sudoers.d/':
        ensure  => directory,
        purge   => true,
        recurse => true,
        owner   => 'root',
        group   => 'root',
        mode    => '0750',
    }
        
}

