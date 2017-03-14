class ap::app::adoperations {
  ### appdirs
  file {[
    '/app/shared/docroots',
    '/app/log/adops',
    ]:
    ensure  => directory,
    owner   => 'adops-deploy',
    group   => 'adops-deploy',
    mode    => '0755',
  }

  file {[
    '/app/shared/docroots/adops.evolvemediallc.com',
    '/app/shared/docroots/adops.evolvemediallc.com/shared',
    '/app/shared/docroots/adops.evolvemediallc.com/shared/config',
    '/app/shared/docroots/adops.evolvemediallc.com/releases',
    '/app/shared/docroots/adops.evolvemediallc.com/repo',
    ]:
    ensure  => directory,
    owner   => 'adops-deploy',
    group   => 'adops-deploy',
    mode    => '0755',
    require => File['/app/shared/docroots']
  }

  file { [
    '/app/shared/docroots/adops-api.evolvemediallc.com',
    '/app/shared/docroots/adops-api.evolvemediallc.com/shared',
    '/app/shared/docroots/adops-api.evolvemediallc.com/shared/config',
    '/app/shared/docroots/adops-api.evolvemediallc.com/releases',
    '/app/shared/docroots/adops-api.evolvemediallc.com/repo',
    ]:
    ensure => directory,
    owner  => 'adops-deploy',
    group  => 'adops-deploy',
    mode   => '0755',
    require => [
      File['/app/shared/docroots'],
      File['/app/log/adops'],
      #File['/app/log/adops/apache'],
      #File['/app/log/adops/adops-deploy']
    ]
  }
}

# DEV-specific configs
class ap::app::adoperations::dev {

  include adops::devmail

  # app1v-only stuff -- CAREFUL, THIS IS APP2 FOR NOW
  if ($::fqdn_incr == '2' ) {

    $adops_webui_redis_host     = 'rds1v-adops.ap.dev.lax.gnmedia.net'
    $adops_webui_redis_password = decrypt("6oKh1v706vXIEDp8XlTtZ8EraklUqhJxK7PbLVyNSaOn32VrjZPsh5dSsPKE\nACdY")
    file { '/app/shared/docroots/adops.evolvemediallc.com/shared/config.yml':
      owner   => 'adops-deploy',
      group   => 'adops-deploy',
      content => template('adops/webui_redis.yml.erb'),
    }

    # Define The adops environment in ruby_env, for use with cron rake tasks
    $env_app_adoperations  = 'development'
    file {'/app/shared/docroots/adops-api.evolvemediallc.com/shared/config/ruby_env':
      ensure  => file,
      owner   => 'adops-deploy',
      group   => 'adops-deploy',
      mode    => '0644',
      content => $env_app_adoperations,
    }

    # DB Credentials
    $app_env_name = 'development'
    $app_db_name  = 'adops_development'
    $app_db_host  = 'sql1v-56-adops.ap.dev.lax.gnmedia.net'
    $app_db_user  = 'adops_api'
    $app_db_pass  = decrypt('pAyMfmkx/2m9nA5ZPbZMhCBo2D0wHb3VnFQUUbWt9xM=')

    $app_db_migration_user  = 'adops_api_migrat'
    $app_db_migration_pass  = decrypt('pAyMfmkx/2m9nA5ZPbZMhCBo2D0wHb3VnFQUUbWt9xM=')

    file {'/app/shared/docroots/adops-api.evolvemediallc.com/shared/config/database.yml':
      content => template('adops/app_database.yml.erb'),
      owner   => 'adops-deploy',
      group   => 'adops-deploy',
    }

    file {'/app/shared/docroots/adops-api.evolvemediallc.com/shared/config/auth.yml':
      content => template('adops/app_auth.yml.erb'),
      owner   => 'adops-deploy',
      group   => 'adops-deploy',
    }

    # DFP API
    $appname_adops_app_adoperations_dfp_auth = 'AP AdOps'
    $access_token_adoperations_dfp_auth = ''
    $client_id_adoperations_dfp_auth = decrypt('7saMCECTExTBDhCBk7O7Nl30l5dFEEC6sVyDuw50l8BBWh1dZQNoLvFB31xsfBFybJIz9Lfq9u0Hg6Fsuojv6zquzMG8eZoEaak+0Yco0BM=')
    $client_secret_adoperations_dfp_auth = decrypt('4+cobkNwTUdu6kKf/U/2CxSm+8ifzvblLjoeR19XDpQ=')
    $network_adops_app_adoperations_dfp_auth = 17425867
    $refresh_token_adoperations_dfp_auth = decrypt('/ZuwzrQMsLo1UU+d680hnRzyRt3gxja2i7K+Fo+rg7DN2OKbEDUZSgcCgmyn3rpj')

    file {'/app/shared/docroots/adops-api.evolvemediallc.com/shared/config/dfp_api.yml':
      content => template('adops/app_adoperations_dfp_api.yml.erb'),
      owner   => 'adops-deploy',
      group   => 'adops-deploy',
    }

    # Elasticsearch
    $es_url_app_adoperations = 'http://localhost:9200'
    $es_river_url_app_adoperations = "jdbc:mysql://#{$host_app_adoperations_rw}:3306/adops2_0_production"
    $es_river_user_app_adoperations_ro = $user_app_adoperations_rw
    $es_river_pass_app_adoperations_ro = $pass_app_adoperations_rw
    file {'/app/shared/docroots/adops-api.evolvemediallc.com/shared/config/elasticsearch.yml':
      content => template('adops/app_adoperations_elasticsearch.yml.erb'),
      owner   => 'adops-deploy',
      group   => 'adops-deploy',
    }

    # LDAP
    $ldap_pass_app_adoperations = decrypt('\O+4t26bo/dYyReM4ehB+lg==')
    file {'/app/shared/docroots/adops-api.evolvemediallc.com/shared/config/ldap.yml':
      content => template('adops/app_adoperations_ldap.yml.erb'),
      owner   => 'adops-deploy',
      group   => 'adops-deploy',
    }

    # Rabbit
    $rabbit_host_app_adoperations = 'app1v-rabbit.ap.dev.lax.gnmedia.net'
    $rabbit_user_app_adoperations = 'adops-user'
    $rabbit_pass_app_adoperations = decrypt('bpZ42cqxpJY3zZoVEnCL1g==')
    $rabbit_vhost_app_adoperations = 'adops-api'
    file {'/app/shared/docroots/adops-api.evolvemediallc.com/shared/config/rabbit.yml':
      content => template('adops/app_adoperations_rabbit.yml.erb'),
      owner   => 'adops-deploy',
      group   => 'adops-deploy',
    }

    # Secrets
    $env_app_adoperations_devise_key = decrypt('SJP+X9d667hCWlHcgzQPdUuANdyzS9MxDWCjDaAz3dKN9Go4GrdyFB+Up0LvCMea+B0gC//AB10OFvK1OIGvpc2k5UGaNA3+kACXq7qwI2kk1WyDp8tvXfeRnuyO7fid6o9omc50XRhqO+qnxAVQQeAZ7J7PHQ07uwP2UN8IgI+1Ohwo1yrsgGvMB/0Kc+Vb')
    file {'/app/shared/docroots/adops-api.evolvemediallc.com/shared/config/secrets.yml':
      content => template('adops/app_adoperations_secrets.yml.erb'),
      owner   => 'adops-deploy',
      group   => 'adops-deploy',
    }
  }
}

