class yum::postgres {

    if ($::fqdn_env == "dev") {
        include yum::postgres::live
        include yum::postgres::beta
        class { 'yum::postgres::wildwest': enabled => 0, }
    }
    if ($::fqdn_env == "stg") {
        include yum::postgres::live
        include yum::postgres::beta
    }
    if ($::fqdn_env == "prd") {
        include yum::postgres::live
    }

}
