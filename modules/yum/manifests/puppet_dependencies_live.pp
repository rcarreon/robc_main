# puppet dependency RPMs
class yum::puppet_dependencies_live inherits yum::client {
    file { '/etc/yum.repos.d/puppet-dependencies-live.repo':
        ensure  => present,
        owner   => 'root',
        group   => 'root',
        require => File['/etc/yum.repos.d'],
    }
    yumrepo { 'puppet-dependencies-live':
        descr   => 'GN live puppet dependencies repos',
        baseurl => "http://yum.gnmedia.net/live/puppet-dependencies/${::lsbmajdistrelease}",
        enabled => 1,
        require => File['/etc/yum.repos.d/puppet-dependencies-live.repo'],
    }
}
