# Setup iscsi on a Linux host. Written to support subversion, but is
# perfectly general. It has built-in support to enabling LVM on top
# of an iscsi target. Does not work during kickstart because the
# iscsid daemon refuses to start (presumably kickstart kernel lacks
# iscsi support).
#
# Example:
#         iscsi::enableportal{"svnrepos":
#            target=>"iqn.1992-08.com.netapp:sn.151696736",
#            portal=>"10.12.220.20:3260",
#         }

class iscsi {
  package{'iscsi-initiator-utils':
      ensure => 'latest',
  }

  file {'/etc/iscsi/initiatorname.iscsi':
      content=>"InitiatorName=iqn.1995-11.net.gnmedia:${fqdn}\n",
      require=>Package['iscsi-initiator-utils'],
      notify =>Service[iscsi],
      owner  => 'root',
      group  => 'root',
      mode   => '0644',
  }

  service {'iscsi':
      ensure  => running,
      enable  => true,
      require => File['/etc/iscsi/initiatorname.iscsi']
  }

  # portal discovery, everything set to "manual" by default
  exec{'discovery-nac1a':
      command=>'/sbin/iscsiadm -m discovery -t st -p if-iscsi-1.gnmedia.net',
      creates=>'/var/lib/iscsi/nodes/iqn.1992-08.com.netapp:sn.c89c3850f0a511e2b8ba123478563412:vs.7/10.11.20.74,3260,1102',
      notify =>Exec[disable_all_portals],
      require=>Service[iscsi],
  }
  exec{'discovery-nac1b':
      command=>'/sbin/iscsiadm -m discovery -t st -p if-iscsi-2.gnmedia.net',
      creates=>'/var/lib/iscsi/nodes/iqn.1992-08.com.netapp:sn.c89c3850f0a511e2b8ba123478563412:vs.7/10.11.20.131,3260,1105',
      notify =>Exec[disable_all_portals],
      require=>Service[iscsi],
  }
  exec{'disable_all_portals':
      command     =>'/sbin/iscsiadm -m node  --op update -n node.startup -v manual',
      refreshonly => true,
  }
}
