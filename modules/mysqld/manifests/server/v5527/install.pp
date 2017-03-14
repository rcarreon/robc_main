# mysqld server v5527 install
define mysqld::server::v5527::install($startagent='inventory', $sqlclass='inventory') {
    include mysqld::client::v5527
    include mysqld::server
    include logrotate::mysql55
    mysqld::server::install{ $name:
        startagent => $startagent, 
        sqlclass => $sqlclass, 
        version => '5527',
    }
}
