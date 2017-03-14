class ganglia::data::si {
    $clusters = {
        "prdAssets" => ["app1v-assets.si.prd.lax.gnmedia.net", "app2v-assets.si.prd.lax.gnmedia.net"],
        "prdDh"     => ["app1v-dh.si.prd.lax.gnmedia.net", "app2v-dh.si.prd.lax.gnmedia.net"],
        "prdEws"    => ["app1v-ews.si.prd.lax.gnmedia.net", "app2v-ews.si.prd.lax.gnmedia.net"],
        "prdSqlDh"  => ["sql1v-dh.si.prd.lax.gnmedia.net", "sql2v-dh.si.prd.lax.gnmedia.net"],
        "prdSqlEws" => ["sql1v-ews.si.prd.lax.gnmedia.net", "sql2v-ews.si.prd.lax.gnmedia.net"],
        "gweb"      => ["app1v-gweb.si.prd.lax.gnmedia.net"],
    }
    case $fqdn {
        /app[0-9]+v-assets.si.prd/: {
            $clusterName="prdAssets"
        }
        /app[0-9]+v-dh.si.prd/: {
            $clusterName="prdDh"
        }
        /app[0-9]+v-ews.si.prd/: {
            $clusterName="prdEws"
        }
        /sql[0-9]+v-dh.si.prd/: {
            $clusterName="prdSqlDh"
        }
        /sql[0-9]+v-ews.si.prd/: {
            $clusterName="prdSqlEws"
        }
        /app[0-9]+v-gweb.si.prd/: {
            $clusterName="gweb"
        }
    }
    $collectors=$clusters[$clusterName]
}
