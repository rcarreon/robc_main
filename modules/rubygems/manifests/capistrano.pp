# Class: rubygems::capistrano
# This is the rubygems::capistrano in the rubygems module.
#
# Sample Usage:
#   include rubygems::capistrano
#
class rubygems::capistrano {
    include rubygems

    # Capistrano
    package{'highline':
        ensure   => '1.6.2',
        provider => gem,
        require  => [Class['rubygems']],
    }->
    package {'capistrano':
        ensure   => '2.12.0',
        provider => gem,
        require  => [Class['rubygems']],
    }
    package {'capistrano-ext':
        ensure   => 'present',
        provider => gem,
        require  => [Class['rubygems']],
    }
    package {'railsless-deploy':
        ensure   => 'present',
        provider => gem,
        require  => [Class['rubygems']],
    }

    # Custom GN Rubygems
    package { 'rubygem-json':
        ensure   => present,
    } ->
    package { 'gnm-jenkins_cap':
        ensure   => present,
        provider => gem,
        require  => [Class['rubygems']],
    }

    package {'gnm-caplock':
        ensure   => 'present',
        provider => gem,
        require  => [Class['rubygems']],
    }

    package {'gnm-cap_permission':
        ensure   => '1.0.3',
        provider => gem,
        require  => [Class['rubygems']],
    }
}
