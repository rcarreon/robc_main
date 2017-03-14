# class puppet_agent::config
class puppet_agent::config {

    File {
        require => Class['puppet_agent::packages'],
    }

    file {  '/etc/puppet/puppet.conf':
        ensure    => present,
        content   => template('puppet_agent/puppet.conf.erb'),
        owner     => 'root',
        group     => 'root',
        mode      => '0644',
    }

    file { '/etc/sysconfig/puppet':
        ensure    => present,
        content   => template('puppet_agent/sysconfig_puppet.erb'),
        owner     => 'root',
        group     => 'root',
        mode      => '0644',
    }

}
