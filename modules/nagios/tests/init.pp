$fqdn_env = 'dev'
$project = 'monitoring'
$httpservername = 'nagios.dev.gnmedia.net'
include nagios::serverv3
include nagios::server::ssl
include nagios::server::certs
include nagios::server::plugins
include nagios::server::config
include nagios::rundaemon
include nagios::client
include nagios::check_url
