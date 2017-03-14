# rundaemon check
class nagios::rundaemon {
    nagios::service {'nagios_config':
        command   => 'check_nrpe!check_nagios_config',
        notes_url => 'http://docs.gnmedia.net/wiki/Nagios-nagios_config',
    }
}
