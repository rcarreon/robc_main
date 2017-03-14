# common configs for app-origin.og.stg servers
class origin::stg_one_box {

      include subversion::client
      include git::client
	
      package { ['php54-mbstring.x86_64']: ensure => installed, }
      ###### DB Credentials
      ## RO to origin database
      $origin_ro_user = 'origin_r'
      $origin_ro_pw   = decrypt('p8x9f8NscmPHqpw/jHwFZw==')
      $origin_ro_host = 'VIP-SQLRO-ORIGIN.OG.STG.LAX'
      $origin_ro_db   = 'origin'

      ## RW to origin database
      $origin_rw_user = 'origin_w'
      $origin_rw_pw   = decrypt('LZ/2yYJs5rSqZ5dih0ZVDA==')
      $origin_rw_host = 'VIP-SQLRW-ORIGIN.OG.STG.LAX'
      $origin_rw_db   = 'origin'

      ## RO to analytics database
      $analytics_ro_host = 'vip-sqlro-bd.og.prd.lax.gnmedia.net'
      $analytics_ro_db = 'analytics'
      $analytics_ro_user = 'analytics_r'
      $analytics_ro_pw = ''

      ## RO to audit database
      $audit_ro_user  = 'audit_r'
      $audit_ro_pw    = decrypt('rTU+mQy/TW4+xXnfq2RaZA==')
      $audit_ro_host  = 'VIP-SQLRO-ORIGIN.OG.STG.LAX'
      $audit_ro_db    = 'audit'

      ## RW to audit database
      $audit_rw_user  = 'audit_w'
      $audit_rw_pw    = decrypt('8ksATONLRK4JgsKvDDr0qA==')
      $audit_rw_host  = 'VIP-SQLRW-ORIGIN.OG.STG.LAX'
      $audit_rw_db    = 'audit'
      ###### End of DB Credentials

      file { '/app/shared/docroots/originplatform.com/config/app_originplatform_database.php':
          ensure  => present,
          content => template('origin/app_originplatform_database.php.erb'),
          require => File['/app/shared/docroots/originplatform.com/config'],
      }

      # Docroot directories
      file { '/app/shared/docroots':
          ensure  => directory,
          owner   => 'root',
          group   => 'root',
          mode    => '0755',
          require => Class['httpd'],
      } ->
      file { '/app/shared/docroots/originplatform.com':
          ensure  => directory,
          owner   => 'em-deploy',
          group   => 'root',
          mode    => '0755',
      } ->
      file { '/app/shared/docroots/originplatform.com/config':
          ensure  => directory,
          owner   => 'root',
          group   => 'root',
          mode    => '0755',
      }

}
