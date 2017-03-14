# Class: emagent::config
#
# This class manages the mysql-monitor-agent configuration files
#
# Parameters:
#
# Actions:
#
# Requires:
# fact: $mysql-monitor-agent-uuid
#
# Sample Usage:
#
class emagent::config {
    include emagent::package

    $mysql_agent_base_folder = '/opt/mysql/enterprise/agent'
    $mysqld_agent_password = decrypt('RKuASgprC3UtfSE5qEVqug==')
    $agent_hostname = $::fqdn_env ? {
        'prd'   => 'em.gnmedia.net',
        default => 'stg.em.gnmedia.net',
    }

    # All files/directories depend on the agent package and should be owned by mysql
    File {
        ensure  => present,
        owner   => 'mysql',
        group   => 'mysql',
        require => Class['emagent::package'],
    }

    # Create the agent base folders
    file { [ '/opt/mysql', '/opt/mysql/enterprise', "$mysql_agent_base_folder" ]:
        ensure  => directory,
        owner   => 'mysql',
        group   => 'mysql',
        mode    => '0755',
    }

    file { ["${mysql_agent_base_folder}/etc", "${mysql_agent_base_folder}/etc/instances", "${mysql_agent_base_folder}/etc/instances/mysql"]:
        ensure  => directory,
        require => File["$mysql_agent_base_folder"],
        owner   => 'mysql',
        group   => 'mysql',
        mode    => '0755',
    }

    # Make sure log file is owned by mysql
    file{"/${mysql_agent_base_folder}/mysql-monitor-agent.log":
        owner   => 'mysql',
        group   => 'mysql',
        require => File["$mysql_agent_base_folder"],
        mode    => '0644',
    }

    # Create agent ini files
    case $::fqdn {
        default: {
            file{"/${mysql_agent_base_folder}/etc/mysql-monitor-agent.ini":
                mode    => '0600',
                content => template('emagent/mysql-monitor-agent.ini.erb'),
                require => File["$mysql_agent_base_folder"],
            }
        }
    }

    file{"/${mysql_agent_base_folder}/etc/instances/mysql/agent-instance.ini":
        mode    => '0600',
        content => template('emagent/agent-instance.ini.erb'),
        require => File["${mysql_agent_base_folder}/etc/instances"],
    }
}
