# base class is to be inherited by the nodes.

class rsyslog {
    case $::fqdn {
        /app.*v-puppet.*/: {
            # puppet is way too noisy
            $syslogtoxcat = false
        }
        /app.*v-xcat.*/: {
            $syslogtoxcat = false
        }
        /app.*v-rancid.*/: {
            $syslogtoxcat = false
        }
        default: {
            $syslogtoxcat = true
        }
    }

    # These don't really need to be here, but it's easier for ci peeps
    case $::fqdn {
        /.*\.ci\.(dev|stg|prd)\..*/: {
            include rsyslog::locallogs
        }
        /.*\.ap\.(dev|stg|prd)\..*/: {
            include rsyslog::locallogs
        }
        /uid1v-gstaples.*/: {
            include rsyslog::locallogs
        }
        /app1v-xcat.*/: {
            include rsyslog::remotereception
            include rsyslog::remoteauditlog
        }
        default: {
        }
    }


    package { 'rsyslog':
        ensure     => present,
    }
    service {'rsyslog':
        ensure     => running,
        enable     => true,
        hasrestart => true,
        require    => Package['rsyslog'],
    }

    file { '/etc/rsyslog.conf':
        source     => 'puppet:///modules/rsyslog/rsyslog.conf',
        owner      => 'root',
        group      => 'root',
        mode       => '0644',
        notify     => Service['rsyslog'],
    }
    file { '/etc/rsyslog.d':
        ensure     => directory,
        source     => 'puppet:///modules/common/empty-directory',
        recurse    => true,
        purge      => true,
        owner      => 'root',
        group      => 'root',
        mode       => '0755',
        ignore     => '.svn',
    }
    if $syslogtoxcat == true {
        include rsyslog::xcatremote
    }
}
