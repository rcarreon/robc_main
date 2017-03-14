# puppet_master_3::config class
class puppet_master_3::config {

    File{
        require => Class['puppet_master_3::packages'],
    }

    # Create the directories
    file {  [ '/usr/share/puppet/',
              '/usr/share/puppet/rack/',
              '/usr/share/puppet/rack/puppetmasterd/',
              '/usr/share/puppet/rack/puppetmasterd/public/' ]:
        ensure  => directory,
        owner   => 'root',
        group   => 'root',
        mode    => '0755',
    }

    # This array will be used by the template below.
    $puppet_dev = ['ifimbres', 'fbernal', 'evazquez', 'rangel', 'rcarreon']
    file { '/etc/puppet/puppet.conf':
        ensure    => present,
        content   => template('puppet_master_3/puppet.conf.erb'),
        owner     => 'root',
        group     => 'root',
        mode      => '0644',
    }

    file { '/etc/sysconfig/puppet':
        ensure    => present,
        content   => template('puppet_master_3/sysconfig_puppet.erb'),
        owner     => 'root',
        group     => 'root',
        mode      => '0644',
    }

    # Make the version.txt files available
    file {'/usr/share/puppet/rack/puppetmasterd/public/development.txt':
                ensure  => link,
                target  => '/app/shared/modules/development/version.txt',
    }

    file {'/usr/share/puppet/rack/puppetmasterd/public/staging.txt':
                ensure  => link,
                target  => '/app/shared/modules/staging/version.txt',
    }

    file {'/usr/share/puppet/rack/puppetmasterd/public/production.txt':
                ensure  => link,
                target  => '/app/shared/modules/production/version.txt',
    }

    file { '/usr/share/puppet/rack/puppetmasterd/tmp/':
        ensure  => directory,
        owner   => apache,
        group   => deploy,
        mode    => '0775',
    }

    file {  [ '/app/log/puppet',
              '/var/puppet',
              '/var/puppet/yaml',
              '/var/puppet/yaml/facts',
              '/var/puppet/log',
              '/var/lib/puppet/files' ]:
        ensure  => directory,
        owner   => puppet,
        group   => puppet,
        mode    => '0755',
    }

    # Puppet httpd config
    file { '/usr/share/puppet/rack/puppetmasterd/config.ru':
        ensure  => present,
        require => File['/usr/share/puppet/rack/puppetmasterd/'],
        owner   => puppet,
        group   => puppet,
        content => template('puppet_master_3/config.ru.erb'),
        mode    => '0644',
    }

    file { '/etc/httpd/conf.d/puppet.conf':
        ensure  => present,
        content => template('puppet_master_3/puppet_httpd.conf.erb'),
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
    }

    file { '/etc/httpd/conf.d/ssl.conf':
        ensure  => present,
        content => template('puppet_master_3/ssl.conf.erb'),
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
    }

    file { '/etc/puppet/tagmail.conf':
        ensure  => present,
        source  => 'puppet:///modules/puppet_master_3/tagmail.conf',
        owner   => root,
        group   => root,
        mode    => '0644',
    }

    file {'/etc/puppet/fileserver.conf':
        ensure  => present,
        source  => 'puppet:///modules/puppet_master_3/fileserver.conf',
        owner   => root,
        group   => root,
        mode    => '0644',
    }

    file {'/etc/puppet/autosign.conf':
        ensure  => present,
        source  => 'puppet:///modules/puppet_master_3/autosign.conf',
        owner   => root,
        group   => root,
        mode    => '0644',
    }

    file {'/usr/local/bin/return_version':
        ensure  => present,
        source  => 'puppet:///modules/puppet_master_3/return_version',
        owner   => root,
        group   => root,
        mode    => '0755',
    }

    file {'/usr/lib/ruby/site_ruby/1.8/puppet/reports/foreman.rb':
        ensure  => present,
        source  => 'puppet:///modules/puppet_master_3/foreman.rb',
        mode    => '0755',
        owner   => 'deploy',
        group   => 'deploy',
    }

    file {'/usr/local/bin/kill_node_in_storeconfigs_db.rb':
        ensure  => present,
        source  => 'puppet:///modules/puppet_master_3/kill_node_in_storeconfigs_db.rb',
        owner   => 'root',
        group   => 'root',
        mode    => '0755',
    }

    file {'/usr/local/bin/encrypt.rb':
        ensure  => present,
        source  => 'puppet:///modules/puppet_master_3/encrypt.rb',
        owner   => 'root',
        group   => 'root',
        mode    => '0755',
    }

}
