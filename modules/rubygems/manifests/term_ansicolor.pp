# Class: rubygems::term_ansicolor
# term-ansicolor is a ruby lib for terminal color and text formatting
#
# Sample Usage:
#  include rubygems::term_ansicolor
#
class rubygems::term_ansicolor{
    include rubygems
    package {'term-ansicolor':
        ensure   => '1.0.5',
        provider => gem,
        require  => [Class['rubygems']],
    }
}
