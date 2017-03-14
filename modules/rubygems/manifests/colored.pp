# Class: rubygems::colored
# This is the rubygems::colored in the rubygems module.
#
# Sample Usage:
#   include rubygems::colored
#
class rubygems::colored {
    include rubygems
    package {'colored':
        ensure   => installed,
        provider => gem,
        require  => [Class['rubygems']],
    }
}
