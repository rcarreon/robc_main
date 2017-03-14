class emagent ($supported) {
    include emagent::package, emagent::config
    class { 'emagent::service' : supported => $supported }
}
