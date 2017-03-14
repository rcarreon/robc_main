define subversion::server::pre_commit_deprecate($suggestion = "") {
    file {"$svndir/$name/hooks/pre-commit":
        mode    => 755,
        content => template("subversion/pre-commit-deprecate.erb"),
        owner   => "root",
        group   => "root",
    }
}
