# $Id$
class ldap::server::cron {
    # This class should be directly included by one and only one ldap server

    # backups into /ldap_backup
    file {"/usr/local/sbin/ldapdump":
        owner   => root,
        group   => root,
        mode    => 755,
        source  => "puppet:///modules/ldap/ldapdump",
    }
    cron { ldapdump:
        command => "/usr/local/sbin/ldapdump",
        user => root,
        hour => '*',
        minute => '0'
    }

    # build the db files
    cron { nsscache:
        command => "/bin/bash -lc '/usr/bin/nsscache update; chmod 600 /home/deploy/dbupdate/files/shadow.db'",
        user => root,
        minute => '*'
    }

    # create home directories
    file {"/usr/local/sbin/homedirmake":
        owner   => root,
        group   => root,
        mode    => 755,
        source  => "puppet:///modules/ldap/homedirmake",
    }
    cron { homedirmake:
        command => "/usr/local/sbin/homedirmake",
        user => root,
        minute => '*/10'
    }

    # dump ldap to svn to track changes. This is NOT a backup because passwords are omitted.
    cron { "ldapdumptosvn":
        command => "/bin/bash -lc 'cd /home/em-deploy/tp_ldapdump ; ldapsearch -h localhost -x > ldapdump.out && git commit -a -m \"automated update\" && git push origin master'",
        user => "em-deploy",
        hour => '*',
        minute => '1'
    }
}
