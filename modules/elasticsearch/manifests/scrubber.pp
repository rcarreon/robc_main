# class elasticsearch::scrubber

class elasticsearch::scrubber ($indices = '30', $indexname = 'logstash', $url = 'http://localhost:9200', $logfile='/tmp/elasticsearch-scrubber.log') {

    package{'perl-JSON':
        ensure  => installed,
    }

    file {'/usr/local/sbin/elasticsearch-remove-old-indices.sh':
        ensure  => file,
        source  => 'puppet:///modules/elasticsearch/elasticsearch-remove-old-indices.sh',
        mode    => '0755',
        owner   => 'root',
        group   => 'root'
    }

    cron {'elasticsearch-scrubber-myanimelist_ao_access':
        user    => 'root',
        hour    => '1',
        minute  => '10',
        command => "/usr/local/sbin/elasticsearch-remove-old-indices.sh -i ${indices} -g myanimelist.net_ao_access -e ${url} -o ${logfile}",
    }
    cron {'elasticsearch-scrubber-myanimelist_ao_error':
        user    => 'root',
        hour    => 1,
        minute  => 25,
        command => "/usr/local/sbin/elasticsearch-remove-old-indices.sh -i ${indices} -g myanimelist.net_ao_error -e ${url} -o ${logfile}",
    }
    cron {'elasticsearch-scrubber-thefashionspot_ao_access':
        user    => 'root',
        hour    => 1,
        minute  => 10,
        command => "/usr/local/sbin/elasticsearch-remove-old-indices.sh -i ${indices} -g thefashionspot.com_ao_access -e ${url} -o ${logfile}",
    }
    cron {'elasticsearch-scrubber-thefashionspot_ao_error':
        user    => 'root',
        hour    => 1,
        minute  => 25,
        command => "/usr/local/sbin/elasticsearch-remove-old-indices.sh -i ${indices} -g thefashionspot.com_ao_error -e ${url} -o ${logfile}",
    }
}

