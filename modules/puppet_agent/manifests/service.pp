# puppet_agent::service
class puppet_agent::service {

    service { 'puppet':
        #ensure   => running,
        enable    => true,
        hasstatus => true,
        require   => Class['puppet_agent::config'],
        #subscribe => [File['/etc/puppet/puppet.conf'], File['/etc/sysconfig/puppet']],
    }

}
