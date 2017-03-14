# Class: redis::store

    define redis::store($monitorQueue = false, $listname = 'lax1', $timeout = '1', $threshold = '50000', $port = '6379'){
        include redis::monitor
        file{ 'redis_config':
            content   => template("redis/${name}.conf.erb"),
            path      => '/etc/redis.conf',
            owner     => 'redis',
            group     => 'redis',
            require   => Class['redis::install'],
            mode      => '0644',
        }

        service { 'redis':
            ensure    => running,
            enable    => true,
            hasstatus => true,
            require   => Class['redis::install'],
        }
        file { '/var/run/redis/redis.pid':
            ensure    => 'file',
            owner     => 'redis',
            group     => 'root',
            mode      => '0644',
        }
        if $monitorQueue == true {
            nagios::service {'redisQueue':
            command   => "check_redis_queue.sh!${listname}!${timeout}!${threshold}!${port}!${::fqdn}",
            notes_url => 'http://docs.gnmedia.net/wiki/Nagios-redisqueue',
          }
        }

    }
