# enable the one portal you want
define iscsi::enableportal($target = 'target',$portal = 'portal') {
    exec {"enableportal-${portal}":
        command     =>"/sbin/iscsiadm -m node -T ${target} -p ${portal} --op update -n node.startup -v automatic",
        subscribe   =>Exec[disable_all_portals],
        refreshonly => true,
    }
    exec {"loginportal-${portal}":
        command=>"/sbin/iscsiadm -m node -T ${target} -p ${portal} --login",
        unless =>"/sbin/iscsiadm -m session | fgrep '${portal},' | fgrep -q ' ${target}'",
        require=>Exec["enableportal-${portal}"],
    }
}
