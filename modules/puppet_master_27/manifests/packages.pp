# puppet_master_27::packages
class puppet_master_27::packages {

    if ($::lsbmajdistrelease == "5") {
        include yum::puppetmaster_live
    } else {
        if ($::fqdn_env == "dev") {
            include yum::puppetmaster::live
        }
        if ($::fqdn_env == "stg") {
            include yum::puppetmaster::live
            class { 'yum::puppetmaster::beta': enabled => 0, }
        }
        if ($::fqdn_env == "prd") {
            include yum::puppetmaster::live
        }
    }

    package { 'puppet-server':
        ensure => latest,
    }

}
