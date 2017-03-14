define subversion::checkout($repopath, $branch, $workingdir, $reposerver = 'svn.gnmedia.net', $method = 'https', $remoteuser = false, $localuser = 'deploy') {
    Exec {
        path => '/bin:/usr/bin:/usr/local/bin',
        user        => $localuser,
        environment => $localuser ? {
            puppet  => 'HOME=/var/lib/puppet',
            deploy  => 'HOME=/home/deploy',
        },
    }

    $svn_command_checkout = $remoteuser ? {
        false   => "svn checkout --non-interactive ${method}://${reposerver}/${repopath}/${branch} ${workingdir}",
        default => "svn checkout --non-interactive ${method}://${remoteuser}@${reposerver}/${repopath}/${branch} ${workingdir}"
    }

    $svn_command_switch = $remoteuser ? {
        false   => "svn switch --non-interactive ${method}://${reposerver}/${repopath}/${branch} ${workingdir}",
        default => "svn switch --non-interactive ${method}://${remoteuser}@${reposerver}/${repopath}/${branch} ${workingdir}"
    }

    file { $workingdir:
        ensure  => directory,
        owner   => $localuser,
        group   => $localuser,
    }

    exec {
        "${name} initial checkout":
            command => $svn_command_checkout,
            require => File[$workingdir],
            before  => Exec["${name} switch"],
            creates => "${workingdir}/.svn";
        "${name} switch":
            command => $svn_command_switch,
            require => [File[$workingdir],Exec["${name} update"]],
            before  => Exec["${name} revert"];
        "${name} update":
            require => File[$workingdir],
            command =>  "svn update --non-interactive ${workingdir}";
        "${name} revert":
            command => "svn revert -R ${workingdir}",
            onlyif  => "svn status --non-interactive ${workingdir} | egrep '^M|^! |^? ' ";
    }
}