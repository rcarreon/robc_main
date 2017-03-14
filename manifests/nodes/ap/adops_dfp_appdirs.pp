# directories needed for ap_dfp_coordinator
class dfp::appdirs {

    # Docroot
    # Capistrano will deploy to these systems
    if ($::fqdn_role != 'uid' and $::fqdn_type != 'build') {
        file { '/app/shared/docroots/dfp_coordinator':
            ensure  => directory,
            owner   => 'deploy',
            group   => 'root',
            mode    => '0755',
        } ->
        file { '/app/shared/docroots/dfp_coordinator/config':
            ensure  => directory,
            owner   => 'root',
            group   => 'root',
            mode    => '0755',
        } ->
        file { '/app/shared/docroots/dfp_coordinator/releases':
            ensure  => directory,
            owner   => 'deploy',
            group   => 'deploy',
            mode    => '0755',
        }
    }

    # /app/shared/tmp is included by adopsV3::appdirs
    file { ['/app/shared/tmp/dfp_performance','/app/shared/tmp/dfp_report_scheduler','/app/shared/tmp/rtb_performance','/tmp/dfp','/app/log/dfp','/app/log/dfp/apache']:
        ensure => directory,
        owner  => 'apache',
        group  => 'apache',
        mode   => '0775',
    }

    include logrotate::ap_dfp

}
