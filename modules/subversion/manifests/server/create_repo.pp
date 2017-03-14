define subversion::server::create_repo () {
    exec { 'create repo':
        command => "svnadmin create '${svndir}/${name}' && chown -R apache:apache '${svndir}/${name}'",
        creates => "${svndir}/${name}",
    }
}