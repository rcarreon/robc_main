class yum::gnrepo inherits yum::client {
    file {"/etc/yum.repos.d/gnrepo.repo":
        ensure  => present,
        require => File["/etc/yum.repos.d"],
        owner   => "root",
        group   => "root",
        mode    => "0644",
    }

        case $::lsbmajdistrelease {
                '5': {
                        $baseurl="http://yum.gnmedia.net/live/gnrepo/5"
                }
                '6': {
                        $baseurl="http://yum.gnmedia.net/live/gnrepo/6"
                }
    }
#   notify => $baseurl,

    yumrepo {"gnrepo":
        descr   => "Gorilla Nation local CentOS Packages",
    baseurl     => "$baseurl",
        require => File["/etc/yum.repos.d/gnrepo.repo"],
    }
}
