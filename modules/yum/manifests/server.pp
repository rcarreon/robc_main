# Class: yum::server
# This class makes sure we have all needed package to operate as yum server
class yum::server inherits yum {
    package { 'createrepo':
        ensure => installed,
    }
}
