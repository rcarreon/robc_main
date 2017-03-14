class yum::os {
    file { '/etc/yum.repos.d/os.repo':
        ensure  => present,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        require => File['/etc/yum.repos.d'],
    }
    yumrepo {'os':
        descr   => 'Gorillanation\'s mirror of centos os repos',
        baseurl => "http://yumoter.gnmedia.net/os/$gn_lsb_two_digits/",
        enabled => 1,
    }
}