# STG-specific configs
class ap::app::adoperations::stg {

  include adops::devmail

  $adops_webui_redis_host     = 'rds1v-adops.ap.stg.lax.gnmedia.net'
  $adops_webui_redis_password = decrypt("E/VslUSZ6Jbo7mxb6Yp8jt6cE1o8fXRLwynDQeQxnkP42WRACYLA4rbaT+N3\nckWb")
  file { '/app/shared/docroots/adops.evolvemediallc.com/shared/config.yml':
    owner   => 'adops-deploy',
    group   => 'adops-deploy',
    content => template('adops/webui_redis.yml.erb'),
  }

  # Define The adops environment in ruby_env, for use with cron rake tasks
  $env_app_adoperations  = 'staging'
  file {'/app/shared/docroots/adops-api.evolvemediallc.com/shared/config/ruby_env':
    ensure  => file,
    owner   => 'adops-deploy',
    group   => 'adops-deploy',
    mode    => '0644',
    content => $env_app_adoperations,
  }

  # DB Credentials
  $app_env_name = 'staging'
  $app_db_name  = 'adops_staging'
  $app_db_host  = 'vip-sqlrw-adops.ap.stg.lax.gnmedia.net'
  $app_db_user  = 'adops_api'
  $app_db_pass  = decrypt('YyL4EwatweOcJclGISnuJw==')

  $app_db_migration_user  = 'adops_api_migrat'
  $app_db_migration_pass  = decrypt('5HW995bZ8hzV5ly1eoQtg0Q8sLzkypEtOQlI2+93gSo=')

  file {'/app/shared/docroots/adops-api.evolvemediallc.com/shared/config/database.yml':
    content => template('adops/app_database.yml.erb'),
    owner   => 'adops-deploy',
    group   => 'adops-deploy',
  }

  file {'/app/shared/docroots/adops-api.evolvemediallc.com/shared/config/auth.yml':
    content => template('adops/app_auth.yml.erb'),
    owner   => 'adops-deploy',
    group   => 'adops-deploy',
  }

