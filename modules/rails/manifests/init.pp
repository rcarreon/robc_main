# Class: rails
# This module manages rails
#
# Sample Usage:
# include rails

# This class installs rails via the gem provider
class rails {
    include ruby, rubygems

    package{ 'rails':
        ensure   => '2.3.5',
        provider => gem,
        require  => [Class['ruby'], Class['rubygems']],
    }
}
