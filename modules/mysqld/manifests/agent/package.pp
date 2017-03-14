# Class: mysqld::agent::package
#
# This class manages the mysql-monitor-agent package
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class mysqld::agent::package {

    $emAgentPass = decrypt('P0c4PGSaUbkgdGYDWE5+yw==')
    $agent_hostname = $::fqdn_env ? {
        'prd'   => 'em.gnmedia.net',
        default => 'stg.em.gnmedia.net',
    }

    # Stage the installation file
    file { '/var/tmp/mysqlmonitoragent-2.3.9.2137-linux-glibc2.3-x86-64bit-installer.bin':
        ensure => file,
        source => 'puppet:///modules/mysqld/mysqlmonitoragent-2.3.9.2137-linux-glibc2.3-x86-64bit-installer.bin',
        owner  => 'root',
        group  => 'root',
        mode   => '0544',
    }

    exec { 'install-em-agent':
        command => '/bin/bash /var/tmp/em-agent-installer.sh',
        onlyif  => 'test -S /var/lib/mysql/mysql.sock && test ! -x /opt/mysql/enterprise/agent/bin/mysql-monitor-agent',
        require => [ File['/var/tmp/mysqlmonitoragent-2.3.9.2137-linux-glibc2.3-x86-64bit-installer.bin'], File['/var/tmp/em-agent-installer.sh']],
    }

    file { '/var/tmp/em-agent-installer.sh':
        ensure  => present,
        content => "/var/tmp/mysqlmonitoragent-2.3.9.2137-linux-glibc2.3-x86-64bit-installer.bin --mode unattended --installdir /opt/mysql/enterprise/agent --mysqluser em_agent --mysqlpassword ${emAgentPass} --createaccount 0 --managerhost http://${agent_hostname}:80/heartbeat > /var/tmp/em-agent-install.log 2>&1",
        owner   => root,
        group   => root,
        require => File['/var/tmp/mysqlmonitoragent-2.3.9.2137-linux-glibc2.3-x86-64bit-installer.bin'],
        mode    => '0544',
    }

    # FIXME !!! Terrible bug from the agent rpm that owns / and  /opt for some reason and mess up the permission (g+w)
    # We shouldn't have to do that
    file{ 'fix_root_perm':
        path    => '/',
        owner   => 'root',
        group   => 'root',
        mode    => '0755',
        recurse => false,
    }

    file{ '/opt':
        owner   => 'root',
        group   => 'root',
        mode    => '0755',
        recurse => false,
    }
}