  # DFP API
  $appname_adops_app_adoperations_dfp_auth = 'AP AdOps'
  $access_token_adoperations_dfp_auth = ''
  $client_id_adoperations_dfp_auth = decrypt('7saMCECTExTBDhCBk7O7Nl30l5dFEEC6sVyDuw50l8BBWh1dZQNoLvFB31xsfBFybJIz9Lfq9u0Hg6Fsuojv6zquzMG8eZoEaak+0Yco0BM=')
  $client_secret_adoperations_dfp_auth = decrypt('4+cobkNwTUdu6kKf/U/2CxSm+8ifzvblLjoeR19XDpQ=')
  $network_adops_app_adoperations_dfp_auth = 17425867
  $refresh_token_adoperations_dfp_auth = decrypt('/ZuwzrQMsLo1UU+d680hnRzyRt3gxja2i7K+Fo+rg7DN2OKbEDUZSgcCgmyn3rpj')

  file {'/app/shared/docroots/adops-api.evolvemediallc.com/shared/config/dfp_api.yml':
    content => template('adops/app_adoperations_dfp_api.yml.erb'),
    owner   => 'adops-deploy',
    group   => 'adops-deploy',
  }

  # Elasticsearch
  $es_url_app_adoperations = 'http://localhost:9200'
  $es_river_url_app_adoperations = "jdbc:mysql://#{$host_app_adoperations_rw}:3306/adops2_0_production"
  $es_river_user_app_adoperations_ro = $user_app_adoperations_rw
  $es_river_pass_app_adoperations_ro = $pass_app_adoperations_rw
  file {'/app/shared/docroots/adops-api.evolvemediallc.com/shared/config/elasticsearch.yml':
    content => template('adops/app_adoperations_elasticsearch.yml.erb'),
    owner   => 'adops-deploy',
    group   => 'adops-deploy',
  }

  # LDAP
  $ldap_pass_app_adoperations = decrypt('\O+4t26bo/dYyReM4ehB+lg==')
  file {'/app/shared/docroots/adops-api.evolvemediallc.com/shared/config/ldap.yml':
    content => template('adops/app_adoperations_ldap.yml.erb'),
    owner   => 'adops-deploy',
    group   => 'adops-deploy',
  }

  # Rabbit
  $rabbit_host_app_adoperations = 'app1v-rabbit.ap.stg.lax.gnmedia.net'
  $rabbit_user_app_adoperations = 'adops-user'
  $rabbit_pass_app_adoperations = decrypt('vJ4jy6VzYD6Z3IiaXNjLjw==')
  $rabbit_vhost_app_adoperations = 'adops-api'
  file {'/app/shared/docroots/adops-api.evolvemediallc.com/shared/config/rabbit.yml':
    content => template('adops/app_adoperations_rabbit.yml.erb'),
    owner   => 'adops-deploy',
    group   => 'adops-deploy',
  }

  # Secrets
  $env_app_adoperations_devise_key = decrypt('SJP+X9d667hCWlHcgzQPdUuANdyzS9MxDWCjDaAz3dKN9Go4GrdyFB+Up0LvCMea+B0gC//AB10OFvK1OIGvpc2k5UGaNA3+kACXq7qwI2kk1WyDp8tvXfeRnuyO7fid6o9omc50XRhqO+qnxAVQQeAZ7J7PHQ07uwP2UN8IgI+1Ohwo1yrsgGvMB/0Kc+Vb')
  file {'/app/shared/docroots/adops-api.evolvemediallc.com/shared/config/secrets.yml':
    content => template('adops/app_adoperations_secrets.yml.erb'),
    owner   => 'adops-deploy',
    group   => 'adops-deploy',
  }
}

# PRD-specific configs
class ap::app::adoperations::prd {
  $adops_webui_redis_host     = 'rds1v-adops.ap.prd.lax.gnmedia.net'
  $adops_webui_redis_password = decrypt("XMdvh6agu80aqsR34kP7DcDmU9MVL3cpYJIpE9OJZNnJCC/IqV+yFEJ/dB+j\ni+5u")
  file { '/app/shared/docroots/adops.evolvemediallc.com/shared/config.yml':
    owner   => 'adops-deploy',
    group   => 'adops-deploy',
    content => template('adops/webui_redis.yml.erb'),
  }

  # Define The adops environment in ruby_env, for use with cron rake tasks
  $env_app_adoperations  = 'production'
  file {'/app/shared/docroots/adops-api.evolvemediallc.com/shared/config/ruby_env':
    ensure  => file,
    owner   => 'adops-deploy',
    group   => 'adops-deploy',
    mode    => '0644',
    content => $env_app_adoperations,
  }

