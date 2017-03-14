# Class: rubygems::livereload
# This is the rubygems::livereload in the rubygems module.
#
# Sample Usage:
#   include rubygems::livereload
#
class rubygems::livereload {
    include rubygems
    package {'livereload':
        ensure   => installed,
        provider => gem,
        require  => [Class['rubygems']],
    }
}
