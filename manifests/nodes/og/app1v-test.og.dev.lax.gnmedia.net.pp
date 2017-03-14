node 'app1v-test.og.dev.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
  include base
  include yum::ius

  $project = "origin"

  package {
    [
      "php54-cli",
      "php54-common",
      "php54-mbstring",
      "nodejs",
      "npm"
    ]:
    ensure => "installed",
  }

  # I had to opt for this method since phpunit's RPM has PHP 5.3 as a dependency
  exec { "install-phpunit":
    command => "wget https://phar.phpunit.de/phpunit.phar && chmod +x phpunit.phar && mv phpunit.phar /usr/local/bin/phpunit",
    creates => "/usr/local/bin/phpunit",
    require => [
      Package["php54-cli"],
      Package["php54-common"],
    ]
  }

  exec { "install-grunt":
    command => "npm install -g grunt@0.4.5",
    creates => "/usr/lib/node_modules/grunt",
    require => Package["npm"],
  }

  exec { "install-grunt-cli":
    command => "npm install -g grunt-cli@0.1.13",
    creates => "/usr/lib/node_modules/grunt-cli",
    require => Package["npm"],
  }

  exec { "install-protractor":
    command => "npm install -g protractor@2.1.0",
    creates => "/usr/lib/node_modules/protractor",
    require => Package["npm"],
  }

  exec { "install-jasmine":
    command => "npm install -g jasmine@2.3.2",
    creates => "/usr/lib/node_modules/jasmine",
    require => Package["npm"],
  }
}
