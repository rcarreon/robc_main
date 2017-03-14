# Class: rubygems
# This module manages rubygems
#
# Sample Usage:
# include rubygems

# This class manages the installation of the rubygems package
class rubygems {
    package { 'rubygems':
        ensure  => present,
    }
}
