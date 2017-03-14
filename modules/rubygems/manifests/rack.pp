# Class: rubygems::rack
# This is the rubygems::rack in the rubygems module.
#
# Sample Usage:
#   include rubygems::rack
#
class rubygems::rack {
    include rubygems
    package {'rack':
        ensure   => '1.0.1',
        provider => gem,
        require  => [Class['rubygems']],
    }
}
