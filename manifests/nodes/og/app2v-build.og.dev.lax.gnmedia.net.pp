node 'app2v-build.og.dev.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base
    $project="origin"
    $httpd='origin'
    include common::app
    include yum::ius

    # python-pkgs used in the phpcs jenkins build for html reports, ansible used in deploys
    # php packages are all used in jenky builds
    package { ['python-jinja2', 'python-lxml', 'python-argparse', 'php54-pecl-xdebug', 'ansible',
        'php-phpunit-PHPUnit','php54-pdepend-PHP-Depend','php-phpunit-phploc',
        'php-phpmd-PHP-PMD','php-phpunit-phpcpd','php-pear-PHP-CodeSniffer']:
        ensure => installed
    }

    common::nfsmount { "/app/shared":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_og_lax_dev_app_shared/build-dev",
    }

    common::nfsmount { "/app/software":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_og_lax_dev_app_shared/software",
    }

    common::nfsmount { "/app/log":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_og_lax_dev_app_log/app2v-build.og.dev.lax.gnmedia.net",
    }
}
