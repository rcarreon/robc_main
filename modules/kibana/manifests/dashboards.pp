# dashboards for kibana
class kibana::dashboards {
    file {'/usr/local/share/kibana':
        ensure => directory,
        owner  => 'root',
        group  => 'root',
        mode   => '0755',
    }

    file {'/usr/local/share/kibana/homepage_template.json':
        ensure  => file,
        source  => 'puppet:///modules/kibana/homepage_template.json',
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        require => File['/usr/local/share/kibana'],
    }
    file {'/usr/local/share/kibana/site_template.json':
        ensure  => file,
        source  => 'puppet:///modules/kibana/site_template.json',
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        require => File['/usr/local/share/kibana'],
    }
    file {'/usr/local/share/kibana/error_template.json':
        ensure  => file,
        source  => 'puppet:///modules/kibana/error_template.json',
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        require => File['/usr/local/share/kibana'],
    }
    file {'/usr/local/share/kibana/plat_template.json':
        ensure  => file,
        source  => 'puppet:///modules/kibana/plat_template.json',
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        require => File['/usr/local/share/kibana'],
    }
    file {'/usr/local/sbin/indices2dashboards':
        ensure => file,
        source => 'puppet:///modules/kibana/indices2dashboards',
        owner  => 'root',
        group  => 'root',
        mode   => '0755',
    }
    cron {'indices2dashboards-prd':
        ensure  => present,
        command => '/usr/local/sbin/indices2dashboards -e app102v-elasticsearch.tp.prd.lax.gnmedia.net:9200 -d /app/shared/docroots/prd.kibana.gnmedia.net/current/app/dashboards -s access=/usr/local/share/kibana/site_template.json,error=/usr/local/share/kibana/error_template.json,plat=/usr/local/share/kibana/plat_template.json -p /usr/local/share/kibana/homepage_template.json -E prd',
        user    => 'root',
        hour    => '*',
        minute  => '1',
    }
    cron {'indices2dashboards-stg':
        ensure  => present,
        command => '/usr/local/sbin/indices2dashboards -e app201v-elasticsearch.tp.prd.lax.gnmedia.net:9200 -d /app/shared/docroots/stg.kibana.gnmedia.net/current/app/dashboards -s access=/usr/local/share/kibana/site_template.json,error=/usr/local/share/kibana/error_template.json,plat=/usr/local/share/kibana/plat_template.json -p /usr/local/share/kibana/homepage_template.json -E stg',
        user    => 'root',
        hour    => '*',
        minute  => '5',
    }
    cron {'indices2dashboards-dev':
        ensure  => present,
        command => '/usr/local/sbin/indices2dashboards -e app301v-elasticsearch.tp.prd.lax.gnmedia.net:9200 -d /app/shared/docroots/dev.kibana.gnmedia.net/current/app/dashboards -s access=/usr/local/share/kibana/site_template.json,error=/usr/local/share/kibana/error_template.json,plat=/usr/local/share/kibana/plat_template.json -p /usr/local/share/kibana/homepage_template.json -E dev',
        user    => 'root',
        hour    => '*',
        minute  => '10',
    }

}
