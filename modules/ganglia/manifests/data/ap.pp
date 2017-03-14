class ganglia::data::ap {
    $clusters = {
        "app-adops"     => ["app1v-adops.ap.prd.lax.gnmedia.net", "app2v-adops.ap.prd.lax.gnmedia.net"],
        "app-archive"   => ["app1v-archive.ap.prd.lax.gnmedia.net"],
        "app-geoip"     => ["app1v-geoip.ap.prd.lax.gnmedia.net", "app2v-geoip.ap.prd.lax.gnmedia.net"],
        "app-gweb"      => ["app1v-gweb.ap.prd.lax.gnmedia.net"],
        "app-mediaads"  => ["app1v-mediaads.ap.prd.lax.gnmedia.net", "app2v-mediaads.ap.prd.lax.gnmedia.net"],
        "app-cron"      => ["app1v-cron.ap.prd.lax.gnmedia.net"],
        "app-pubops"    => ["app1v-pubops.ap.prd.lax.gnmedia.net", "app2v-pubops.ap.prd.lax.gnmedia.net"],
	"app-pubops-martini-dev"    => ["app1v-pubops-martini.ap.dev.lax.gnmedia.net"],
        "app-pubops-martini-stg"    => ["app1v-pubops-martini.ap.stg.lax.gnmedia.net","app2v-pubops-martini.ap.stg.lax.gnmedia.net"],
        "app-pubops-martini-prd"    => ["app1v-pubops-martini.ap.prd.lax.gnmedia.net","app2v-pubops-martini.ap.prd.lax.gnmedia.net"],
        "app-tags"      => ["app1v-tags.ap.prd.lax.gnmedia.net", "app2v-tags.ap.prd.lax.gnmedia.net"],
        "app-tt"        => ["app1v-tt.ap.prd.lax.gnmedia.net", "app2v-tt.ap.prd.lax.gnmedia.net"],
        "mem-adops"     => ["mem1v-adops.ap.prd.lax.gnmedia.net", "mem1v-adops.ap.prd.lax.gnmedia.net"],
        "sql-adops"     => ["sql1v-adops.ap.prd.lax.gnmedia.net", "sql2v-adops.ap.prd.lax.gnmedia.net"],
        "sql-archive"   => ["sql1v-archive.ap.prd.lax.gnmedia.net", "sql2v-archive.ap.prd.lax.gnmedia.net"],
        "sql-backup"    => ["sql1v-backup.ap.prd.lax.gnmedia.net"],
        "sql-pubops"    => ["sql1v-pubops.ap.prd.lax.gnmedia.net", "sql2v-pubops.ap.prd.lax.gnmedia.net"],
        "sql-pubops-martini-dev"    => ["sql1v-pubops-martini.ap.dev.lax.gnmedia.net"],
        "sql-pubops-martini-stg"    => ["sql1v-pubops-martini.ap.stg.lax.gnmedia.net", "sql2v-pubops-martini.ap.stg.lax.gnmedia.net"],
        "sql-pubops-martini-prd"    => ["sql1v-pubops-martini.ap.prd.lax.gnmedia.net", "sql2v-pubops-martini.ap.prd.lax.gnmedia.net"],
    }

    case $fqdn {
        /app[0-9]+v-adops.ap.prd/: {
            $clusterName="app-adops"
        }
        /app[0-9]+v-archive.ap.prd/: {
            $clusterName="app-archive"
        }
        /app[0-9]+v-geoip.ap.prd/: {
            $clusterName="app-geoip"
        }
        /app[0-9]+v-gweb.ap.prd/: {
            $clusterName="app-gweb"
        }
        /app[0-9]+v-mediaads.ap.prd/: {
            $clusterName="app-mediaads"
        }
        /app[0-9]+v-cron.ap.prd/: {
            $clusterName="app-cron"
        }
        /app[0-9]+v-pubops.ap.prd/: {
            $clusterName="app-pubops"
        }
	/app[0-2]+v-pubops-martini.ap.prd/: {
           $clusterName="app-pubops-martini-prd"
        }
        /app[0-9]+v-pubops-martini.ap.stg/: {
           $clusterName="app-pubops-martini-stg"
        }
        /app[0-9]+v-pubops-martini.ap.dev/: {
           $clusterName="app-pubops-martini-dev"
        }
        /app[0-9]+v-tags.ap.prd/: {
            $clusterName="app-tags"
        }
        /app[0-9]+v-tt.ap.prd/: {
            $clusterName="app-tt"
        }
        /mem[0-9]+v-adops.ap.prd/: {
            $clusterName="mem-adops"
        }
        /sql[0-9]+v-adops.ap.prd/: {
            $clusterName="sql-adops"
        }
        /sql[0-9]+v-archive.ap.prd/: {
            $clusterName="sql-archive"
        }
        /sql[0-9]+v-backup.ap.prd/: {
            $clusterName="sql-backup"
        }
        /sql[0-9]+v-pubops.ap.prd/: {
            $clusterName="sql-pubops"
        }
        /sql[0-2]+v-pubops-martini.ap.dev/: {
            $clusterName="sql-pubops-martini-dev"
        }
        /sql[0-2]+v-pubops-martini.ap.stg/: {
            $clusterName="sql-pubops-martini-stg"
        }
        /sql[0-2]+v-pubops-martini.ap.prd/: {
            $clusterName="sql-pubops-martini-prd"
        }

    }

    $collectors=$clusters[$clusterName]
}