  # DB Credentials
  $app_env_name = 'production'
  $app_db_name  = 'adops'
  $app_db_host  = 'vip-sqlrw-adops.ap.prd.lax.gnmedia.net'
  $app_db_user  = 'adops_api'
  $app_db_pass  = decrypt('IWbGBcGGSXOOKBlyeBrpeScGsuoSqXexiJKlBrt8Tv4=')

  $app_db_migration_user  = 'adops_api_migrat'
  $app_db_migration_pass  = decrypt('IWbGBcGGSXOOKBlyeBrpeScGsuoSqXexiJKlBrt8Tv4=')

  file {'/app/shared/docroots/adops-api.evolvemediallc.com/shared/config/database.yml':
    content => template('adops/app_database.yml.erb'),
    owner   => 'adops-deploy',
    group   => 'adops-deploy',
  }

  file {'/app/shared/docroots/adops-api.evolvemediallc.com/shared/config/auth.yml':
    content => template('adops/app_auth.yml.erb'),
    owner   => 'adops-deploy',
    group   => 'adops-deploy',
  }

  # DFP API
  $appname_adops_app_adoperations_dfp_auth = 'AP AdOps'
  $access_token_adoperations_dfp_auth = ''
  $client_id_adoperations_dfp_auth = decrypt('7saMCECTExTBDhCBk7O7Nl30l5dFEEC6sVyDuw50l8BBWh1dZQNoLvFB31xsfBFybJIz9Lfq9u0Hg6Fsuojv6zquzMG8eZoEaak+0Yco0BM=')
  $client_secret_adoperations_dfp_auth = decrypt('4+cobkNwTUdu6kKf/U/2CxSm+8ifzvblLjoeR19XDpQ=')
  $network_adops_app_adoperations_dfp_auth = 17425867
  $refresh_token_adoperations_dfp_auth = decrypt('/ZuwzrQMsLo1UU+d680hnRzyRt3gxja2i7K+Fo+rg7DN2OKbEDUZSgcCgmyn3rpj')

  file {'/app/shared/docroots/adops-api.evolvemediallc.com/shared/config/dfp_api.yml':
    content => template('adops/app_adoperations_dfp_api.yml.erb'),
    owner   => 'adops-deploy',
    group   => 'adops-deploy',
  }

  # Elasticsearch
  $es_url_app_adoperations = 'http://localhost:9200'
  $es_river_url_app_adoperations = "jdbc:mysql://#{$host_app_adoperations_rw}:3306/adops2_0_production"
  $es_river_user_app_adoperations_ro = $user_app_adoperations_rw
  $es_river_pass_app_adoperations_ro = $pass_app_adoperations_rw
  file {'/app/shared/docroots/adops-api.evolvemediallc.com/shared/config/elasticsearch.yml':
    content => template('adops/app_adoperations_elasticsearch.yml.erb'),
    owner   => 'adops-deploy',
    group   => 'adops-deploy',
  }

  # LDAP
  $ldap_pass_app_adoperations = decrypt('\O+4t26bo/dYyReM4ehB+lg==')
  file {'/app/shared/docroots/adops-api.evolvemediallc.com/shared/config/ldap.yml':
    content => template('adops/app_adoperations_ldap.yml.erb'),
    owner   => 'adops-deploy',
    group   => 'adops-deploy',
  }

  # Rabbit
  $rabbit_host_app_adoperations = 'app1v-rabbit.ap.prd.lax.gnmedia.net'
  $rabbit_user_app_adoperations = 'adops-user'
  $rabbit_pass_app_adoperations = decrypt('bpZ42cqxpJY3zZoVEnCL1g==')
  $rabbit_vhost_app_adoperations = 'adops-api'
  file {'/app/shared/docroots/adops-api.evolvemediallc.com/shared/config/rabbit.yml':
    content => template('adops/app_adoperations_rabbit.yml.erb'),
    owner   => 'adops-deploy',
    group   => 'adops-deploy',
  }

  # Secrets
  $env_app_adoperations_devise_key = decrypt('SJP+X9d667hCWlHcgzQPdUuANdyzS9MxDWCjDaAz3dKN9Go4GrdyFB+Up0LvCMea+B0gC//AB10OFvK1OIGvpc2k5UGaNA3+kACXq7qwI2kk1WyDp8tvXfeRnuyO7fid6o9omc50XRhqO+qnxAVQQeAZ7J7PHQ07uwP2UN8IgI+1Ohwo1yrsgGvMB/0Kc+Vb')
  file {'/app/shared/docroots/adops-api.evolvemediallc.com/shared/config/secrets.yml':
    content => template('adops/app_adoperations_secrets.yml.erb'),
    owner   => 'adops-deploy',
    group   => 'adops-deploy',
  }
  # app1v-only stuff -- CAREFUL, THIS is APP3 FOR NOW
  if ($::fqdn_incr == '3' ) {
      # DB Credentials
  }
}
