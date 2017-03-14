node 'app1v-webpagetest.ap.dev.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base
    include common::app
    include httpd
    $project="admin"
}
