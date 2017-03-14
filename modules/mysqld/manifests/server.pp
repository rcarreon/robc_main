# mysqld server class
class mysqld::server {
    include mysqld::server_base
    include collectd::client
}
