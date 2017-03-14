class ganglia::data::tpdev {

	$clusters = {
                "gweb"              => ["app1v-gweb.tp.dev.lax.gnmedia.net"],
                "monitoringCluster" => ["app1v-noc.tp.dev.lax.gnmedia.net", "app1v-dashboards.tp.dev.lax.gnmedia.net"],
                "buildingCluster"   => ["app1v-builder.tp.dev.lax.gnmedia.net"],
                "sharedServices"    => ["app1v-ldap.tp.dev.lax.gnmedia.net"],
                "dbaCluster"        => ["sql1v-dashboards.tp.dev.lax.gnmedia.net"],
                "Flume-dev"         => ["app1v-flume-bd.tp.dev.lax.gnmedia.net"],
	}

	case $fqdn {
                /app1v-gweb.tp.dev.lax.gnmedia.net/: {
                        $clusterName="gweb"
                        $collectors=$clusters[$clusterName]
                }
                /app1v-noc.tp.dev.lax.gnmedia.net|app1v-dashboards.tp.dev.lax.gnmedia.net|app1v-vipvisual.tp.dev.lax.gnmedia.net|app1v-gweb.tp.dev.lax.gnmedia.net|app2v-aggr.tp.dev.lax.gnmedia.net/: {
                        $clusterName="monitoringCluster"
                        $collectors=$clusters[$clusterName]
                        #$sampling="300"
                        #$samplingHttp="600"
                        #$samplingMemcache="700"
                }
                /app1v-builder.tp.dev.lax.gnmedia.net|uid1v-gstaples.tp.dev.lax.gnmedia.net/: {
                        $clusterName="buildingCluster"
                        $collectors=$clusters[$clusterName]
                }
                /app1v-ldap.tp.dev.lax.gnmedia.net|app1v-puppet.tp.dev.lax.gnmedia.net|app1v-redmine.tp.dev.lax.gnmedia.net|app1v-rt.tp.dev.lax.gnmedia.net|app1v-extutils.tp.dev.lax.gnmedia.net|app1v-lab.tp.dev.lax.gnmedia.net|app1v-logstash.tp.dev.lax.gnmedia.net/: {
                        $clusterName="sharedServices"
                        $collectors=$clusters[$clusterName]
                }
                /sql1v-dashboards.tp.dev.lax.gnmedia.net|sql1v-puppet.tp.dev.lax.gnmedia.net|sql1v-recovery.tp.dev.lax.gnmedia.net|sql1v-redmine.tp.dev.lax.gnmedia.net|sql1v-rt.tp.dev.lax.gnmedia.net|sql1v-test.tp.dev.lax.gnmedia.net|sql1v-vipvisual.tp.dev.lax.gnmedia.net|sql2v-test.tp.dev.lax.gnmedia.net|sql3v-test.tp.dev.lax.gnmedia.net|sql4v-test.tp.dev.lax.gnmedia.net|sql5v-test.tp.dev.lax.gnmedia.net/: {
                        $clusterName="dbaCluster"
                        $collectors=$clusters[$clusterName]
                }
                /app1v-flume-bd.tp.dev.lax.gnmedia.net/: {
                        $clusterName="Flume-dev"
                        $collectors=$clusters[$clusterName]
                }
	}
}
