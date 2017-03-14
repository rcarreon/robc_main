class ap::app::workers::janitor {
  file {'/etc/rc.d/init.d/janitor':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    content => template('adops/init-scripts/janitor')
  }

  file {[
    '/app/workers/janitor',
      '/app/workers/janitor/shared',
      '/app/workers/janitor/shared/config',
      '/app/workers/janitor/releases',
      '/app/workers/janitor/repo'
        ]:
      ensure  => directory,
      owner   => 'adops-deploy',
      group   => 'adops-worker',
      mode    => '0755',
      require => File['/app/workers'],
  }

  file {'/app/log/workers/janitor':
    ensure  => directory,
    owner   => 'adops-worker',
    group   => 'adops-worker',
    mode    => '0640',
    require => File['/app/log/workers']
  }
}

class ap::app::workers::janitor::dev {
  $janitor_env      = 'development'
  $redis_pass       = decrypt("6oKh1v706vXIEDp8XlTtZ8EraklUqhJxK7PbLVyNSaOn32VrjZPsh5dSsPKE\nACdY")
  $redis_host       = 'rds1v-adops.ap.dev.lax.gnmedia.net'
  $legacy_db_user   = 'janitor_r'
  $legacy_db_name   = 'adops2_0_production'
  $legacy_db_pass   = decrypt('luIfRy667yUdg/VgAjvoLQ==')
  $legacy_db_host   = 'sql1v-56-backup.ap.prd.lax.gnmedia.net'
  $adops_db_user    = 'adops_api'
  $adops_db_name    = 'adops_development'
  $adops_db_pass    = decrypt('pAyMfmkx/2m9nA5ZPbZMhCBo2D0wHb3VnFQUUbWt9xM=')
  $adops_db_host    = 'sql1v-56-adops.ap.dev.lax.gnmedia.net'
  $rabbit_host      = 'app1v-rabbit.ap.dev.lax.gnmedia.net'
  $rabbit_user      = 'adops-user'
  $rabbit_port      = 5672
  $rabbit_pass      = decrypt('bpZ42cqxpJY3zZoVEnCL1g==')
  $rabbit_vhost     = 'adops-api'
  $routing_key      = 'janitor'
  $worker_prefetch  = 1
  $worker_no_ack    = 'true'
  $worker_exclusive = 'false'
  $worker_exchange             = 'adops'
  $worker_exchange_type        = 'direct'
  $worker_exchange_durable     = 'false'
  $worker_exchange_exclusive   = 'false'
  $worker_exchange_auto_delete = 'false'
  $worker_q             = 'janitor'
  $worker_q_durable     = 'false'
  $worker_q_exclusive   = 'false'
  $worker_q_auto_delete = 'false'
  $total_workers = 1
  $min_workers   = 1
  $max_workers   = 1
  $server_daemonize = 'true'
  $server_pid_file   = '/tmp/janitor.pid'
  $server_log_level = 'debug'
  $gp_endpoint = 'http://evlaadops03.gorillanation.local:48620/DynamicsGPWebServices/DynamicsGPService.asmx'
  $gp_namespace = 'http://schemas.microsoft.com/dynamics/gp/2006/01'
  $gp_ns1 = 'http://schemas.microsoft.com/dynamics/2006/01'
  $gp_ns2 = 'http://schemas.microsoft.com/dynamics/security/2006/01'
  file {'/app/workers/janitor/shared/config/worker.yml':
    content => template('adops/janitor_worker.yml.erb'),
    owner   => 'adops-worker',
    group   => 'adops-worker',
    require => File['/app/workers/janitor/shared/config'],
  }
}

class ap::app::workers::janitor::stg {
  $janitor_env      = 'staging'
  $redis_pass       = decrypt("E/VslUSZ6Jbo7mxb6Yp8jt6cE1o8fXRLwynDQeQxnkP42WRACYLA4rbaT+N3\nckWb")
  $redis_host       = 'rds1v-adops.ap.stg.lax.gnmedia.net'
  $legacy_db_user   = 'janitor_r'
  $legacy_db_name   = 'adops2_0_production'
  $legacy_db_pass   = decrypt('c/mqT9suaap1zwMDLlvAHA==')
  $legacy_db_host   = 'sql1v-56-backup.ap.prd.lax.gnmedia.net'
  $adops_db_user    = 'adops_api'
  $adops_db_name    = 'adops_staging'
  $adops_db_pass    = decrypt('YyL4EwatweOcJclGISnuJw==')
  $adops_db_host    = 'vip-sqlrw-adops.ap.stg.lax.gnmedia.net'
  $rabbit_host      = 'app1v-rabbit.ap.stg.lax.gnmedia.net'
  $rabbit_user      = 'adops-user'
  $rabbit_port      = 5672
  $rabbit_pass      = decrypt('vJ4jy6VzYD6Z3IiaXNjLjw==')
  $rabbit_vhost     = 'adops-api'
  $routing_key      = 'janitor'
  $worker_prefetch  = 1
  $worker_no_ack    = 'true'
  $worker_exclusive = 'false'
  $worker_exchange             = 'adops'
  $worker_exchange_type        = 'direct'
  $worker_exchange_durable     = 'false'
  $worker_exchange_exclusive   = 'false'
  $worker_exchange_auto_delete = 'false'
  $worker_q             = 'janitor'
  $worker_q_durable     = 'false'
  $worker_q_exclusive   = 'false'
  $worker_q_auto_delete = 'false'
  $total_workers = 1
  $min_workers   = 1
  $max_workers   = 1
  $server_daemonize = 'true'
  $server_pid_file   = '/tmp/janitor.pid'
  $server_log_level = 'debug'
  file {'/app/workers/janitor/shared/config/worker.yml':
    content => template('adops/janitor_worker.yml.erb'),
    owner   => 'adops-worker',
    group   => 'adops-worker',
    require => File['/app/workers/janitor/shared/config'],
  }
}
