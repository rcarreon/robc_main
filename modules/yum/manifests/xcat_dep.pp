# Per Garrick, this class is not currently used, but probably should be, so please don't delete it.
class yum::xcat_dep inherits yum::client {
    file {'/etc/yum.repos.d/xcat-dep.repo':
        ensure  => present,
        require => File['/etc/yum.repos.d'],
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
    }

    yumrepo {'xcat-dep':
        descr    => 'xCAT 2 dependencies',
        baseurl  => 'https://sourceforge.net/projects/xcat/files/yum/xcat-dep/rh6/x86_64',
        require  => File['/etc/yum.repos.d/xcat-dep.repo'],
        gpgkey   => 'https://sourceforge.net/projects/xcat/files/yum/xcat-dep/rh6/x86_64/repodata/repomd.xml.key',
        gpgcheck => '1',
    }
}
