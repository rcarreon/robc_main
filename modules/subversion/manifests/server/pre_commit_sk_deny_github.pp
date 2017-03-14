define subversion::server::pre_commit_sk_deny_github () {
    file {"${svndir}/${name}/hooks/pre-commit":
        owner  => 'deploy',
        group  => 'deploy',
        mode   => '0755',
        source => 'puppet:///modules/subversion/pre-commit-sk-deny-github',
    }
}