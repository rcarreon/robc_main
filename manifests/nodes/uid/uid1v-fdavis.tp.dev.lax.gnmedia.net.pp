# this is a dumb comment, you should be ashamed
node 'uid1v-fdavis.tp.dev.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base
    $project="admin"
    include common::app
    include puppet_agent::uid
    include subversion::client

    $secret=decrypt('YeVJHVDFKLMrfkRJ/mWypAdiPI+OXjwYTqgUbFOG/Qg=')
    notify { "decrypted secret: $secret": }

    package { ["vim-enhanced","svn","git","rpmdevtools","yum-utils","bash-completion", "tmux"]:
        ensure => installed
    }
}
