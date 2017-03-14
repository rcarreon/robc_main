class vowpalwabbit::package {
    package { ['boost-program-options', 'vowpal-wabbit']:
        ensure => installed,
    }
}
