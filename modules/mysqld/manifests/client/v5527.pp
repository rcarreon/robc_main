# mysqld client class v5527
class mysqld::client::v5527 {
    include yum::mysql5527
    if ($::lsbmajdistrelease == 5) {
        package { [ 'MySQL-client-advanced', 'MySQL-shared-compat-advanced' ]:
            ensure  => '5.5.27-1.rhel5',
            require => Class['yum::mysql5527'],
        }
    }
    if ($::lsbmajdistrelease == 6) {
        package { [ 'MySQL-client-advanced', 'MySQL-shared-compat-advanced' ]:
            ensure  => '5.5.27-1.el6',
            require => Class['yum::mysql5527'],
        }
    }
}
