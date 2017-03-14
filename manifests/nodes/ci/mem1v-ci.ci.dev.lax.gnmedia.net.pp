node 'mem1v-ci.ci.dev.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base
        $project="crowdignite"
       	include memcached
	include sysctl
        include security

        package { "vim-enhanced":
          ensure => installed,
        }
}
