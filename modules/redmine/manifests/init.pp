# redmine puppet module
#
# On the application server manifest:
#
#    $sqlpass = decrypt("AiVP5/jsD1ek59KEUF/a5Q==")
#
#    class { 'redmine':
#        dbpasswd => $sqlpass,
#        dbserver => 'sql1v-redmine.tp.dev.lax.gnmedia.net'
#    }
#
# Where the encrypted sql passwd should be encrypted on the
# puppetmaster, using the encrypt.rb script:
#
#    [jcamou@app1v-puppet ~]$ sudo encrypt.rb 
#    Enter secret: s0m3p4$$wd
#    AiVP5/jsD1ek59KEUF/a5Q==
#
# `dbpasswd' and `dbserver' are mandatory.  `version', `vhost',
# `expect', `database' and `dbuser' have the default values of
# the redmine class definition below.
# 

class redmine (
    $version        = '2.2.2',
    $vhost          = 'redmine.gnmedia.net',
    $expect         = 'Redmine',
    $database       = 'redmine',
    $dbuser         = 'redmine_w',
    $dbpasswd,
    $dbserver
) {

    include httpd
    httpd::virtual_host { "$vhost": expect => "$expect" }

    $passenger_version      = '4.0.5'
    $mod_passenger_location = "/usr/lib/ruby/gems/1.8/gems/passenger-$passenger_version/libout/apache2/mod_passenger.so"

    $path   = '/app/shared/redmine.gnmedia.net'
    $gembin = "$(gem env gemdir)/bin"
    $gems   = [ "i18n", "rails", "bundler", "rmagick" ]

    file { 'redmine_docroot':
        path    => $path,
        ensure  => directory,
        owner   => 'deploy'
    }

    $pkgs = [ 'git', 'ImageMagick-devel', 'mysql-devel', 'rubygems', 'libcurl-devel', 
              'ruby-devel', 'gcc-c++', 'httpd-devel', 'apr-devel', 'apr-util-devel' ]

    package { $pkgs: 
        ensure => installed
    }

    package { 'passenger':
        provider => 'gem',
        ensure   => "$passenger_version",
        require  => Package['rubygems'],
    }

    package { $gems:
        require   => Package["rubygems"],
        provider  => "gem"
    }

    exec { 'install_mod_passenger':
        command => "/usr/bin/passenger-install-apache2-module -a",
        unless  => "/usr/bin/test -e $mod_passenger_location",
        require => Package[$gems]
    }

    exec { "get_redmine":
        require => [Package["git"], File["redmine_docroot"]],
        cwd     => $path,
        onlyif  => "test ! -d $path/app",
        command => "git clone git://github.com/redmine/redmine.git ."
    }

    exec { "pick_version":
        require => Exec["get_redmine"],
        cwd     => $path,
        onlyif  => "test '$version' != $(git describe --exact-match --all -tags --always HEAD)",
        command => "git checkout $version"
    }

    exec { "install_bundles":
        require   => Exec['pick_version'],
        creates   => "$path/config/initializers/secret_token.rb",
        cwd       => $path,
        command   => "bundle install --without test postgresql sqlite"
    }

    exec { "initialize_redmine":
        require   => Exec["install_bundles"],
        creates   => "$path/config/initializers/secret_token.rb",
        cwd       => $path,
        command   => "rake generate_secret_token RAILS_ENV=production"
     }

    file { "$path/config/database.yml":
        content => template("redmine/database.yml.erb"),
        require => Exec['get_redmine']
    }

    file { '/etc/httpd/conf.d/passenger.conf':
        content => template("redmine/passenger.conf.erb"),
        owner   => apache,
        mode    => 644,
        require => Package['passenger'],
        notify  => Service['httpd']
    }
}
