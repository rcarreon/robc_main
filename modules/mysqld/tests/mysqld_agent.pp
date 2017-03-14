Exec { path => "/usr/bin:/usr/sbin:/bin:/sbin" }
class { 'mysqld::agent': startagent => 'inventory' }
