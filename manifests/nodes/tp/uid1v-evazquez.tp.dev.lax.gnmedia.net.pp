node 'uid1v-evazquez.tp.dev.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base
    include yum::ius
	include rubygems::capistrano
    include rubygems::colored
    include yum::newrelic::wildwest

    $project="admin"
    # python used in jenkins builds for html reports, ansible used in deploys
    package { ['python-jinja2', 'python-lxml', 'python-argparse', 'php54-pecl-xdebug', 'ansible']: ensure => installed }
    
}
