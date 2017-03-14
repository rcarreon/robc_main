node 'app1v-svn.tp.prd.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base
        $project="admin"
        include common::app

    include subversion::server

    $svndir = "/ops/repo/svn" # used by subversion::server::* classes

    subversion::server::pre_commit_lint{ "AtomicCMS"         : language => "php"; }
    subversion::server::pre_commit_lint{ "joomlaplatform"    : language => "php"; }
    subversion::server::pre_commit_lint{ "SiteBuilder"       : language => "php"; }
# temporarily disabling hook for this repo until conflict with laravel is resolved
#    subversion::server::pre_commit_lint{ "sales_integration" : language => "php"; }
    subversion::server::pre_commit_lint{ "ugc"               : language => "php"; }
    subversion::server::pre_commit_lint{ "deploytools"       : language => "php"; }
    subversion::server::pre_commit_lint{ "wordpress_pb"      : language => "php"; }

    subversion::server::pre_commit_lint{ "puppet"         : language => "puppet"; }
    subversion::server::diff_email_notify{ "newadops"          : contacts => "AdPlatform@gorillanation.com"; }
    subversion::server::diff_email_notify{ "adops3"            : contacts => "AdPlatform@gorillanation.com"; }
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
    subversion::server::diff_email_notify{ "sales_integration" : contacts => "si-developers@evolvemediallc.com"; }
    subversion::server::diff_email_notify{ "configmgmt"        : contacts => "ConfigurationManagement@evolvemediallc.com"; }
    subversion::server::diff_email_notify{ "wholesomebabyfood.momtastic.com": contacts => "helios@evolvemediallc.com"; }
    subversion::server::diff_email_notify{ "forums.playstationlifestyle.net": contacts => "helios@evolvemediallc.com"; }

    # Deprecated repos
    subversion::server::pre_commit_deprecate {"noc":
      suggestion => "Please use: git@bitbucket.org:evolvemediallc/tp_noc.git or git@bitbucket.org:evolvemediallc/tp_noctools.git instead"
    }
        common::nfsmount { "/ops":
                device => "nfsA-netapp1.gnmedia.net:/vol/nac1i_tp_lax_prd_app_svnrepos",
        }

        common::nfsmount { "/app/log":
                device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_tp_lax_prd_app_log/app1v-svn.tp.prd.lax.gnmedia.net",
        }

        file { "/ops/log": ensure => directory, require => Mount["/ops"] }

###################################################################################################
###### Backup #####################################################################################
###################################################################################################

        common::nfsmount { "/mnt/nfs1_tp_lax_prd_svn_backup":
                device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_tp_lax_prd_svn_backup",
        }

        file {"/usr/local/bin/svn_snapshot.sh":
                owner   => root,
                group   => root,
                mode    => 755,
                content => template('techplatform/svn_snapshot.sh'),
        }

        cron { nightly_snapshot:
                user    => root,
                ensure  => present,
                hour    => 0,
                minute  => 0,
                command => "/usr/local/bin/svn_snapshot.sh"
        }


}
