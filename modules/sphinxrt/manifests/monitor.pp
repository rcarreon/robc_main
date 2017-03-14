
class sphinxrt::monitor {
    nagios::service {"sphinxrt_mysql41":
        command => "check_sphinxrt_mysql41",
        notes_url => "http://docs.gnmedia.net/wiki/Nagios-sphinxrt",
    }

    nagios::service {"sphinxrt":
        command => "check_sphinxrt",
        notes_url => "http://docs.gnmedia.net/wiki/Nagios-sphinxrt",
    }

    include collectd::plugins::sphinxrt
}
