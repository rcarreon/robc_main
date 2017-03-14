# monit service on
class monit::service {
    service{'monit':
        ensure    => running,
        enable    => true,
        hasstatus => true,
        require   => Package['monit'],
    }
}
