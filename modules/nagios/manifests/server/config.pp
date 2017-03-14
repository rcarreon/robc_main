# nagios server conf
class nagios::server::config {
    include nagios::server::plugins

    # directories
    file { '/var/log/nagios/rw/':
        ensure  => directory,
        mode    => '0744',
        owner   => 'nagios',
        group   => 'nagios',
    }

    # remove these files / folders
    file { '/etc/nagios/private':
        ensure => absent,
        force  => true,
    }

    file { '/etc/nagios/objects':
        ensure => absent,
        force  => true,
    }
    file { '/etc/nagios/localhost.cfg':
        ensure => absent,
    }

      file { '/etc/nagios/conf.d/internet.cfg':
        ensure => absent,
    }

    # config files
    file { '/etc/nagios/nagios.cfg':
        ensure => present,
        mode   => '0444',
        owner  => 'root',
        group  => 'root',
        notify => Service['nagios'],
        source => 'puppet:///modules/nagios/nagios.cfg',
    }
    file { '/etc/nagios/cgi.cfg':
        ensure  => present,
        mode    => '0444',
        owner   => 'root',
        group   => 'root',
        notify  => Service['nagios'],
        content => template('nagios/cgi.cfg.erb'),
    }
    file { '/etc/nagios/resource.cfg':
        ensure => present,
        mode   => '0440',
        owner  => 'nagios',
        group  => 'sysadmins',
        notify => Service['nagios'],
        source => 'puppet:///modules/nagios/resources.cfg',
    }
    file { '/etc/nagios/services.cfg':
        ensure => present,
        mode   => '0444',
        owner  => 'root',
        group  => 'root',
        notify => Service['nagios'],
        source => 'puppet:///modules/nagios/services.cfg',
    }
    file { '/etc/nagios/servicegroups.cfg':
        ensure => present,
        mode   => '0444',
        owner  => 'root',
        group  => 'root',
        notify => Service['nagios'],
        source => 'puppet:///modules/nagios/servicegroups.cfg',
    }
    file { '/etc/nagios/hostgroups.cfg':
        ensure  => present,
        mode    => '0444',
        owner   => 'root',
        group   => 'root',
        notify  => Service['nagios'],
        content => template('nagios/hostgroups.cfg.erb'),
    }

    file { '/etc/nagios/generic.cfg':
        ensure => present,
        mode   => '0444',
        owner  => 'root',
        group  => 'root',
        notify => Service['nagios'],
        source => 'puppet:///modules/nagios/generic.cfg',
    }
    file { '/etc/nagios/contacts.cfg':
        ensure => present,
        mode   => '0444',
        owner  => 'root',
        group  => 'root',
        notify => Service['nagios'],
        source => 'puppet:///modules/nagios/contacts.cfg',
    }
    file { '/etc/nagios/commands.cfg':
            ensure => present,
            mode   => '0444',
            owner  => 'root',
            group  => 'root',
            notify => Service['nagios'],
            source => 'puppet:///modules/nagios/commands.cfg',
    }

    file { '/etc/nagios/miscommands.cfg':
        ensure  => present,
        mode    => '0444',
        owner   => 'root',
        group   => 'root',
        notify  => Service['nagios'],
        content => template('nagios/miscommands.cfg.erb'),
    }

  # Dashboard on mon default vhost so it doesn't need require auth
    file { '/var/www/html/nagios.php':
        ensure  => present,
        mode    => '0444',
        owner   => 'root',
        group   => 'root',
        require => Package['httpd'],
        content => template('nagios/nagios.php'),
    }

  # Plugins
    file { '/usr/lib64/nagios':
        ensure  => directory,
        require => Package['nagios-plugins'],
        owner   => 'root',
        group   => 'root',
        mode    => '0755',
    }

    file { '/usr/lib64/nagios/plugins/check_monit':
        ensure => present,
        owner  => 'root',
        group  => 'sysadmins',
        mode   => '0755',
        source => 'puppet:///modules/nagios/check_monit',
    }

    file { '/usr/lib64/nagios/plugins/check_http_json.rb':
        ensure => present,
        owner  => 'root',
        group  => 'sysadmins',
        mode   => '0755',
        source => 'puppet:///modules/nagios/check_http_json.rb',
    }

    file { '/usr/lib64/nagios/plugins/check_nagios_config':
        ensure => present,
        owner  => 'root',
        group  => 'root',
        mode   => '0755',
        source => 'puppet:///modules/nagios/check_nagios_config',
    }
}
