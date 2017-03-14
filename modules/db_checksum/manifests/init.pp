# db-checksum is a wrapper for the Percona Toolkit's pt-table-checksum.
# It is being used initially for the Crowd Ignite OLTP (sql-ci) servers,
# but is expected to eventually be used across all verticals to look for
# replication data drift.
class db_checksum {

    # the actual db-checksum script
    file { '/usr/local/bin/dbchecksum':
        ensure  => file,
        source  => 'puppet:///modules/db_checksum/dbchecksum.py',
        owner   => 'root',
        group   => 'root',
        mode    => '0755',
    }

    # directory for pidfiles
    file { '/var/run/db-checksum':
        ensure  => directory,
        owner   => 'mysql',
        group   => 'mysql',
        mode    => '0777',
    }

}
