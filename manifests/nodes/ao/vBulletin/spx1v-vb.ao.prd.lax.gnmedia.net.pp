node 'spx1v-vb.ao.prd.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base
    include sysctl
    include security
    include sphinx::multiple_sphinx_install
    $project="sphinx_vb"

    $prd_vb_bab_spx=decrypt('vafWaej1hncjLueAt5+//A==')
    $prd_vb_hfb_spx=decrypt('E4nCXLeOWP5ntYqEUf361A==')
    $prd_vb_sdc_spx=decrypt('6hBuvAtHdhsazUhXUUM5kQ==')
    $prd_vb_shh_spx=decrypt('z4+CT7ExY11Wf8AHaxR/SA==')
    $prd_vb_tfs_spx=decrypt('7qvigF+OobiVl9kYitFTPQ==')
    $prd_vb_wz_spx=decrypt('SNHWdXt2NBJztV6SlovZvA==')

    sphinx::multiple_sphinx_config 
        {"shh": sql_host => 'vip-sqlro-vb-shh.ao.prd.lax.gnmedia.net', 
        sql_user         => 'sphinx', 
        sql_pass         => "$prd_vb_shh_spx", 
        sql_db           => 'forums_shh', 
        port             => '3312'
        }

    sphinx::multiple_sphinx_config 
        {"sdn": sql_host => 'vip-sqlrw-vb-sdc.ao.prd.lax.gnmedia.net', 
        sql_user         => 'sphinx', 
        sql_pass         => "$prd_vb_sdc_spx", 
        sql_db           => 'vbulletin', 
        port             => '3313'
        }

    sphinx::multiple_sphinx_config 
        {"hfb": sql_host => 'vip-sqlrw-hfb.ao.prd.lax.gnmedia.net', 
        sql_user         => 'sphinx', 
        sql_pass         => "$prd_vb_hfb_spx", 
        sql_db           => 'hfboards', 
        port             => '3314'
        }

    sphinx::multiple_sphinx_config 
        {"bab": sql_host => 'vip-sqlro-bab.ao.prd.lax.gnmedia.net', 
        sql_user         => 'sphinx', 
        sql_pass         => "$prd_vb_bab_spx", 
        sql_db           => 'bab_vbulletin', 
        port             => '3315'}

    sphinx::multiple_sphinx_config 
        {"tfs": sql_host => 'vip-sqlro-vb-tfs.ao.prd.lax.gnmedia.net', 
        sql_user         => 'sphinx', 
        sql_pass         => "$prd_vb_tfs_spx", 
        sql_db           => 'tfs_forums', 
        sql_prefix       => 'forums_', 
        port             => '3316'}

    sphinx::multiple_sphinx_config 
        {"wzf": sql_host => 'vip-sqlro-vb-wz.ao.prd.lax.gnmedia.net', 
        sql_user         => 'sphinx', 
        sql_pass         => "$prd_vb_wz_spx", 
        sql_db           => 'wzforum', 
        port             => '3317'}

    $script_path="sphinx_vb"
    include cronjob
    cronjob::do_cron_dot_d_cron_file {"sphinx.cron": }
    cronjob::do_cron_dot_d_script    {"sphinx-delta.sh": }
    cronjob::do_cron_dot_d_script    {"sphinx-full-index.sh":}

    common::nfsmount { "/sphinx":
        device => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ao_lax_prd_spx_shared/spx1v-vb.ao.prd.lax.gnmedia.net",
    }


    group { 'sphinx':
        ensure   => 'present',
        gid      => '113',
    }

    user { 'sphinx':
        ensure   => 'present',
        home     => '/var/lib/sphinx',
        shell    => '/sbin/nologin',
        comment  => 'Sphinx server',
        password => '!!',
        uid      => '113',
        gid      => 'sphinx',
        require  => Group["sphinx"],
    }

}
