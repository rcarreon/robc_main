
# usage
#        class {'nginx::install': config_template=>'default-non-proxy'}
# ex 1.  setup virtual host dev.widget.crowdignite.com
#        using widget.crowdignite.com.conf.erb template
#        nginx_vhost {"dev.widget.crowdignite.com": virtual_template=>'widget.crowdignite.com'}

# ex 2.  set up virtual host jmoilanen.widget.crowdignite.com
#        using devspace.widget.crowdignite.com.conf.erb template with option dev var which uses for path
#        nginx_vhost {"jmoilanen.widget.crowdignite.com": virtual_template=>'devspace.widget.crowdignite.com',dev=>'jmoilanen'}

# ex 3.  same as ex2 but with more than 1 virtual host
#        we put all the hosts in  vhost_list=>"",
#        ex.  vhost_list=>"host1.com host2.com www.host3.com"
#        nginx_vhost {"jmoilanen.widget.crowdignite.com": virtual_template=>'devspace.widget.crowdignite.com',dev=>'jmoilanen',vhost_list=>"jmoilanen.widget.crowdignite.com jake.widget.crowdignite.com"}

class nginx::install($config_template='') {

    include collectd::plugins::nginx
    package {'nginx':
        ensure  => present,
    }

    if $config_template != '' {
        file { '/etc/nginx/nginx.conf':
            ensure  => file,
            owner   => root,
            group   => root,
            mode    => '0644',
            content => template("nginx/nginx.conf.${config_template}"),
            notify  => Exec['reload-nginx'],
            require => Package['nginx'];
        }
    } else {
        err('missing required config template')
    }

    file { '/etc/nginx/conf.d/virtual.conf':
        ensure => absent,
    }

    file { '/usr/share/nginx/html/index.html':
        ensure    => file,
        owner     => root,
        group     => root,
        mode      => '0644',
        source    => 'puppet:///modules/nginx/index.html',
        require   => Package['nginx'],
    }


    exec { 'reload-nginx':
        command     => '/sbin/service nginx reload',
        refreshonly => true
    }

    service {'nginx':
        ensure    => running,
        enable    => true,
        hasstatus => true,
        require   => Package['nginx'],
    }

    if $project == 'crowdignite' {
        file { '/app/log/nginx':
            ensure  => directory,
            owner   => apache,
            group   => apache,
            mode    => '0644',
            require => Package['nginx'];
        }
    } else {
        file { '/app/log/nginx':
            ensure  => directory,
            owner   => nginx,
            group   => nginx,
            mode    => '0644',
            require => Package['nginx'];
        }
    }

    # These are needed to copy docroot to /dev/shm on startup
    if $project == 'crowdignite' {
        file { '/etc/rc.d/init.d/ciwidget':
            ensure  => file,
            source  => 'puppet:///modules/nginx/crowdignite/ciwidget-init',
            owner   => root,
            group   => root,
            mode    => '0755',
        }

        file { '/usr/local/bin/deploy_ci_widget.sh':
            ensure  => file,
            source  => 'puppet:///modules/nginx/crowdignite/deploy_ci_widget.sh',
            owner   => root,
            group   => root,
            mode    => '0755',
        }

        exec { 'bootstart-ciwidget':
            command => '/sbin/chkconfig ciwidget on',
            require => File['/etc/rc.d/init.d/ciwidget'],
            unless  => '/usr/bin/test -x /etc/rc3.d/S80ciwidget 2>/dev/null'
        }
    }

    file { '/etc/logrotate.d/nginx':
        ensure  => file,
        owner   => root,
        group   => root,
        mode    => '0644',
        source  => 'puppet:///modules/nginx/logrotate',
        require => Package['nginx'];
    }

    file { '/etc/cron.hourly/logrotate.nginx':
        ensure  => absent,
        owner   => root,
        group   => root,
        mode    => '0755',
        source  => 'puppet:///modules/nginx/logrotate.cron',
        require => Package['nginx'];
    }

}
