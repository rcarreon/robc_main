# class puppet_agent::packages
class puppet_agent::packages {

    if ($::lsbmajdistrelease == "5") {
        include yum::puppet_live
    } else {
        if ($::fqdn_env == "dev") {
            include yum::puppet::live
            include yum::puppet::beta
        }
        if ($::fqdn_env == "stg") {
            include yum::puppet::live
            class { 'yum::puppet::beta': enabled => 0, }
        }
        if ($::fqdn_env == "prd") {
            include yum::puppet::live
        }
    }

    package { 'puppet':
        ensure  => latest,
    }

}
