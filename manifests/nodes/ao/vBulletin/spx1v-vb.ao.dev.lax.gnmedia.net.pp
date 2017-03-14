node 'spx1v-vb.ao.dev.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base
    include sysctl
    include sphinx::multiple_sphinx_install
    $project="sphinx_vb"

    $dev_vb_bab_spx=decrypt('fS1KW+HnWyHLInsGUQ02hg==')
    $dev_vb_hfb_spx=decrypt('OND7kUQ93J7X6kCfeiuHIA==')
    $dev_vb_sdc_spx=decrypt('8/xfDlV9XOH4R8r2/vVsxg==')
    $dev_vb_shh_spx=decrypt('M07BHsuuKrlR/orpMkIhbA==')
    $dev_vb_tfs_spx=decrypt('rHMDV8RRPiw9huvnL6lmLg==')
    $dev_vb_wz_spx=decrypt('s/NKrKCyXPt7LHDmRby0mA==')

    sphinx::multiple_sphinx_config 
        {"shh": sql_host => 'sql1v-56-vb-shh.ao.dev.lax.gnmedia.net', 
        sql_user         => 'sphinx', 
        sql_pass         => "$dev_vb_shh_spx", 
        sql_db           => 'forums_shh', 
        port             => '3312'
        }

    sphinx::multiple_sphinx_config 
        {"sdn": sql_host => 'sql1v-56-vb-sdc.ao.dev.lax.gnmedia.net', 
        sql_user         => 'sphinx', 
        sql_pass         => "$dev_vb_sdc_spx", 
        sql_db           => 'vbulletin', 
        port             => '3313'
        }

    sphinx::multiple_sphinx_config 
        {"hfb": sql_host => 'sql1v-56-vb-hfb.ao.dev.lax.gnmedia.net', 
        sql_user         => 'sphinx', 
        sql_pass         => "$dev_vb_hfb_spx", 
        sql_db           => 'hfboards', 
        port             => '3314'
        }

    sphinx::multiple_sphinx_config 
        {"bab": sql_host => 'sql1v-56-vb-bab.ao.dev.lax.gnmedia.net', 
        sql_user         => 'sphinx', 
        sql_pass         => "$dev_vb_bab_spx", 
        sql_db           => 'bab_vbulletin', 
        port             => '3315'}

    sphinx::multiple_sphinx_config 
        {"tfs": sql_host => 'sql1v-56-vb-tfs.ao.dev.lax.gnmedia.net', 
        sql_user         => 'sphinx', 
        sql_pass         => "$dev_vb_tfs_spx", 
        sql_db           => 'tfs_forums', 
        sql_prefix       => 'forums_', 
        port             => '3316'}

    sphinx::multiple_sphinx_config 
        {"wzf": sql_host => 'sql1v-56-vb-wz.ao.dev.lax.gnmedia.net', 
        sql_user         => 'sphinx', 
        sql_pass         => "$dev_vb_wz_spx", 
        sql_db           => 'wzforum', 
        port             => '3317'}

    $script_path="sphinx_vb"
    include cronjob
    cronjob::do_cron_dot_d_cron_file {"sphinx.cron": }
    cronjob::do_cron_dot_d_script    {"sphinx-delta.sh": }
    cronjob::do_cron_dot_d_script    {"sphinx-full-index.sh":}

    common::nfsmount { "/sphinx":
        device => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ao_lax_dev_spx_shared/spx1v-vb.ao.dev.lax.gnmedia.net",
    }

}
