Exec { path => "/usr/bin:/usr/sbin:/bin:/sbin" }

if $lsbmajdistrelease == '6' {
    include mysqld::client::v5527
    mysqld::server::v5527::install{"5527-default-standalone":}
}

mount { "/sql/data":
    ensure => "absent",
}
mount { "/sql/binlog":
    ensure => "absent",
}
mount { "/sql/log":
    ensure => "absent",
}
