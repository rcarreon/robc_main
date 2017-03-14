node 'app1v-wbf.ao.prd.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base
    $project="atomiconline"

############################################################################
##### Packages to be installed on app servers ##############################
############################################################################

    include common::app
    include httpd
    include subversion::client
    class {'php::install': version => '5.3',}


############################################################################
##### Set up vhost #########################################################
############################################################################

    httpd::virtual_host { 'wholesomebabyfood.momtastic.com': monitor => false,}


############################################################################
##### Set up Mounts ########################################################
############################################################################

    common::nfsmount { "/app/shared":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ao_lax_prd_app_shared/wbf-shared",
    }

    common::nfsmount { "/app/log":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ao_lax_prd_app_log/app1v-wbf.ao.prd.lax.gnmedia.net",
    }
}
