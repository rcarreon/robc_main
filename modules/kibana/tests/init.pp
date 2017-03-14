# kibana::vhost depends on httpd package, so we include http
package { 'httpd': ensure => installed }
service { 'httpd': ensure => running }
# stolen from app1v-kibana's manifest
$project="admin"
include kibana::dashboards
kibana::vhost { "dev.kibana.gnmedia.net":
    elasticsearch_servers => [
        "app1v-dne.dne.dne.dne.gnmedia.net:9200",
        "app2v-dne.dne.dne.dne.gnmedia.net:9200",
    ],  
}   
