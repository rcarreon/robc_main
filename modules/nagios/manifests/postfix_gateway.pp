# class nagios postfix gateway
class nagios::postfix_gateway {
    nagios::service {'trend_mail_received':
        command   => "check_ganglia_trending!'http://gweb.gnmedia.net/graph.cgi?r=day&h=${::fqdn}&v=9&m=mail_received&jr=&js=&vl=messages&json=1'!fixed!points!25!75!low",
        notes_url => 'http://docs.gnmedia.net/wiki/Nagios_check_mail_received',
        notification_period => 'workhours',
    }
    nagios::service {'trend_mail_bounced':
        command   => "check_ganglia_trending!'http://gweb.gnmedia.net/graph.cgi?r=day&h=${::fqdn}&v=3&m=mail_bounced&jr=&js=&vl=messages&json=1'!fixed!points!10!25!low",
        notes_url => 'http://docs.gnmedia.net/wiki/Nagios_check_mail_bounced',
        notification_period => 'workhours',
    }
    nagios::service {'trend_mail_rejected':
        command   => "check_ganglia_trending!'http://gweb.gnmedia.net/graph.cgi?r=day&h=${::fqdn}&v=0&m=mail_rejected&jr=&js=&vl=messages&json=1'!fixed!points!10!25!low",
        notes_url => 'http://docs.gnmedia.net/wiki/Nagios_check_mail_rejected',
        notification_period => 'workhours',
    }
    nagios::service {'trend_mail_spam':
        command   => "check_ganglia_trending!'http://gweb.gnmedia.net/graph.cgi?r=day&h=${::fqdn}&v=0&m=mail_spam&jr=&js=&vl=messages&json=1'!fixed!points!10!25!low",
        notes_url => 'http://docs.gnmedia.net/wiki/Nagios_check_mail_spam',
    }
}
