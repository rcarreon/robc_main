class rancid {

# You must manually run this as root:
# svn co https://svn.gnmedia.net/sysadmins/trunk/network/configs/rancid /app/shared/var/rancid/configs
# because a human operator must press "p" to permanently accept the RSA
# fingerprint of our Subversion server.  It may also be necessary to
# delete /app/shared/rancid/tmp/.rancid.run.lock

include net_snmp
include sendmail::rancid
include subversion::client
include rsyslog::locallogs
include rsyslog::remotereception
include cronjob

$rancid_prefix = "/app/shared"

# deprecated dynamic scope, define this in the node manifest
#$script_path="rancid_logrotate"
cronjob::do_cron_dot_d_cron_file {"logrotate.cron": }
cronjob::do_cron_dot_d_script {"logrotate_daily.sh":}

file { "/etc/hosts":
        owner   => root,
        group   => root,
        mode    => 644,
	source  => "puppet:///modules/rancid/rancid.hosts",
}

package { ["expect-devel", "gcc"]:
	ensure => installed,
}

group { 'rancid':
	ensure => present,
	gid    => '5051'
}

user { 'rancid':
	comment  => 'Rancid Service Account',
	password => '!!',
	ensure   => present,
	uid	 => '5050',
	shell    => '/bin/sh',
	gid	 => '5051',
	home     => '/app/shared/rancid/home',
	require  => Group['rancid'],
}

  file { $rancid_prefix:
        ensure       => directory,
        recurse      => true,
        recurselimit => 1,
        owner        => 'rancid',
        group        => 'rancid',
        mode         => 0755,
        ignore       => '.snapshot',
  }

file { "${rancid_prefix}/rancid":
	ensure  => directory,
	owner   => "rancid",
	group   => "rancid",
	require => File[$rancid_prefix],
}

file { "${rancid_prefix}/rancid/home":
	ensure  => directory,
	owner   => "rancid",
	group   => "rancid",
	require => File[$rancid_prefix],
}

file { "${rancid_prefix}/rancid/tmp":
	ensure  => directory,
	owner   => "rancid",
	group   => "rancid",
	require => File[$rancid_prefix],
}

# Point Rancid backup file monit check to conf file mounted over NFS:

file { "/etc/monit.d/rancid.conf":
	ensure => link,
	target => "/app/shared/rancid/home/monit_check.txt",
}

cron {"Refesh_config":
	command => "${rancid_prefix}/bin/rancid-run",
	user    => "rancid",
	minute  => '*/5',
}

cron {"Fix_Fingerprints":
	command => "/app/shared/rancid/home/update_fingerprints.sh",
	user    => "rancid",
	minute  => "59",
	hour    => "17",
}

# clean up the logs
tidy {"${rancid_prefix}/var/logs":
	age => "7d",
}

}
