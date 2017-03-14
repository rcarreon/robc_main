# Class: yum
#  - http://docs.gnmedia.net/wiki/YUM
class yum {
    package { 'yum':
        ensure => installed
    }
}
