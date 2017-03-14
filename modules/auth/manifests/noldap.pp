# auth::noldap class
class auth::noldap {
    include auth::dbcache

    file {"/etc/security/access.conf":
        owner   =>      "root",
        group   =>      "root",
        mode    =>      "0644",
        content =>      template("auth/access.conf.erb"), # top-level templates dir
    }

    exec {"enablepamaccess":
        path    => ['/usr/bin', '/usr/sbin'],
        command => "authconfig --enablemkhomedir --enableshadow --enablemd5 --enablepamaccess  --update 2>&1",
        unless  => "/bin/grep -q pam_access /etc/pam.d/system-auth"
    }
    exec {"disableldap":
        command => "/bin/sed -i /pam_ldap/d /etc/pam.d/system-auth",
        onlyif  => "/bin/grep -v password /etc/pam.d/system-auth | grep -q pam_ldap"
    }
    exec {"enableldappasswd": # This inline sed is careful about placement in the file
        command => "/bin/sed -i '/password.*pam_ldap.so/d; /^password.*pam_deny/i password    sufficient    pam_ldap.so try_first_pass' /etc/pam.d/system-auth",
        unless  => "/bin/grep -B 1 'password.*pam_deny' /etc/pam.d/system-auth | /bin/grep -q pam_ldap"
    }

    gnlib::replace_entire_line_full {"AllowBrokenShadow":
        file        => "/etc/pam.d/system-auth",
        pattern     => "^account.*required.*pam_unix.so.*$",
        replacement => "account     required      pam_unix.so broken_shadow",
    }
    # password    sufficient    pam_ldap.so try_first_pass
}
