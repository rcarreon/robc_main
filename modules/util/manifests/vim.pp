# A version of the VIM editor which includes recent enhancements
#
class util::vim {

        package { "vim-enhanced":
                ensure => installed,
        }

}
