class nagios::ci_monitor {

    nagios::service {'ci_mon_all_widget_ctr':
        command   => 'check_ci_mon!All!widget_ctr!1.05!.95',
        notes_url => 'http://docs.gnmedia.net/wiki/nagios_ci_monitor',
        use => 'crowdignite-service',
    }
    nagios::service {'ci_mon_gr_widget_ctr':
        command   => 'check_ci_mon!GR!widget_ctr!1.5!1.25',
        notes_url => 'http://docs.gnmedia.net/wiki/nagios_ci_monitor',
        use => 'crowdignite-service',
    }
    nagios::service {'ci_mon_cr_widget_ctr':
        command   => 'check_ci_mon!CR!widget_ctr!1.05!.9',
        notes_url => 'http://docs.gnmedia.net/wiki/nagios_ci_monitor',
        use => 'crowdignite-service',
    }
    nagios::service {'ci_mon_mt_widget_ctr':
        command   => 'check_ci_mon!MT!widget_ctr!.8!.7',
        notes_url => 'http://docs.gnmedia.net/wiki/nagios_ci_monitor',
        use => 'crowdignite-service',
    }
    nagios::service {'ci_mon_tfs_widget_ctr':
        command   => 'check_ci_mon!tFS!widget_ctr!1!.85',
        notes_url => 'http://docs.gnmedia.net/wiki/nagios_ci_monitor',
        use => 'crowdignite-service',
    }
    nagios::service {'ci_mon_th_widget_ctr':
        command   => 'check_ci_mon!TH!widget_ctr!.7!.6',
        notes_url => 'http://docs.gnmedia.net/wiki/nagios_ci_monitor',
        use => 'crowdignite-service',
    }
    nagios::service {'ci_mon_news_widget_ctr':
        command   => 'check_ci_mon!News!widget_ctr!.43!.35',
        notes_url => 'http://docs.gnmedia.net/wiki/nagios_ci_monitor',
        use => 'crowdignite-service',
    }


    nagios::service {'ci_mon_all_return_rate':
        command   => 'check_ci_mon!All!return_rate!185!180',
        notes_url => 'http://docs.gnmedia.net/wiki/nagios_ci_monitor',
        use => 'crowdignite-service',
    }
    nagios::service {'ci_mon_ci_return_rate':
        command   => 'check_ci_mon!CI!return_rate!160!140',
        notes_url => 'http://docs.gnmedia.net/wiki/nagios_ci_monitor',
        use => 'crowdignite-service',
    }
    nagios::service {'ci_mon_gr_return_rate':
        command   => 'check_ci_mon!GR!return_rate!200!180',
        notes_url => 'http://docs.gnmedia.net/wiki/nagios_ci_monitor',
        use => 'crowdignite-service',
    }
    nagios::service {'ci_mon_cr_return_rate':
        command   => 'check_ci_mon!CR!return_rate!180!170',
        notes_url => 'http://docs.gnmedia.net/wiki/nagios_ci_monitor',
        use => 'crowdignite-service',
    }
    nagios::service {'ci_mon_mt_return_rate':
        command   => 'check_ci_mon!MT!return_rate!165!155',
        notes_url => 'http://docs.gnmedia.net/wiki/nagios_ci_monitor',
        use => 'crowdignite-service',
    }
    nagios::service {'ci_mon_tfs_return_rate':
        command   => 'check_ci_mon!tFS!return_rate!163!150',
        notes_url => 'http://docs.gnmedia.net/wiki/nagios_ci_monitor',
        use => 'crowdignite-service',
    }
    nagios::service {'ci_mon_th_return_rate':
        command   => 'check_ci_mon!TH!return_rate!180!170',
        notes_url => 'http://docs.gnmedia.net/wiki/nagios_ci_monitor',
        use => 'crowdignite-service',
    }
    nagios::service {'ci_mon_news_return_rate':
        command   => 'check_ci_mon!News!return_rate!125!115',
        notes_url => 'http://docs.gnmedia.net/wiki/nagios_ci_monitor',
        use => 'crowdignite-service',
    }

}
