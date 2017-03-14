node 'app3v-nagios.tp.prd.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base
    $project="monitoring"
    $mon_status_level="development"
    $httpservername="nagios.dev.gnmedia.net"

    include httpd
    include aceman
    include nagios::serverV3
    include nagios::server::ssl
    include nagios::rundaemon 
    include sendmail::tarpit

}
