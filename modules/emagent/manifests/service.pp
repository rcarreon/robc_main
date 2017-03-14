# Class: emagent::service
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
class emagent::service ($supported) {
    include emagent::config

    $running = $supported ? {
        true => "running",
        false => "stopped",
        default => "stopped",   # Hrm, not sure about this default
        }
    $nagservice = $supported ? {
        true => present,
        false => absent,
        default => absent,
        }

    service {'mysql-monitor-agent':
        ensure      => $running,
        enable      => $supported,
        hasstatus   => true,
        require     => [Class['emagent::config'], Class['emagent::package']],
    }

    nagios::service{'check_emagent':
        ensure      => $nagservice,
        command     => 'check_nrpe!check_emagent',
        use         => 'mysql-services',
        notes_url   => 'http://docs.gnmedia.net/wiki/Nagios-check_emagent',
    }
}
