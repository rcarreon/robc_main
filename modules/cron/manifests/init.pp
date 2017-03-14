# Cron

class cron {
    if ($::lsbmajdistrelease == 5) {
        $cronpkg='vixie-cron'
    }
    else {
        $cronpkg='cronie'
    }

    package{$cronpkg:
        ensure  => installed,
    }

    service{'crond':
        enable  => true,
        require => [Package[$cronpkg]],
    }

    # Remove some annoying and time-consuming defaults
    file {'/etc/cron.weekly/makewhatis.cron':
        ensure  => absent,
        require => [Package[$cronpkg]],
        backup  => undef,
    }

    file {'/etc/cron.daily/makewhatis.cron':
        ensure  => absent,
        require => [Package[$cronpkg]],
        backup  => undef,
    }

    file {'/etc/cron.daily/mlocate.cron':
        ensure  => absent,
        require => [Package[$cronpkg]],
        backup  => undef,
    }

        # this is on el6 only, we have elected to use /etc/crontab as usual
    file {'/etc/cron.d/dailyjobs':
        ensure  => absent,
        require => [Package[$cronpkg]],
        backup  => undef,
    }

    file {'/etc/cron.d/0hourly':
        ensure  => absent,
        require => [Package[$cronpkg]],
        backup  => undef,
    }

        # Let's add some seed to avoid having daily and weekly|monthly happening at the same time
        $minute_hourly=fqdn_rand(60,60)
        $minute_daily=fqdn_rand(60)
        $minute_weekly=fqdn_rand(60,7)
        $minute_monthly=fqdn_rand(60,30)

    file {'/etc/crontab':
        content => template('cron/crontab.erb'),
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
    }
}
