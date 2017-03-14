define subversion::server::pre_commit_lint ($language = '') {
    file {"${svndir}/${name}/hooks/pre-commit":
        owner  => 'deploy',
        group  => 'deploy',
        mode   => '0755',
        source => "puppet:///modules/subversion/pre-commit-${language}",
    }
}