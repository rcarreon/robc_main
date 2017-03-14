define subversion::server::post_commit ($contacts = "") {
    file {"$svndir/$name/hooks/post-commit":
        mode    => 755,    
        content => template("subversion/$name/post-commit.erb"),
        owner   => "root",
        group   => "root",
    }
}