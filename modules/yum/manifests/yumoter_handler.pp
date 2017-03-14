class yum::yumoter_handler inherits yum::client {

    include yum::os

    if ($::fqdn_env == "dev") {
        include yum::updates::live
        include yum::updates::beta
        class { 'yum::updates::wildwest': enabled => 0, }
        include yum::epel::live
        include yum::epel::beta
        class { 'yum::epel::wildwest': enabled => 0, }
        include yum::gnrepo::live
        include yum::gnrepo::beta
        class { 'yum::gnrepo::wildwest': enabled => 0, }
    }
    if ($::fqdn_env == "stg") {
        include yum::updates::live
        class { 'yum::updates::beta': enabled => 0, }
        include yum::epel::live
        class { 'yum::epel::beta': enabled => 0, }
        include yum::epel::beta
        include yum::gnrepo::live
        class { 'yum::gnrepo::beta': enabled => 0, }
    }
    if ($::fqdn_env == "prd") {
        include yum::updates::live
        include yum::epel::live
        include yum::gnrepo::live
    }
}
