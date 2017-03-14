class git::client {
    # this is the git client class. keep it classy.
    
    package { ["git", "git-svn"]:
        ensure => installed,
    }

}
