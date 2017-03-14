class collectd::client {
    include collectd::package, collectd::client::config, collectd::service
}
