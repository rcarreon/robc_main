# Class: rubygems::scaffold
# command line tool to create a puppet-module skeleton
# Sample Usage:
#   include rubygems::scaffold
#
class rubygems::scaffold{
    include rubygems
    package {'scaffold':
        ensure   => '0.0.3',
        provider => gem,
        require  => [Class['rubygems']],
    }
}
