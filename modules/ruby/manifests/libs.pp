# Class: ruby::libs
#
# Sample Usage:
# include ruby::libs

class ruby::libs{
    package { 'ruby-libs':
        ensure  => installed,
    }
}
