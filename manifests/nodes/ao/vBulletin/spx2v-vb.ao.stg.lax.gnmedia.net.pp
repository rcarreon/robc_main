node 'spx2v-vb.ao.stg.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base
    include sysctl
    include security
    include sphinx::multiple_sphinx_install
    $project="sphinx_vb"

    $stg_vb_2_bab_spx=decrypt('vafWaej1hncjLueAt5+//A==')
    $stg_vb_2_hfb_spx=decrypt('E4nCXLeOWP5ntYqEUf361A==')
    $stg_vb_2_sdc_spx=decrypt('6hBuvAtHdhsazUhXUUM5kQ==')
    $stg_vb_2_shh_spx=decrypt('OxKWN3fDN5cqiTdEg8AahA==')
    $stg_vb_2_tfs_spx=decrypt('O8baYf+MVEG+8f0e2DzDtA==')
    $stg_vb_2_wz_spx=decrypt('UqXdRKZlR0Xe6yRXC9YzIw==')

    sphinx::multiple_sphinx_config 
        {"shh": sql_host => 'vip-sqlrw-vb-shh.ao.stg.lax.gnmedia.net', 
        sql_user         => 'sphinx', 
        sql_pass         => "$stg_vb_2_shh_spx", 
        sql_db           => 'forums_shh', 
        port             => '3312'
        }

    sphinx::multiple_sphinx_config 
        {"sdn": sql_host => 'vip-sqlrw-vb-sdc.ao.stg.lax.gnmedia.net', 
        sql_user         => 'sphinx', 
        sql_pass         => "$stg_vb_2_sdc_spx", 
        sql_db           => 'vbulletin', 
        port             => '3313'
        }

    sphinx::multiple_sphinx_config 
        {"hfb": sql_host => 'vip-sqlrw-vb-hfb.ao.stg.lax.gnmedia.net', 
        sql_user         => 'sphinx', 
        sql_pass         => "$stg_vb_2_hfb_spx", 
        sql_db           => 'hfboards', 
        port             => '3314'
        }

    sphinx::multiple_sphinx_config 
        {"bab": sql_host => 'vip-sqlrw-vb-bab.ao.stg.lax.gnmedia.net', 
        sql_user         => 'sphinx', 
        sql_pass         => "$stg_vb_2_bab_spx", 
        sql_db           => 'bab_vbulletin', 
        port             => '3315'}

    sphinx::multiple_sphinx_config 
        {"tfs": sql_host => 'vip-sqlrw-vb-tfs.ao.stg.lax.gnmedia.net', 
        sql_user         => 'sphinx', 
        sql_pass         => "$stg_vb_2_tfs_spx", 
        sql_db           => 'tfs_forums', 
        sql_prefix       => 'forums_', 
        port             => '3316'}

    sphinx::multiple_sphinx_config 
        {"wzf": sql_host => 'vip-sqlrw-vb-wz.ao.stg.lax.gnmedia.net', 
        sql_user         => 'sphinx', 
        sql_pass         => "$stg_vb_2_wz_spx", 
        sql_db           => 'wzforum', 
        port             => '3317'}

    $script_path="sphinx_vb"
    include cronjob
    cronjob::do_cron_dot_d_cron_file {"sphinx2.cron": }
    cronjob::do_cron_dot_d_script    {"sphinx-delta.sh": }
    cronjob::do_cron_dot_d_script    {"sphinx-full-index.sh":}

    common::nfsmount { "/sphinx":
        device => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ao_lax_stg_spx_shared/spx2v-vb.ao.stg.lax.gnmedia.net",
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
