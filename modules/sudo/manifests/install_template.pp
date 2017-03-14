# install a template to /etc/sudoers.d
define sudo::install_template ( ) {
    file { "/etc/sudoers.d/$name":
        owner   => 'root',
        group   => 'root',
        mode    => '0440',
        content => template("sudo/sudoers.d/$name"),
        require => Package['sudo'],
    }
}
