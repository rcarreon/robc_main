# Common packages, files, and configs for pubops (on rails) app servers
class ap::app::pubops_martini {

  ### packages
  include common::app
  include httpd
  include adops::rbenv
  include adops::rubybase
  include adops::passenger4
  # include logrotate::pubops

  ### appdirs
  # docroot
  file { '/app/shared/docroots':
    ensure  => directory,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    require => Class['httpd'],
  } ->
  file {
    [
      '/app/shared/docroots/pubops.affluentdigitalmediallc.com',
      '/app/shared/docroots/pubops.affluentdigitalmediallc.com/shared',
      '/app/shared/docroots/pubops.affluentdigitalmediallc.com/shared/config',
      '/app/shared/docroots/pubops.affluentdigitalmediallc.com/releases']:
    ensure  => directory,
    owner   => 'adops-deploy',
    group   => 'adops-deploy',
    mode    => '0755',
  } ->
  file {
    [
      '/app/shared/docroots/pubops.affluentdigitalmediallc.com/shared/tmp',
      '/app/shared/docroots/pubops.affluentdigitalmediallc.com/shared/tmp/cache']:
    ensure  => directory,
    owner   => 'adops-deploy',
    group   => 'adops-deploy',
    mode    => '0775',
  }

  file { '/app/log/pubops':
    ensure  => directory,
    mode    => '0755',
    require => File['/app/log'],
    owner   => 'root',
    group   => 'root',
  }

  file { '/app/log/pubops/nobody':
    ensure  => directory,
    mode    => '0755',
    owner   => 'nobody',
    group   => 'nobody',
    require => File['/app/log/pubops'],
  }

  file { '/app/log/pubops/apache':
    ensure  => directory,
    mode    => '0755',
    owner   => 'apache',
    group   => 'apache',
    require => File['/app/log/pubops'],
  }

  file { '/app/log/pubops/adops-deploy':
    ensure  => directory,
    mode    => '0755',
    owner   => 'adops-deploy',
    group   => 'adops-deploy',
    require => File['/app/log/pubops'],
  }

}

# DEV-specific configs
class ap::app::pubops_martini::dev {

    # app1v-only stuff
    if ($::fqdn_incr == '1' ) {
        # DB Credentials
        $env_ruby_app = 'development'
        $host_app_rw  = 'sql1v-pubops-martini.ap.dev.lax.gnmedia.net'
        $user_app_rw  = 'ap_pub_martini_w'
        $pass_app_rw  = decrypt('0KrThu5RvgMQ8hTRdzLAnw==')
        $db_app_rw  = 'ap_pubops_martini'

        # Secret Key Base
        $rails_env_name = 'development'
        $rails_secret_key = decrypt('q+QIvt8ImWaXgORzGhVq9821YprUbyvyUQ5eTPRGh60qAZd59n6fMLU7o+M60yLhVMQroaID/vCW3CWkPRssA0hD68nbGOSvZOTE03U/8GnRTvrWgBhpi2QcDoMx70EEMjbYk6rE4xvVYYiuKPQNuzdr4H+bbWoUM+oVitBWfft8GXTH8H7HI8wY6l8mLW7n')

        file {'/app/shared/docroots/pubops.affluentdigitalmediallc.com/shared/config/database.yml':
          content => template('adops/database.basic.yml.erb'),
          owner   => 'adops-deploy',
          group   => 'adops-deploy',
        }->
        file { '/app/shared/docroots/pubops.affluentdigitalmediallc.com/shared/config/secrets.yml':
          ensure  => file,
          content => template('adops/rails_secrets.yml.erb'),
          owner   => 'root',
          group   => 'root',
          mode    => '0755',
          require => File['/app/shared/docroots/pubops.affluentdigitalmediallc.com/shared/config'],
        }

        # Define The adops environment in adops_env, for use with cron rake tasks
        file {'/app/shared/docroots/pubops.affluentdigitalmediallc.com/shared/config/pubops_webui_env':
          ensure  => file,
          owner   => 'adops-deploy',
          group   => 'adops-deploy',
          mode    => '0644',
          content => 'development',
        }

        # etl script
        $martini_etl_host_local = 'sql1v-pubops-martini.ap.dev.lax.gnmedia.net'
        $martini_etl_user_local = 'ap_martinietl_rw'
        $martini_etl_pass_local = decrypt('cKKUQP6YrrwjyOl2GF/G0A==')

        $martini_etl_host_remote = 'stagingadservingdata.c27hiz0xxzr5.us-east-1.rds.amazonaws.com'
        $martini_etl_user_remote = 'evolve_adops_ro'
        $martini_etl_pass_remote = decrypt('CZg+6DRav4pQ18bfZTr7BIhoyNPvN1KPrNjdWnG3B7s=')

        file {'/usr/local/bin/etl_microstrategy_to_adops':
          ensure  => file,
          owner   => 'root',
          group   => 'root',
          mode    => '0755',
          content => template('adops/etl_microstrategy_to_adops.erb'),
        }
        cron { 'etl_microstrategy_to_adops':
          ensure  => present,
          user    => 'nobody',
          command => '/usr/local/bin/etl_microstrategy_to_adops',
          hour    => '8',
          minute  => '0',
        }
    }
}

