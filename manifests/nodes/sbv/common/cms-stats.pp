class cms::stats::web {
   # moved to node scope because this doesn't work with dynamic scoping
   # $project="springboard"

  include httpd
  include php::stats
  
  file {"/tmp/queue":
      ensure => directory,
      owner  => apache,
      group  => apache,
  }

  package { "GeoIP":
      ensure => present,
  }

  package { "php-pear-Net_GeoIP":
		ensure => present,
  }

  file { "/app/shared/geoip/":
      ensure => directory,
      owner  => "deploy",
  }



}
class cms::stats::dev {
  include cms::stats::web
  package { "GeoIP-devel":
      ensure => present,
  }
  package { "httpd-devel":
	  ensure => present,
  }
  package { "subversion":
	  ensure => present,
  }
  redis::store {"dev.sbvideo-analytics":
    monitorQueue => true,
    listname     => "lax1",
    timeout      => "2",
    threshold    => "150000",
    port         => "6379"
  }
  cron { "readInsertFromRedis":
      user    => apache,
      minute  => "*/15",
      command => 'php /app/shared/docroots/analytics.springboardvideo.com/current/readInsertFromRedis.php >> /app/log/readInsertFromRedis.log',
  }
  cron { "readInsertFromRedisCpv":
    user    => "apache",
    minute  => "*/15",
    command => 'php /app/shared/docroots/analytics.springboardvideo.com/current/readInsertFromRedisCpv.php >> /app/log/readInsertFromRedisCpv.log',
  }
}
class cms::stats::stage {
  include cms::stats::web
  redis::store {"stg.sbvideo-analytics":
    monitorQueue => true,
    listname     => "lax1",
    timeout      => "2",
    threshold    => "150000",
    port         => "6379"
  }
  cron { "readInsertFromRedis":
      user    => apache,
      minute  => "*/15",
      command => 'php /app/shared/docroots/analytics.springboardvideo.com/current/readInsertFromRedis.php >> /app/log/readInsertFromRedis.log',
  }
  cron { "readInsertFromRedisCpv":
    user    => "apache",
    minute  => "*/15",
    command => 'php /app/shared/docroots/analytics.springboardvideo.com/current/readInsertFromRedisCpv.php >> /app/log/readInsertFromRedisCpv.log',
  }
  cron { "readInsertFromRedisBraga":
    user    => "apache",
    minute  => "*/15",
    command => 'php /app/shared/docroots/analytics.springboardvideo.com/current/readInsertFromRedisBraga.php >> /app/log/readInsertFromRedisBraga.log',
  }
}
class cms::stats::prod {
  include cms::stats::web
  redis::store {"sbvideo-analytics":
    monitorQueue => true,
    listname     => "lax1",
    timeout      => "2",
    threshold    => "150000",
    port         => "6379"
  }
  cron { "readInsertFromRedis":
    user    => apache,
    minute  => "*/15",
    command => 'php /app/shared/docroots/analytics.springboardvideo.com/current/readInsertFromRedis.php >> /app/log/readInsertFromRedis.log',
  }
  cron { "readInsertFromRedisCpv":
    user    => "apache",
    minute  => "*/15",
    command => 'php /app/shared/docroots/analytics.springboardvideo.com/current/readInsertFromRedisCpv.php >> /app/log/readInsertFromRedisCpv.log',
  }
}

