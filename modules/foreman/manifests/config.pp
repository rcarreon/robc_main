# Class: foreman::config

class foreman::config {
    file { '/etc/foreman':
        ensure  => directory,
        owner   => 'root',
        group   => 'root',
        mode    => '0755',
    }

    file { '/etc/foreman/database.yml':
        content => template('foreman/database.yml.erb'),
        require => File['/etc/foreman'],
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
    }

    file { '/etc/foreman/email.yaml':
        content => template('foreman/email.yaml.erb'),
        require => File['/etc/foreman'],
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
    }

    file { '/etc/foreman/settings.yaml':
        content => template('foreman/settings.yaml.erb'),
        require => File['/etc/foreman'],
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
    }

    file { '/etc/httpd/conf.d/foreman.conf':
        content => template('foreman/foreman.conf.erb'),
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
    }

}