# STG-specific configs
class ap::app::pubops_martini::stg {
    include adops::devmail

    # app1v-only stuff
    if ($::fqdn_incr == '1' ) {
        # DB Credentials
        $env_ruby_app = 'staging'
        $host_app_rw  = 'vip-sqlrw-pubops-martini.ap.stg.lax.gnmedia.net'
        $user_app_rw  = 'ap_pub_martini_w'
        $pass_app_rw  = decrypt('7P/z5+UMPIMXDYdQ3a1Con3rId9hp2fFGIQAS68iPIA=')
        $db_app_rw  = 'ap_pubops_martini'

        # Secret Key Base
        $rails_env_name = 'staging'
        $rails_secret_key = decrypt('q+QIvt8ImWaXgORzGhVq9821YprUbyvyUQ5eTPRGh60qAZd59n6fMLU7o+M60yLhVMQroaID/vCW3CWkPRssA0hD68nbGOSvZOTE03U/8GnRTvrWgBhpi2QcDoMx70EEMjbYk6rE4xvVYYiuKPQNuzdr4H+bbWoUM+oVitBWfft8GXTH8H7HI8wY6l8mLW7n')

        file {'/app/shared/docroots/pubops.affluentdigitalmediallc.com/shared/config/database.yml':
          content => template('adops/database.basic.yml.erb'),
          owner   => 'adops-deploy',
          group   => 'adops-deploy',
        }->
        file { '/app/shared/docroots/pubops.affluentdigitalmediallc.com/shared/config/secrets.yml':
          ensure  => file,
          content => template('adops/rails_secrets.yml.erb'),
          owner   => 'root',
          group   => 'root',
          mode    => '0755',
          require => File['/app/shared/docroots/pubops.affluentdigitalmediallc.com/shared/config'],
        }

        # Define The adops environment in adops_env, for use with cron rake tasks
        file {'/app/shared/docroots/pubops.affluentdigitalmediallc.com/shared/config/pubops_webui_env':
          ensure  => file,
          owner   => 'adops-deploy',
          group   => 'adops-deploy',
          mode    => '0644',
          content => 'staging',
        }

        # etl script
        $martini_etl_host_local = 'vip-sqlrw-pubops-martini.ap.stg.lax.gnmedia.net'
        $martini_etl_user_local = 'ap_martinietl_rw'
        $martini_etl_pass_local = decrypt('HGHp8eceAWBIPTML+El+Vg==')

        $martini_etl_host_remote = 'stagingadservingdata.c27hiz0xxzr5.us-east-1.rds.amazonaws.com'
        $martini_etl_user_remote = 'evolve_adops_ro'
        $martini_etl_pass_remote = decrypt('CZg+6DRav4pQ18bfZTr7BIhoyNPvN1KPrNjdWnG3B7s=')

        file {'/usr/local/bin/etl_microstrategy_to_adops':
          ensure  => file,
          owner   => 'root',
          group   => 'root',
          mode    => '0755',
          content => template('adops/etl_microstrategy_to_adops.erb'),
        }
        cron { 'etl_microstrategy_to_adops':
          ensure  => present,
          user    => 'nobody',
          command => '/usr/local/bin/etl_microstrategy_to_adops',
          hour    => '8',
          minute  => '0',
        }
    }
}

