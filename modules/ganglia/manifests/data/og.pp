class ganglia::data::og {
    $clusters = {
        "app-origin-prd"    => ["app1v-origin.og.prd.lax.gnmedia.net", "app1v-origin.og.prd.lax.gnmedia.net"],
        "mem-origin-prd"    => ["mem1v-origin.og.prd.lax.gnmedia.net", "mem2v-origin.og.prd.lax.gnmedia.net"],
        "sql-origin-prd"    => ["sql1v-origin.og.prd.lax.gnmedia.net", "sql2v-origin.og.prd.lax.gnmedia.net"],
        "app-gweb-prd"      => ["app1v-gweb.og.prd.lax.gnmedia.net"],
	"Flume-prd"	    => ["app1v-flume-bd.tp.prd.lax.gnmedia.net"],
    }

    case $fqdn {
        /app[0-9]+v-origin.og.prd/: {
            $clusterName="app-origin-prd"
            $collectors=$clusters[$clusterName]
        }
        /mem[0-9]+v-origin.og.prd/: {
            $clusterName="mem-origin-prd"
            $collectors=$clusters[$clusterName]
        }
        /sql[0-9]+v-origin.og.prd/: {
            $clusterName="sql-origin-prd"
            $collectors=$clusters[$clusterName]
        }
        /app[0-9]+v-gweb.og.prd/: {
            $clusterName="app-gweb-prd"
            $collectors=$clusters[$clusterName]
        }
        /app1v-flume-bd.tp.prd.lax.gnmedia.net/: {
            $clusterName="Flume-prd"
            $collectors=$clusters[$clusterName]
        }

    }

}
