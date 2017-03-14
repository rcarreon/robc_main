class ganglia::data::tp {
        include ganglia::data::tpdev

	$clusters = {
                "prdSharedServices" => ["app1v-im.tp.prd.lax.gnmedia.net", "app1v-extutils.tp.prd.lax.gnmedia.net"],
                "prdMonitoring"     => ["app1v-graphite.tp.prd.lax.gnmedia.net", "app1v-cacti.tp.prd.lax.gnmedia.net"],
                "prdCfgMgmt"        => ["app2v-cap.tp.prd.lax.gnmedia.net", "app2v-deploy.tp.prd.lax.gnmedia.net"],
                "prdCarbon"         => ["app1v-carbon.tp.prd.lax.gnmedia.net", "app2v-carbon.tp.prd.lax.gnmedia.net"],
                "prdJenkins"        => ["app1v-cijoe.tp.prd.lax.gnmedia.net", "app4v-ci.tp.prd.lax.gnmedia.net"],
                "prdDba"            => ["sql1v-dashboards.tp.prd.lax.gnmedia.net"],
                "prdDns"            => ["app1v-dnsint.tp.prd.lax.gnmedia.net", "app1v-dns.tp.prd.lax.gnmedia.net"],
                "prdAtrt"           => ["app1v-inv.tp.prd.lax.gnmedia.net", "app1v-rt.tp.prd.lax.gnmedia.net"],
                "prdNagios"         => ["app1v-nagios.tp.prd.lax.gnmedia.net", "app2v-nagios.tp.prd.lax.gnmedia.net"],
                "prdNtp"            => ["app1v-ntp.tp.prd.lax.gnmedia.net", "app2v-ntp.tp.prd.lax.gnmedia.net"],
                "prdPuppet"         => ["app5v-puppet.tp.prd.lax.gnmedia.net", "app6v-puppet.tp.prd.lax.gnmedia.net"],
                "prdSorry"          => ["app1v-sorry.tp.prd.lax.gnmedia.net", "app2v-sorry.tp.prd.lax.gnmedia.net"],
                "prdElasticSearch"  => ["app100v-elasticsearch.tp.prd.lax.gnmedia.net", "app101v-elasticsearch.tp.prd.lax.gnmedia.net"],
                "prdLogStashRedis"  => ["rds100v-logstash.tp.prd.lax.gnmedia.net", "rds101v-logstash.tp.prd.lax.gnmedia.net"],
                "prdLogStash"       => ["app100v-logstash.tp.prd.lax.gnmedia.net", "app101v-logstash.tp.prd.lax.gnmedia.net"],
                "prdMta"            => ["app1v-mta.tp.prd.lax.gnmedia.net", "app2v-mta.tp.prd.lax.gnmedia.net"],
                "prdPhab"           => ["app1v-phab.tp.prd.lax.gnmedia.net", "app2v-phab.tp.prd.lax.gnmedia.net"],
                "stgElasticSearch"  => ["app200v-elasticsearch.tp.prd.lax.gnmedia.net", "app201v-elasticsearch.tp.prd.lax.gnmedia.net"],
                "stgEM"             => ["app1v-em.tp.stg.lax.gnmedia.net", "app2v-em.tp.stg.lax.gnmedia.net"],
                "stgLogStashRedis"  => ["rds200v-logstash.tp.prd.lax.gnmedia.net", "rds201v-logstash.tp.prd.lax.gnmedia.net"],
                "stgLogStash"       => ["app200v-logstash.tp.prd.lax.gnmedia.net", "app201v-logstash.tp.prd.lax.gnmedia.net"],
                "devElasticSearch"  => ["app300v-elasticsearch.tp.prd.lax.gnmedia.net", "app301v-elasticsearch.tp.prd.lax.gnmedia.net"],
                "devLogStashRedis"  => ["rds300v-logstash.tp.prd.lax.gnmedia.net", "rds301v-logstash.tp.prd.lax.gnmedia.net"],
                "devLogStash"       => ["app300v-logstash.tp.prd.lax.gnmedia.net", "app301v-logstash.tp.prd.lax.gnmedia.net"],
                "gweb"              => ["app1v-gweb.tp.prd.lax.gnmedia.net"],
                "metal"             => ["metal-1401.lax.gnmedia.net", "metal-1402.lax.gnmedia.net"],
		"Flume-prd"	    => ["app1v-flume-bd.tp.prd.lax.gnmedia.net"],
                "Flume-stg"         => ["app1v-flume-bd.tp.stg.lax.gnmedia.net"],
                "Flume-dev"         => ["app1v-flume-bd.tp.dev.lax.gnmedia.net"],
	}

	case $fqdn {
                /app1v-gweb.tp.prd.lax.gnmedia.net/: {
                        $clusterName="gweb"
                        $collectors=$clusters[$clusterName]
                }
		/app1v-oncommand.tp.prd.lax.gnmedia.net|app1v-extutils.tp.prd.lax.gnmedia.net|app1v-im.tp.prd.lax.gnmedia.net|app1v-kibana.tp.prd.lax.gnmedia.net|app1v-ldap.tp.prd.lax.gnmedia.net|app1v-nsync.tp.prd.lax.gnmedia.net|app1v-rancid.tp.prd.lax.gnmedia.net|app1v-techweb.tp.prd.lax.gnmedia.net|app1v-webdav.tp.prd.lax.gnmedia.net|app1v-wiki.tp.prd.lax.gnmedia.net|app1v-yum.tp.prd.lax.gnmedia.net|app1v-percona.tp.prd.lax.gnmedia.net|app1v-redmine.tp.prd.lax.gnmedia.net|app2v-git.tp.prd.lax.gnmedia.net|app1v-log.tp.prd.lax.gnmedia.net/: {
			$clusterName="prdSharedServices"
			$collectors=$clusters[$clusterName]
		}
		/app1v-graphite.tp.prd.lax.gnmedia.net|app1v-cacti.tp.prd.lax.gnmedia.net|app1v-dashboards.tp.prd.lax.gnmedia.net|app1v-em.tp.prd.lax.gnmedia.net|app1v-gmetad.tp.prd.lax.gnmedia.net|app1v-noc.tp.prd.lax.gnmedia.net|app1v-nft.tp.prd.lax.gnmedia.net|app1v-vipvisual.tp.prd.lax.gnmedia.net/: {
			$clusterName="prdMonitoring"
			$collectors=$clusters[$clusterName]
		}
		/app2v-cap.tp.prd.lax.gnmedia.net|app2v-deploy.tp.prd.lax.gnmedia.net|app1v-foreman.tp.prd.lax.gnmedia.net|app1v-git.tp.prd.lax.gnmedia.net|app1v-svn.tp.prd.lax.gnmedia.net/: {
			$clusterName="prdCfgMgmt"
			$collectors=$clusters[$clusterName]
		}
		/app1v-carbon.tp.prd.lax.gnmedia.net|app2v-carbon.tp.prd.lax.gnmedia.net|app3v-carbon.tp.prd.lax.gnmedia.net|app4v-carbon.tp.prd.lax.gnmedia.net|app5v-carbon.tp.prd.lax.gnmedia.net/: {
			$clusterName="prdCarbon"
			$collectors=$clusters[$clusterName]
		}
		/app1v-cijoe.tp.prd.lax.gnmedia.net|app2v-ci.tp.prd.lax.gnmedia.net|app3v-ci.tp.prd.lax.gnmedia.net|app4v-ci.tp.prd.lax.gnmedia.net|app5v-ci.tp.prd.lax.gnmedia.net|app6v-ci.tp.prd.lax.gnmedia.net|app7v-ci.tp.prd.lax.gnmedia.net|app8v-ci.tp.prd.lax.gnmedia.net/: {
			$clusterName="prdJenkins"
			$collectors=$clusters[$clusterName]
		}
                /app1v-zmanda.tp.prd.lax.gnmedia.net|sql1v-dashboards.tp.prd.lax.gnmedia.net|sql1v-inv.tp.prd.lax.gnmedia.net|sql2v-inv.tp.prd.lax.gnmedia.net|sql1v-puppet.tp.prd.lax.gnmedia.net|sql2v-puppet.tp.prd.lax.gnmedia.net|sql1v-rt.tp.prd.lax.gnmedia.net|sql2v-rt.tp.prd.lax.gnmedia.net|sql1v-vipvisual.tp.prd.lax.gnmedia.net|sql1v-redmine.tp.prd.lax.gnmedia.net|sql1v-phab.tp.prd.lax.gnmedia.net|sql2v-phab.tp.prd.lax.gnmedia.net/: {
			$clusterName="prdDba"
			$collectors=$clusters[$clusterName]
		}
                /app1v-dnsext.tp.prd.lax.gnmedia.net|app1v-dnsint.tp.prd.lax.gnmedia.net|app1v-dns.tp.prd.lax.gnmedia.net|app2v-dns.tp.prd.lax.gnmedia.net|app3v-dns.tp.prd.lax.gnmedia.net|app4v-dns.tp.prd.lax.gnmedia.net/: {
			$clusterName="prdDns"
			$collectors=$clusters[$clusterName]
		}
                /app1v-inv.tp.prd.lax.gnmedia.net|app2v-inv.tp.prd.lax.gnmedia.net|app1v-rt.tp.prd.lax.gnmedia.net|app2v-rt.tp.prd.lax.gnmedia.net/: {
			$clusterName="prdAtrt"
			$collectors=$clusters[$clusterName]
		}
                /app1v-nagios.tp.prd.lax.gnmedia.net|app2v-nagios.tp.prd.lax.gnmedia.net|app3v-nagios.tp.prd.lax.gnmedia.net/: {
			$clusterName="prdNagios"
			$collectors=$clusters[$clusterName]
		}
                /app1v-ntp.tp.prd.lax.gnmedia.net|app2v-ntp.tp.prd.lax.gnmedia.net|app3v-ntp.tp.prd.lax.gnmedia.net/: {
			$clusterName="prdNtp"
			$collectors=$clusters[$clusterName]
		}
                /app[0-9]+v-puppet.tp.prd/: {
			$clusterName="prdPuppet"
			$collectors=$clusters[$clusterName]
		}
                /app1v-sorry.tp.prd.lax.gnmedia.net|app2v-sorry.tp.prd.lax.gnmedia.net|app3v-sorry.tp.prd.lax.gnmedia.net/: {
			$clusterName="prdSorry"
			$collectors=$clusters[$clusterName]
		}
                /app1v-em.tp.stg.lax.gnmedia.net/: {
                        $clusterName="stgEM"
                        $collectors=$clusters[$clusterName]
                }
                /app[0-9]+v-mta.tp.prd.lax.gnmedia.net/: {
                        $clusterName="prdMta"
                        $collectors=$clusters[$clusterName]
                }
                /app[0-9]+v-phab.tp.prd.lax.gnmedia.net/: {
                        $clusterName="prdPhab"
                        $collectors=$clusters[$clusterName]
                }
                /app1[0-9]+v-logstash.tp.prd.lax.gnmedia.net/: {
                        $clusterName="prdLogStash"
                        $collectors=$clusters[$clusterName]
                }
                /rds1[0-9]+v-logstash.tp.prd.lax.gnmedia.net/: {
                        $clusterName="prdLogStashRedis"
                        $collectors=$clusters[$clusterName]
                }
                /app1[0-9]+v-elasticsearch.tp.prd.lax.gnmedia.net/: {
                        $clusterName="prdElasticSearch"
                        $collectors=$clusters[$clusterName]
                }
                /app2[0-9]+v-logstash.tp.prd.lax.gnmedia.net/: {
                        $clusterName="stgLogStash"
                        $collectors=$clusters[$clusterName]
                }
                /rds2[0-9]+v-logstash.tp.prd.lax.gnmedia.net/: {
                        $clusterName="stgLogStashRedis"
                        $collectors=$clusters[$clusterName]
                }
                /app2[0-9]+v-elasticsearch.tp.prd.lax.gnmedia.net/: {
                        $clusterName="stgElasticSearch"
                        $collectors=$clusters[$clusterName]
                }
                /app3[0-9]+v-logstash.tp.prd.lax.gnmedia.net/: {
                        $clusterName="devLogStash"
                        $collectors=$clusters[$clusterName]
                }
                /rds3[0-9]+v-logstash.tp.prd.lax.gnmedia.net/: {
                        $clusterName="devLogStashRedis"
                        $collectors=$clusters[$clusterName]
                }
                /app3[0-9]+v-elasticsearch.tp.prd.lax.gnmedia.net/: {
                        $clusterName="devElasticSearch"
                        $collectors=$clusters[$clusterName]
                }
                /metal14[0-9][0-9].lax.gnmedia.net/: {
                        $clusterName="metal"
                        $collectors=$clusters[$clusterName]
                }
                /app1v-flume-bd.tp.prd.lax.gnmedia.net/: {
                        $clusterName="Flume-prd"
                        $collectors=$clusters[$clusterName]
                }
                /app1v-flume-bd.tp.stg.lax.gnmedia.net/: {
                        $clusterName="Flume-stg"
                        $collectors=$clusters[$clusterName]
                }
                /app1v-flume-bd.tp.dev.lax.gnmedia.net/: {
                        $clusterName="Flume-dev"
                        $collectors=$clusters[$clusterName]
                }

	}
}
