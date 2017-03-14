class yum::puppet_live inherits yum::client {
    file { "/etc/yum.repos.d/puppet-live.repo":
        ensure  => present,
        owner   => "root",
        group   => "root",
        require => File["/etc/yum.repos.d"],
    }
    yumrepo { "puppet-live":
        descr   => "GN live puppet repos",
        baseurl => "http://yum.gnmedia.net/live/puppet/$::lsbmajdistrelease",
        enabled => 1,
        require => File["/etc/yum.repos.d/puppet-live.repo"],
    }
}
