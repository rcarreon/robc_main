# elastic search cluster defined type
define elasticsearch::es_cluster_node ($host = $fqdn, $conf = '/etc/elasticsearch/elasticsearch.yml') {
    concat::fragment{"es_cluster_node_${host}":
        target    => $conf,
        content   => inline_template("  - <%= host %>\n"),
        order     => 93,
    }
}

