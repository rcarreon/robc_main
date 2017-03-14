# Class: rubygems::rake
# This is the rubygems::rake in the rubygems module.
#
# Sample Usage:
#  include rubygems::rake
#
class rubygems::rake {
    include rubygems
    package {'rake':
        ensure   => '0.8.7',
        provider => gem,
        require  => [Class['rubygems']],
    }
}
