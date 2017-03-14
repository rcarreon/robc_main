
# usage: 	include security

# only need to set this on mongodb, nginx, memcache, varnish, those type of servers
# other than that, it is ok to use stock which come with 1024 ulimit

class security {

    file {'limits_conf':
        path => "/etc/security/limits.conf",
        source  => "puppet:///modules/security/limits.conf",
        owner   => root,
        group   => root,
        mode    => 664,
    	ensure  => file,
    }
    
    # only exist on redhat 6 which default nproc to 1024
    if $lsbmajdistrelease == 6 {
        file {'90_nproc_conf':
            path => "/etc/security/limits.d/90-nproc.conf",
            source  => "puppet:///modules/security/90-nproc.conf",
            owner   => root,
            group   => root,
            mode    => 664,
            ensure  => file,
        }
    }
}
