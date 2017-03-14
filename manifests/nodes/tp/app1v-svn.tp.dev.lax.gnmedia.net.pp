node 'app1v-svn.tp.dev.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base
        $project="admin"
        include common::app

    include subversion::server

    $svndir = "/ops/repo/svn" # used by subversion::server::* classes

    subversion::server::pre_commit_lint{ "AtomicCMS"         : language => "php5.1"; }
    subversion::server::pre_commit_lint{ "joomlaplatform"    : language => "php"; }
    subversion::server::pre_commit_lint{ "SiteBuilder"       : language => "php"; }
    subversion::server::pre_commit_lint{ "sales_integration" : language => "php"; }
    subversion::server::pre_commit_lint{ "ugc"               : language => "php"; }
    subversion::server::pre_commit_lint{ "deploytools"       : language => "php"; }
    subversion::server::pre_commit_lint{ "wordpress_pb"      : language => "php"; }

    subversion::server::pre_commit_lint{ "puppet"         : language => "puppet"; }
    subversion::server::diff_email_notify{ "newadops"          : contacts => "AdPlatform@gorillanation.com"; }
    subversion::server::diff_email_notify{ "dartapi"           : contacts => "AdPlatform@gorillanation.com"; }
    subversion::server::diff_email_notify{ "reports"           : contacts => "AdPlatform@gorillanation.com"; }
    subversion::server::diff_email_notify{ "sysadmins"         : contacts => "puppetmasters@gorillanation.com"; }
    subversion::server::diff_email_notify{ "joomlaplatform"    : contacts => "Pebblebed@atomiconline.com"; } 
    subversion::server::diff_email_notify{ "sandbox"           : contacts => "ConfigurationManagement@gorillanation.com"; }
    subversion::server::diff_email_notify{ "tewn"              : contacts => "techteamcrowdignite@evolvemediallc.com"; }
    subversion::server::diff_email_notify{ "crowdignite-marcom" : contacts => "techteamcrowdignite@evolvemediallc.com"; }
    subversion::server::diff_email_notify{ "crowdignite-widget" : contacts => "techteamcrowdignite@evolvemediallc.com"; }
    subversion::server::diff_email_notify{ "deploytools"       : contacts => "ConfigurationManagement@gorillanation.com"; }
    subversion::server::diff_email_notify{ "domains_mngt"      : contacts => "ConfigurationManagement@gorillanation.com"; }
    subversion::server::diff_email_notify{ "sales_integration" : contacts => "si-developers@evolvemediacorp.com"; }
    subversion::server::diff_email_notify{ "configmgmt"        : contacts => "ConfigurationManagement@evolvemediacorp.com"; }


    common::nfsmount { "/ops":
       device => "nfsA-netapp1.gnmedia.net:/vol/nac1a_tp_lax_dev_app_svnrepo"
    }


}
