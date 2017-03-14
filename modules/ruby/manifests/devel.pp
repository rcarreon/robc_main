# Class:
# This is the ruby-devel module.
#
# Sample Usage:
# include ruby::devel

class ruby::devel{
    package { 'ruby-devel':
        ensure  => installed,
    }
}
