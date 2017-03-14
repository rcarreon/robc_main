# puppet_master_3::packages
class puppet_master_3::packages {

    if ($::fqdn_env == 'dev') {
        include yum::puppetmaster::live
        include yum::puppetmaster::beta
    }
    if ($::fqdn_env == 'stg') {
        include yum::puppetmaster::live
        class { 'yum::puppetmaster::beta': enabled => 0, }
    }
    if ($::fqdn_env == 'prd') {
        # temp change for installing puppet 3 prd boxen
        # FIXME once they are setup revert to live
        include yum::puppetmaster::beta
        include yum::puppetdependencies::beta
    }

    package { 'puppet-server':
        ensure => latest,
    }

}
