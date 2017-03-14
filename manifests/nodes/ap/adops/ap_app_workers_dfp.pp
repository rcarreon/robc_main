
class ap::app::workers::dfp {
  file {'/etc/rc.d/init.d/dfp-gateway':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    content => template('adops/init-scripts/dfp-gateway')
  }

  file {[
    '/app/workers/dfp-gateway',
    '/app/workers/dfp-gateway/shared',
    '/app/workers/dfp-gateway/shared/config',
    '/app/workers/dfp-gateway/releases',
    '/app/workers/dfp-gateway/repo'
    ]:
    ensure  => directory,
    owner   => 'adops-deploy',
    group   => 'adops-worker',
    mode    => '0755',
    require => File['/app/workers'],
  }

  file {'/app/log/workers/dfp-gateway':
    ensure  => directory,
    owner   => 'adops-worker',
    group   => 'adops-worker',
    mode    => '0640',
    require => File['/app/log/workers']
  }
}

class ap::app::workers::dfp::dev {
  # app2v-only stuff
  if ($::fqdn_incr == '2' ) {
    $dfp_oauth_client_id     = "1046014897037-nnd05a5gpno4eiqjpon3c2jnvj9msu55.apps.googleusercontent.com"
    $dfp_oauth_client_secret = decrypt('ljX7xr2zjThfDugY4B7yGTYztQb4Xuz/NHbtsTixnBg=')
    $dfp_app_name            = 'Adops Application Api'
    $dfp_network_code        = 431096448
    $dfp_root_ad_unit_id     = 430096568
    $dfp_version             = 'v201602'
    $dfp_oauth_access_token  = ''
    $dfp_oauth_refresh_token = decrypt("nb5RdkLDGCF3OkovDfL7GeGKT0Hfz9qx8B19TaABvb7VbiVgA2H+ZewmRcWk\nbOt3u2uvq4CW10rf0wEvhI1GLWHEJtQlcUKvXBL0/KU//HA=")
    file {[
      '/app/workers/dfp-gateway/shared/config/dfp_gateway_test.yml',
      '/app/workers/dfp-gateway/shared/config/dfp_api.yml',
      ]:
      ensure  => file,
      owner   => 'adops-deploy',
      group   => 'adops-deploy',
      mode    => '0644',
      content => template('adops/dfp_gateway_api.yml.erb'),
      require => File['/app/workers/dfp-gateway/shared/config'],
    }
    file {'/app/workers/dfp-gateway/shared/config/dfp_gateway_prod.yml':
      ensure  => file,
      owner   => 'adops-deploy',
      group   => 'adops-deploy',
      mode    => '0644',
      content => template('adops/dfp_prd_api.yml.erb'),
      require => File['/app/workers/dfp-gateway/shared/config'],
    }

    $dfp_env          = 'development'
    $redis_pass       = decrypt("6oKh1v706vXIEDp8XlTtZ8EraklUqhJxK7PbLVyNSaOn32VrjZPsh5dSsPKE\nACdY")
    $redis_host       = 'rds1v-adops.ap.dev.lax.gnmedia.net'
    $adops_db_name    = 'adops_development'
    $adops_db_user    = 'adops_api'
    $adops_db_pass    = decrypt('pAyMfmkx/2m9nA5ZPbZMhCBo2D0wHb3VnFQUUbWt9xM=')
    $adops_db_host    = 'sql1v-56-adops.ap.dev.lax.gnmedia.net'
    $rabbit_host      = 'app1v-rabbit.ap.dev.lax.gnmedia.net'
    $rabbit_user      = 'adops-user'
    $rabbit_port      = 5672
    $rabbit_pass      = decrypt('bpZ42cqxpJY3zZoVEnCL1g==')
    $rabbit_vhost     = 'adops-api'
    $dfp_routing_key  = 'dfp'
    $worker_prefetch  = 1
    $worker_no_ack    = 'true'
    $worker_exclusive = 'false'
    $worker_exchange             = 'adops'
    $worker_exchange_type        = 'direct'
    $worker_exchange_durable     = 'false'
    $worker_exchange_exclusive   = 'false'
    $worker_exchange_auto_delete = 'false'
    $worker_q             = 'dfp'
    $worker_q_durable     = 'false'
    $worker_q_exclusive   = 'false'
    $worker_q_auto_delete = 'false'
    $total_workers = 1
    $min_workers   = 1
    $max_workers   = 1
    $server_daemonize = 'true'
    $server_pid_file   = '/tmp/dfp-gateway.pid'
    $server_log_level = 'debug'
    file {'/app/workers/dfp-gateway/shared/config/worker.yml':
      content => template('adops/dfp_worker.yml.erb'),
      owner   => 'adops-worker',
      group   => 'adops-worker',
      require => File['/app/workers/dfp-gateway/shared/config'],
    }
  }
}
