# class to allow puppetmasters to be upgraded separately from puppet agents
class yum::puppetmaster_live inherits yum::client {
    file { '/etc/yum.repos.d/puppetmaster-live.repo':
        ensure  => present,
        owner   => 'root',
        group   => 'root',
        require => File['/etc/yum.repos.d'],
    }
    yumrepo { 'puppetmaster-live':
        descr   => 'GN live puppetmaster repos',
        baseurl => "http://yum.gnmedia.net/live/puppetmaster/${::lsbmajdistrelease}",
        enabled => 1,
        require => File['/etc/yum.repos.d/puppetmaster-live.repo'],
    }
}
