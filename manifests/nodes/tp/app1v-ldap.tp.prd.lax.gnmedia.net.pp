node 'app1v-ldap.tp.prd.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base
        $project="admin"

	include ldap::server
	include ldap::server::cron

        package {"nsscache": ensure=>present }

        $ldapbindpassword=decrypt("60NIHqm232FhBPtSiKudDA==")

        file {"/etc/nsscache.conf":
            ensure => file,
            owner => "root",
            group => "root",
            mode => 600,
            content => template('ldap/nsscache.conf.erb'),
        }

        #common::nfsmount {
        #    "/ldap_backup": device => "nfsB-netapp1.gnmedia.net:/vol/nac1b_tp_lax_prd_app_archive"
        #}

}
