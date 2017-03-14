# Class: rubygems::compass
# This is the rubygems::compass in the rubygems module.
#
# Sample Usage:
#   include rubygems::compass
#
class rubygems::compass {
    include rubygems
    package {'compass':
        ensure   => installed,
        provider => gem,
        require  => [Class['rubygems']],
    }
}
