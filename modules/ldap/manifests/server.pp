class ldap::server inherits ldap::client {
    # 389 packages come from epel
    $ldapkgs = [ '389-ds', '389-ds-base', '389-ds-console', '389-console', 'openldap-clients', 
                 'xorg-x11-xauth', 'ldapvi', 'perl-LDAP', 'python-ldap', 'vim-enhanced' ]

    package { $ldapkgs: 
        ensure => installed,
    }

    service { 'dirsrv':
       enable => true,
    }

    service { 'dirsrv-admin':
       enable => true,
    }
}
