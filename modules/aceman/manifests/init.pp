# provides the aceman script
# and this is a test comment
class aceman {
    include perl::xml_simple
    file { '/usr/local/bin/aceman':
        source => 'puppet:///modules/aceman/aceman',
        owner  => 'root',
        group  => 'root',
        mode   => '0755',
    }

    $secret_password = decrypt('3iiIa0FDIXNnfdCV9CRloA==')

    file { '/etc/acemanrc':
        content => "username=admin\npassword=${secret_password}\n",
        owner   => 'root',
        group   => 'sysadmins',
        mode    => '0660',
    }
}
