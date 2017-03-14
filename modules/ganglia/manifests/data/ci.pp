class ganglia::data::ci {
    $clusters = {
        "app-ci-prd"        => ["app1v-ci.ci.prd.lax.gnmedia.net", "app2v-ci.ci.prd.lax.gnmedia.net"],
        "app-ci-stg"        => ["app1v-ci.ci.stg.lax.gnmedia.net", "app2v-ci.ci.stg.lax.gnmedia.net"],
        "app-ci-dev"        => ["app1v-ci.ci.dev.lax.gnmedia.net", "app1v-mgmt.ci.dev.lax.gnmedia.net"],
        "app-vw-prd"        => ["app1v-vw.ci.prd.lax.gnmedia.net", "app2v-vw.ci.prd.lax.gnmedia.net"],
        "app-vw-stg"        => ["app1v-vw.ci.stg.lax.gnmedia.net", "app2v-vw.ci.stg.lax.gnmedia.net"],
        "app-gweb-prd"      => ["app1v-gweb.ci.prd.lax.gnmedia.net"],
        "app-mgmt-prd"      => ["app1v-mgmt.ci.prd.lax.gnmedia.net", "app2v-mgmt.ci.prd.lax.gnmedia.net"],
        "app-mgmt-stg"      => ["app1v-mgmt.ci.stg.lax.gnmedia.net"],
        "eng-ci-prd"        => ["eng1v-ci.ci.prd.lax.gnmedia.net", "eng2v-ci.ci.prd.lax.gnmedia.net"],
        "eng-ci-stg"        => ["eng1v-ci.ci.stg.lax.gnmedia.net", "eng2v-ci.ci.stg.lax.gnmedia.net"],
        "kes-ci-prd"        => ["kes1v-ci.ci.prd.lax.gnmedia.net", "kes2v-ci.ci.prd.lax.gnmedia.net"],
        "mem-cache-prd"     => ["mem1v-ci.ci.prd.lax.gnmedia.net", "mem2v-ci.ci.prd.lax.gnmedia.net"],
        "mem-ses-prd"       => ["mem1v-ses.ci.prd.lax.gnmedia.net", "mem2v-ses.ci.prd.lax.gnmedia.net"],
        "ngx-ci-prd"        => ["ngx1v-ci.ci.prd.lax.gnmedia.net", "ngx2v-ci.ci.prd.lax.gnmedia.net"],
        "ngx-ci-stg"        => ["ngx1v-ci.ci.stg.lax.gnmedia.net", "ngx2v-ci.ci.stg.lax.gnmedia.net"],
        "spx-ci-prd"        => ["spx1v-ci.ci.prd.lax.gnmedia.net"],
        "sql-archive-prd"   => ["sql1v-archive.ci.prd.lax.gnmedia.net"],
        "sql-audit-prd"     => ["sql1v-audit.ci.prd.lax.gnmedia.net", "sql2v-audit.ci.prd.lax.gnmedia.net"],
        "sql-ci-prd"        => ["sql1v-ci.ci.prd.lax.gnmedia.net", "sql2v-ci.ci.prd.lax.gnmedia.net"],
        "sql-dw-prd"        => ["sql1v-dw.ci.prd.lax.gnmedia.net", "sql2v-dw.ci.prd.lax.gnmedia.net"],
	"mem-cache-stg"	    => ["mem1v-ci.ci.stg.lax.gnmedia.net", "mem2v-ci.ci.stg.lax.gnmedia.net"],
	"kes-ci-stg"	    => ["kes1v-ci.ci.stg.lax.gnmedia.net", "kes2v-ci.ci.stg.lax.gnmedia.net"],
    }

   case $fqdn {
        /app[0-9]+v-ci.ci.prd/: {
            $clusterName="app-ci-prd"
            $collectors=$clusters[$clusterName]
        }
        /app[0-9]+v-ci.ci.stg/: {
            $clusterName="app-ci-stg"
            $collectors=$clusters[$clusterName]
        }
        /app[0-9]+v-(ci|mgmt).ci.dev/: {
            $clusterName="app-ci-dev"
            $collectors=$clusters[$clusterName]
        }
        /app[0-9]+v-vw.ci.prd/: {
            $clusterName="app-vw-prd"
            $collectors=$clusters[$clusterName]
        }
        /app[0-9]+v-vw.ci.stg/: {
            $clusterName="app-vw-stg"
            $collectors=$clusters[$clusterName]
        }
        /app1v-gweb.ci.prd.lax.gnmedia.net/: {
            $clusterName="app-gweb-prd"
            $collectors=$clusters[$clusterName]
        }
        /app[0-9]+v-mgmt.ci.prd/: {
            $clusterName="app-mgmt-prd"
            $collectors=$clusters[$clusterName]
        }
        /app[0-9]+v-mgmt.ci.stg/: {
            $clusterName="app-mgmt-stg"
            $collectors=$clusters[$clusterName]
        }
        /eng[0-9]+v-ci.ci.prd/: {
            $clusterName="eng-ci-prd"
            $collectors=$clusters[$clusterName]
        }
        /eng[0-9]+v-ci.ci.stg/: {
            $clusterName="eng-ci-stg"
            $collectors=$clusters[$clusterName]
        }
        /kes[0-9]+v-ci.ci.prd/: {
            $clusterName="kes-ci-prd"
            $collectors=$clusters[$clusterName]
        }
        /mem[0-9]+v-ci.ci.prd/: {
            $clusterName="mem-cache-prd"
            $collectors=$clusters[$clusterName]
        }
        /mem[0-9]+v-ses.ci.prd/: {
            $clusterName="mem-ses-prd"
            $collectors=$clusters[$clusterName]
        }
        /ngx[0-9]+v-ci.ci.prd/: {
            $clusterName="ngx-ci-prd"
            $collectors=$clusters[$clusterName]
        }
        /ngx[0-9]+v-ci.ci.stg/: {
            $clusterName="ngx-ci-stg"
            $collectors=$clusters[$clusterName]
        }
        /spx[0-9]+v-ci.ci.prd/: {
            $clusterName="spx-ci-prd"
            $collectors=$clusters[$clusterName]
        }
        /sql[0-9]+v-archive.ci.prd/: {
            $clusterName="sql-archive-prd"
            $collectors=$clusters[$clusterName]
        }
        /sql[0-9]+v-audit.ci.prd/: {
            $clusterName="sql-audit-prd"
            $collectors=$clusters[$clusterName]
        }
        /sql[0-9]+v-ci.ci.prd/: {
            $clusterName="sql-ci-prd"
            $collectors=$clusters[$clusterName]
        }
        /sql[0-9]+v-dw.ci.prd/: {
            $clusterName="sql-dw-prd"
            $collectors=$clusters[$clusterName]
        }
        /mem[0-9]+v-ci.ci.stg/: {
            $clusterName="mem-cache-stg"
            $collectors=$clusters[$clusterName]
        }
        /kes[0-9]+v-ci.ci.stg/: {
            $clusterName="kes-ci-stg"
            $collectors=$clusters[$clusterName]
        }
    }

}
