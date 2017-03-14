# class elasticsearch::parameterized

class elasticsearch::parameterized ($es_cluster, $es_nodetype = 'all', $es_nodename = $fqdn) {
    include elasticsearch::install
    $conf = '/etc/elasticsearch/elasticsearch.yml'

    # similar in usage to a File resource
    concat {$conf:
        owner     => 'root',
        group     => 'root',
        mode      => '0644',
    }

    # the base part of the config
    concat::fragment {'es_config_base':
        target    => $conf,
        content   => template('elasticsearch/elasticsearch.yml.erb'),
        order     => 01,
    }

    # just keeping this together with the actual hosts
    concat::fragment {'unicast_hosts':
        target    => $conf,
        content   => "discovery.zen.ping.unicast.hosts:\n",
        order     => '92',
    }

    # collect the exported concat::fragment resources
    Elasticsearch::Es_cluster_node <<| tag == $es_cluster |>>

    # general purpose ELK clusters need custom settings
    if $es_nodename =~ /^app([123])\d{2}v-(elasticsearch|logstash)\.tp\.prd/ {
        file {'/etc/sysconfig/elasticsearch':
            owner     => 'root',
            group     => 'root',
            mode      => '0644',
            source    => "puppet:///modules/elasticsearch/sysconfig/${1}XXv-${2}.tp.prd.lax",
            require   => [Package['elasticsearch']],
        }
    }
    elsif $es_nodename =~ /els[1-9]v-xf\.ao/ {
        file {'/etc/sysconfig/elasticsearch':
            owner     => 'root',
            group     => 'root',
            mode      => '0644',
            source    => "puppet:///modules/elasticsearch/sysconfig/ao-xf",
            require   => [Package['elasticsearch']],
        }
    }
    else {
        file {'/etc/sysconfig/elasticsearch':
            owner     => 'root',
            group     => 'root',
            mode      => '0644',
            content   => "ES_PATH_DATA=/app/shared/elasticsearch\nES_MIN_MEM=512m\nES_MAX_MEM=4g\n",
            require   => [Package['elasticsearch']],
        }
    }

    if (es_nodetype in ['all', 'master']) {
        # This is only needed if this node will hold data
        file {'/app/shared/elasticsearch':
            ensure    => directory,
            owner     => 'elasticsearch',
            group     => 'elasticsearch',
            mode      => '0755',
            require   => [Mount['/app/shared'],User['elasticsearch'],Group['elasticsearch']],
        }
    }

    service {'elasticsearch':
        enable    => true,
        hasstatus => true,
        require   => [Class['elasticsearch::install'],Concat[$conf],File['/etc/sysconfig/elasticsearch']],
    }

    @@elasticsearch::es_cluster_node{"es_node_${fqdn}":
        conf      => $conf,
        tag       => $es_cluster,
    }

    nagios::service {'elasticsearch':
        command   => 'check_http_json-string!9200!_cluster/health!status!green',
        notes_url => 'http://docs.gnmedia.net/wiki/Nagios-elasticsearch'
    }

}
