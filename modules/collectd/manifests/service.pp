class collectd::service {
    service {'collectd':
        enable    => true,
        hasstatus => true,
        require   => Class['collectd::config'],
    }
}
