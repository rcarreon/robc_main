# setup mysqld agent
class mysqld::agent ($startagent) {
    include mysqld::agent::package, mysqld::agent::config
    class { 'mysqld::agent::service': startagent => $startagent }
}
