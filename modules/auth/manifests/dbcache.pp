# auth::dbcache class
class auth::dbcache {
    package{'nss_db':
        ensure=>installed,
    }
    file {'/var/db/passwd.db':
        ensure  => file,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        source  => '/home/deploy/dbupdate/files/passwd.db',
    }
    file {'/var/db/group.db':
        ensure  => file,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        source  => '/home/deploy/dbupdate/files/group.db',
    }
    file {"/etc/netgroup":
        ensure  => file,
        owner   => root,
        group   => root,
        mode    => '0644',
        source  => "/home/deploy/dbupdate/files/netgroup",
    }
    file {"/var/db/shadow.db":
        ensure  => file,
        owner   => root,
        group   => root,
        mode    => '0400',
        source  => "/home/deploy/dbupdate/files/shadow.db",
    }

    gnlib::replace_entire_line_full {"UseCachedDBpasswd":
        file        => "/etc/nsswitch.conf",
        pattern     => "^[^#]?passwd.*$",
        replacement => "passwd: files db",
        require     => File["/var/db/passwd.db"],
    }
    gnlib::replace_entire_line_full {"UseCachedDBgroup":
        file        => "/etc/nsswitch.conf",
        pattern     => "^[^#]?group.*$",
        replacement => "group:  files db",
        require     => File["/var/db/group.db"],
    }
    gnlib::replace_line_or_append_if_absent { "UseCachedNetgroups":
        file        => "/etc/nsswitch.conf",
        pattern     => '[#]netgroup: ',
        replacement => "netgroup: files",
        require     => File["/etc/netgroup"],
    }
    gnlib::replace_entire_line_full {"UseCachedDBshadow":
        file        => "/etc/nsswitch.conf",
        pattern     => "^[^#]?shadow.*$",
        replacement => "shadow:  files db",
        require     => File["/var/db/shadow.db"],
    }
}
