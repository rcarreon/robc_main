node 'uid1v-mdillon.tp.dev.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base
    $project="admin"
        include subversion::client
        include util::vim
        include puppet_agent::uid
        include rubygems::compass
        include rubygems::colored
        include mysqld56::client
        include git::client
}
