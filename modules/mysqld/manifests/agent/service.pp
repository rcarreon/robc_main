# Class: mysqld::agent::service
#
# Puppet will start the mysql-monitor-agent service
# Use monit to manage the mysql-monitor-agent service
#
# Parameters:
#
# Actions:
# Start the mysql-monitor-agent service
# Configure monit
#
# Requires:
# - monit::mysql-monitor-agent
#
# Sample Usage:
#
class mysqld::agent::service($startagent) {
    include mysqld::agent::config

    $enable_agent_service = $startagent ? {
            'yes'   => true,
            'no'    => false,
            default => $::at_status ? { 'development' => false, default => true },
        }
    $ensure_agent_nagios_check = $startagent ? {
            'yes'   => present,
            'no'    => absent,
            default => $::at_status ? { 'development' => absent, default => present },
        }

    service {'mysql-monitor-agent':
        enable    => $enable_agent_service,
        hasstatus => true,
        require   => [Class['mysqld::agent::config'], Class['mysqld::agent::package']],
    }

    nagios::service{'check_emagent':
        ensure    => $ensure_agent_nagios_check,
        command   => 'check_nrpe!check_emagent',
        use       => 'mysql-services',
        notes_url => 'http://docs.gnmedia.net/wiki/Nagios-check_emagent',
    }
}
