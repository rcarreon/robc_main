node 'uid1v-bvladisavljev.si.dev.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base
        $project="si"
        include common::app
        include httpd
        include php::dh
        include subversion::client
        include puppet_agent::uid


}
