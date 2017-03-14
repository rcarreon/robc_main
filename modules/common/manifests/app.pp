# This class will prepare the folder and permission to have an application
# (apache) ready to be installed


class common::app {

    # /app/log must be writeable for apache group (we have some cron using that group)
    file { "/app":
        ensure => directory,
        owner  => root,
        group  => root,
        mode   => 664,
    }

    # FIXME: do we want to set this explicit? puppet won't change it, for now, but it may in the future..
    # and the owner/group varies wildly, so it will be difficult to change it to something explicit, methinks
    file { "/app/log":
        ensure  => directory,
        mode    => 664,
        require => File["/app"],
    }
    
    package{ "strace":
        ensure => present,
    }

    
}    

