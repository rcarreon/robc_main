# puppet_master_27::service
class puppet_master_27::service {

    include httpd

    service { 'puppetmaster':
        enable   => false,
        pattern  => puppetmaster,
        require  => [Class['puppet_master_27::config'], Class['httpd']],
    }

    service { 'puppet':
        enable     => true,
        hasstatus  => true,
        require    => Class['puppet_master_27::config'],
    }

}
