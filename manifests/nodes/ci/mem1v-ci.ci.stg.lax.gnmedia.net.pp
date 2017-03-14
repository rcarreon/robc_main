
node 'mem1v-ci.ci.stg.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base
  $project="crowdignite"
  include memcached
  include sysctl
  include security

exec { "enable_ganglia_memcached.pyconf":
    command => "/bin/mv /etc/ganglia/conf.d/memcached.pyconf.disabled /etc/ganglia/conf.d/memcached.pyconf",
    creates => "/etc/ganglia/conf.d/memcached.pyconf"
}

}
