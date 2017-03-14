# Class: rubygems::flog
# command line tool to create a puppet-module skeleton
#
# Sample Usage:
#   include rubygems::flog
#
class rubygems::flog{
    include rubygems
    package {'flog':
        ensure   => '2.5.2',
        provider => gem,
        require  => [Class['rubygems']],
    }
}
