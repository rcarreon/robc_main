# puppet_master_3::service
class puppet_master_3::service {

    include httpd

    service { 'puppetmaster':
        enable   => false,
        pattern  => puppetmaster,
        require  => [Class['puppet_master_3::config'], Class['httpd']],
    }

    service { 'puppet':
        enable     => true,
        hasstatus  => true,
        require    => Class['puppet_master_3::config'],
    }

}
