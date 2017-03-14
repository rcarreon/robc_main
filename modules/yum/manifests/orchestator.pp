class yum::orchestator inherits yum::client {
    file {"/etc/yum.repos.d/orchestator.repo":
        ensure  => present,
        require => File["/etc/yum.repos.d"],
        owner   => "root",
        group   => "root",
        mode    => "0644",
    }

   $baseurl="http://yumoter.gnmedia.net/orchestator/6/live"
#   notify => $baseurl,

    yumrepo {"orchestator":
        descr   => "Orchestator",
    baseurl     => "$baseurl",
        require => File["/etc/yum.repos.d/orchestator.repo"],
    }
}
