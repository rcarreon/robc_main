# Anything in this class will be included on all systems
class base {

    ### packages ###

    $basepackages = ['dstat', 'htop', 'screen', 'sysstat', 'nfs-utils', 'perl-Config-General']
    package { $basepackages:
        ensure => present
    }

    ### services ###

    $useless_services = ['cups', 'gpm', 'pcscd', 'yum-updatesd','avahi-daemon','avahi-dnsconfd']
    service { $useless_services:
        ensure      => stopped,
        enable      => false,
        hasstatus   => true,
    }

    ### centos 6 boxes need rpcbind running
    case $operatingsystemrelease {
        /^6.*/: {
            package { ['rpcbind']:
                ensure => installed,
            }
            service { 'rpcbind':
                ensure    => running,
                enable    => true,
                hasstatus => true,
                require   => Package['rpcbind'],
            }
        }
        ## note, for centos 5 boxes this should be portmap
        ## since we don't have much but vb.prd cent 5 boxes I'm skipping
    }



    ### includes ###

    # list includes by alpha so they are easy to find
    include auth
    include collectd::client
    include cron
    include logrotate
    include nagios::client
    include ntp
    include perl
    include rc_local
    include rsyslog::locallogs
    include resolv
    include rsyslog
    include rt::client
    include sshd
    include sudo
    include xinetd
    include yum::client

    if ($::fqdn_type != 'puppet') {
        include puppet_agent
    }
    if ($::fqdn_role == 'sql') {
        sudo::install_template { 'dba-root': }
    }


    ### files ###

    file { '/usr/local/bin/dmesgT':
        ensure => file,
        source => 'puppet:///modules/base/dmesgT',
        mode   => '0755',
        owner  => 'root',
        group  => 'root',
    }

}
