# Class: ruby::mysql
#
# Sample Usage:
# include ruby::mysql

class ruby::mysql{
    package { 'ruby-mysql':
        ensure => installed,
    }
}
