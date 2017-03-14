# Class: elasticsearch

# old, deprecated ES class, please use elasticsearch::parameterized instead
class elasticsearch {
    include yum::gnrepo
    package { 'elasticsearch':
        ensure    => installed,
        require   => Class['yum::gnrepo']
    }

    service{'elasticsearch':
        ensure    => running,
        enable    => true,
        hasstatus => true,
        require   => Package['elasticsearch'],
    }

}
