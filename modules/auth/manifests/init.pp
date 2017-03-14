# The auth class is used by all systems
class auth {
    include ldap::client

    if ($::lsbmajdistrelease == 6) {
        include sssd
    } else {
        include auth::noldap
    }

# root password is set in kickstart, so this is not needed
#    user {'root':
#        password => $::rootpasswordhash,
#    }

}
