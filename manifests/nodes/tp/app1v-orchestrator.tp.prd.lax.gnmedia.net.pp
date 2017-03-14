node 'app1v-orchestrator.tp.prd.lax.gnmedia.net' {
  include base
  include git::client
  include orchestrator

  include newrelic
  include newrelic::params
  include newrelic::sysmond
  include newrelic::nfsiostat

  $project='admin'

  sudo::install_template { 'dba-root': }

  package { [
    'mysql',
    'orchestrator',
    'orchestrator-cli',
    'percona-toolkit',
    ]: ensure => installed,
  }

  service { 'orchestrator':
    ensure => running,
    enable => true,
  }

}
