# Class: yum::clients
# This class manages our default yum repositories
# (clean all and and the repo we want for base)
#
# Actions:
#   cleanrepo : will delete all yum repo (in /etc/yum.repos.d/) and run clean all
#
# Requires:
#   - Class[yum]
#
class yum::client inherits yum {
    file { '/etc/yum.repos.d':
        ensure  => directory, # so make this a directory
        recurse => true, # enable recursive directory management
        purge   => true, # purge all unmanaged junk
        force   => true, # also purge subdirs and links etc.
        owner   => 'root',
        group   => 'root',
        mode    => '0644', # this mode will also apply to files from the source directory
        source  => 'puppet:///modules/common/empty-directory',
        ignore  => '.svn',
    }

    # Needs to run only if the /etc/yum.repos.d has changed
    exec {'yum_clean_all':
        command     => '/usr/bin/yum clean all',
        refreshonly => true,
    }

    Package {
        require => Exec['yum_clean_all'],
    }

    # Sane default
    Yumrepo {
        enabled  => 1,
        gpgcheck => 0,
        notify   => Exec['yum_clean_all'],
    }


    case $::lsbdistrelease{
    # Old / Legacy repos
    "6.2", "5.6", "6.4": {
        class {'yum::gnrepo_handler': }
    }
    # Repos going forward
    default: {
        class {'yum::yumoter_handler': }
    }
    }
}
