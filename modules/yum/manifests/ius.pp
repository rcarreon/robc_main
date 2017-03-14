class yum::ius {
    case $::lsbdistrelease {
        # Exceptions / legacy system
        "6.2", "5.6", "6.4": {
            if ($::fqdn_env == "dev") {
                include yum::ius_legacy::live
                include yum::ius_legacy::beta
                class { 'yum::ius_legacy::wildwest': enabled => 0, }
            }
            if ($::fqdn_env == "stg") {
                include yum::ius_legacy::live
                include yum::ius_legacy::beta
            }
            if ($::fqdn_env == "prd") {
                include yum::ius_legacy::live
            }
        }
        # Repos going forward
        default: {
            if ($::fqdn_env == "dev") {
                include yum::ius::live
                include yum::ius::beta
                class { 'yum::ius::wildwest': enabled => 0, }
            }
            if ($::fqdn_env == "stg") {
                include yum::ius::live
                include yum::ius::beta
            }
            if ($::fqdn_env == "prd") {
                include yum::ius::live
            }
        }
    }
}