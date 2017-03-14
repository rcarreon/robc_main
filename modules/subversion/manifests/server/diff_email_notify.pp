define subversion::server::diff_email_notify ($contacts = '') {
    file {"${svndir}/${name}/hooks/post-commit":
        mode    => '0755',
        owner   => 'root',
        group   => 'root',
        content => template('subversion/post-commit.erb'),
    }
}