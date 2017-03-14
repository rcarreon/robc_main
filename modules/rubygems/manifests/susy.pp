# Class: rubygems::susy
# This is the rubygems::susy in the rubygems module.
# Sample Usage:
#  include rubygems::susy
#
class rubygems::susy {
    include rubygems
    package {'susy':
        ensure   => installed,
        provider => gem,
        require  => [Class['rubygems']],
    }
}