# PRD-specific configs
class ap::app::pubops_martini::prd {
    include adops::devmail

    # app1v-only stuff
    if ($::fqdn_incr == '1' ) {
        # DB Credentials
        $env_ruby_app = 'production'
        $host_app_rw  = 'vip-sqlrw-pubops-martini.ap.prd.lax.gnmedia.net'
        $user_app_rw  = 'ap_pub_martini_w'
        $pass_app_rw  = decrypt('sUFBv+RGxhOOeg79dYF4Pr1MDYqYDsQl9b1Is0xpNSY=')
        $db_app_rw  = 'ap_pubops_martini'

        # Secret Key Base
        $rails_env_name = 'production'
        $rails_secret_key = decrypt('q+QIvt8ImWaXgORzGhVq9821YprUbyvyUQ5eTPRGh60qAZd59n6fMLU7o+M60yLhVMQroaID/vCW3CWkPRssA0hD68nbGOSvZOTE03U/8GnRTvrWgBhpi2QcDoMx70EEMjbYk6rE4xvVYYiuKPQNuzdr4H+bbWoUM+oVitBWfft8GXTH8H7HI8wY6l8mLW7n')

        file {'/app/shared/docroots/pubops.affluentdigitalmediallc.com/shared/config/database.yml':
          content => template('adops/database.basic.yml.erb'),
          owner   => 'adops-deploy',
          group   => 'adops-deploy',
        }->
        file { '/app/shared/docroots/pubops.affluentdigitalmediallc.com/shared/config/secrets.yml':
          ensure  => file,
          content => template('adops/rails_secrets.yml.erb'),
          owner   => 'root',
          group   => 'root',
          mode    => '0755',
          require => File['/app/shared/docroots/pubops.affluentdigitalmediallc.com/shared/config'],
        }

        # Define The adops environment in adops_env, for use with cron rake tasks
        file {'/app/shared/docroots/pubops.affluentdigitalmediallc.com/shared/config/pubops_webui_env':
          ensure  => file,
          owner   => 'adops-deploy',
          group   => 'adops-deploy',
          mode    => '0644',
          content => 'production',
        }

        # etl script
        $martini_etl_host_local = 'vip-sqlrw-pubops-martini.ap.prd.lax.gnmedia.net'
        $martini_etl_user_local = 'ap_martinietl_rw'
        $martini_etl_pass_local = decrypt('A91LgL3FTy65Nxj9lEoR5g==')

        $martini_etl_host_remote = 'prodadservingdata.c27hiz0xxzr5.us-east-1.rds.amazonaws.com'
        $martini_etl_user_remote = 'evolve_adops_ro'
        $martini_etl_pass_remote = decrypt('amccv8k96UDC/bBzzYNDcfG/VeWYwdWoUJ4pQZw0Ixc=')

        file {'/usr/local/bin/etl_microstrategy_to_adops':
          ensure  => file,
          owner   => 'root',
          group   => 'root',
          mode    => '0755',
          content => template('adops/etl_microstrategy_to_adops.erb'),
        }
        cron { 'etl_microstrategy_to_adops':
          ensure  => present,
          user    => 'nobody',
          command => '/usr/local/bin/etl_microstrategy_to_adops',
          hour    => '8',
          minute  => '0',
        }
    }
}
