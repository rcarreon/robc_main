# Puppet class to implement orchestartor configuration
class orchestrator {
  include logrotate::orchestrator

  $orchestrator_pass = decrypt('qUNEaEwRLI+4G/t1gcdXItSqeQikZTlzvmDsmAexjK4=')
  $orchestrator_topology_pass = decrypt('Mc9zYK9qtQ3HiYXA4YZJOA==')
  file {'/etc/orchestrator.conf.json':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0640',
    content => template('techplatform/orchestrator.conf.json.erb')
  }

  file { '/var/log/orchestrator':
    ensure  => directory,
    owner   => 'root',
    group   => 'root',
    mode    => '0775',
  }

}
