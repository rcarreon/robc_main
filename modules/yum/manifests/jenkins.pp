class yum::jenkins {

    if ($::fqdn_env == "dev") {
        include yum::jenkins::live
        include yum::jenkins::beta
        class { 'yum::jenkins::wildwest': enabled => 0, }
    }
    if ($::fqdn_env == "stg") {
        include yum::jenkins::live
        include yum::jenkins::beta
    }
    if ($::fqdn_env == "prd") {
        include yum::jenkins::live
    }

}

