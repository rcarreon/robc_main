node 'app2v-deploy.tp.prd.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base
    $project='admin'
    include common::app
    include subversion::client
    include php
    include rubygems::term_ansicolor
    include route53
    include mysqld56::client

    sudo::install_template { 'app2v-deploy': }

    package { ['shmux', 'bind','git','git-svn','vim-enhanced','subversion-perl','ruby-devel','ruby-json','expect',
               'perl-DBD-MySQL','dialog','perl-NetApp', 'perl-Text-ASCIITable','perl-IO-Stty', 'vsftpd']:
       ensure => installed,
    }

    # gem install scaffold
    package {'scaffold':
        ensure   => present,
        provider => gem,
    }

    file { '/usr/local/bin':
        ensure => directory,
        owner  => 'deploy',
        group  => 'sysadmins',
        mode   => '2775',
    }

    common::nfsmount { '/app/shared':
        device  => 'nfsA-netapp1.gnmedia.net:/vol/nac1a_tp_lax_prd_app_shared/deploy-shared',
    }

    # used to keep local checkouts off of root drive
    common::nfsmount { '/app/cache':
        device  => 'nfsA-netapp1.gnmedia.net:/vol/nac1a_tp_lax_prd_app_shared/deploy-cache',
    } ->
    file { '/app/cache/gitdeploypuppet':
        ensure => directory,
        owner  => 'deploy',
        group  => 'deploy',
        mode   =>  '0755',
    }

    common::nfsmount { '/app/log':
        device  => 'nfsB-netapp1.gnmedia.net:/vol/nac1b_tp_lax_prd_app_log/app2v-deploy.tp.prd.lax.gnmedia.net',
    }

    common::nfsmount { '/mnt/caplog':
        device  => 'nfsA-netapp1.gnmedia.net:/vol/nac1a_tp_lax_prd_app_shared/cap-shared/caplog',
    }

    # Domain/SSL Certs management
    cron {'import_domains_to_rt':
        command     => 'cd ~/AT-RT && ./rt-import-domains-for-git.rb > /dev/null',
        user        => 'deploy',
        hour        => 23,
        minute      => 0,
        environment => 'MAILTO=red@evolvemediacorp.com',
    }
    cron {'import_ssl_certs_to_rt':
        command     => 'cd ~/AT-RT && ./rt-import-ssl-certs-for-git.rb > /dev/null',
        user        => 'deploy',
        hour        => 23,
        minute      => 30,
        environment => 'MAILTO=red@evolvemediacorp.com',
    }
    cron {'weekly_domain_expire':
        command     => 'cd ~/AT-RT && ./expire_detector_rt.py -r "configurationmanagement@evolvemediallc.com" > /dev/null',
        user        => 'deploy',
        hour        => 10,
        minute      => 0,
        weekday     => 1,
        environment => 'MAILTO=red@evolvemediacorp.com',
    }
    cron {'monthly_domain_expire':
        command     => 'cd ~/AT-RT && ./expire_detector_rt.py -r "noc@gorillanation.com" > /dev/null',
        user        => 'deploy',
        hour        => 10,
        minute      => 30,
        monthday    => 1,
        environment => 'MAILTO=red@evolvemediacorp.com',
    }

    file { '/home/deploy/on-call/on-call':
        ensure => 'file',
        source => 'puppet:///modules/common/on-call',
        owner  => 'deploy',
        group  => 'deploy',
        mode   => '0755',
    }

    # make sure pingdom is up to date w/inventory
    cron {'rt-pingdom-sync-daily':
        ensure      => 'present',
        command     => 'cd ~/AT-RT && ./rt-pingdom-sync.rb --no-prompt > /dev/null',
        user        => 'deploy',
        hour        => 7,
        minute      => 0,
        environment => 'MAILTO=red@evolvemediacorp.com',
    } 

    # make sure external nagios (mon*.aws*.gnmedia.net) are up to date w/inventory
    cron {'extnagiospush-daily':
        ensure      => 'absent',
        command     => 'cd ~/AT-RT && ./extnagiospush.sh --no-prompt > /dev/null',
        user        => 'deploy',
        hour        => 7,
        minute      => 10,
        environment => 'MAILTO=red@evolvemediacorp.com',
    } 

    # Weekly switch of oncall
    cron {'on-call':
        ensure  => 'present',
        command => '/home/deploy/on-call/on-call > /dev/null',
        user    => 'deploy',
        hour    => '12',
        minute  => '0',
        weekday => '3',
    }
}
