node 'uid1v-ifimbres.tp.dev.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base
    $project="admin"

    notify {"Does this work?":}

    package { ['emacs-nox', 'tmux']:
        ensure => 'installed',
    }
}
