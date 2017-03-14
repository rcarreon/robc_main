class ganglia::data::sbv {
    $clusters = {
        "prdMedia"       => ["app1v-media.sbv.prd.lax.gnmedia.net", "app2v-media.sbv.prd.lax.gnmedia.net"],
        "prdCms"         => ["app1v-cms.sbv.prd.lax.gnmedia.net", "app2v-cms.sbv.prd.lax.gnmedia.net"],
        "prdStatsCms"    => ["app1v-stats-cms.sbv.prd.lax.gnmedia.net", "app2v-stats-cms.sbv.prd.lax.gnmedia.net"],
        "prdYourls"      => ["app1v-yourls.sbv.prd.lax.gnmedia.net", "app2v-yourls.sbv.prd.lax.gnmedia.net"],
        "prdSqlCms"      => ["sql1v-cms.sbv.prd.lax.gnmedia.net", "sql2v-cms.sbv.prd.lax.gnmedia.net"],
        "prdSqlStatsCms" => ["sql1v-stats-cms.sbv.prd.lax.gnmedia.net", "sql2v-stats-cms.sbv.prd.lax.gnmedia.net"],
        "prdSqlYourls"   => ["sql1v-yourls.sbv.prd.lax.gnmedia.net", "sql2v-yourls.sbv.prd.lax.gnmedia.net"],
        "gweb"           => ["app1v-gweb.sbv.prd.lax.gnmedia.net"],
        "stgMedia"       => ["app1v-media.sbv.stg.lax.gnmedia.net", "app2v-media.sbv.stg.lax.gnmedia.net"],
        "stgCms"         => ["app1v-cms.sbv.stg.lax.gnmedia.net", "app2v-cms.sbv.stg.lax.gnmedia.net"],
        "stgStatsCms"    => ["app1v-stats-cms.sbv.stg.lax.gnmedia.net", "app2v-stats-cms.sbv.stg.lax.gnmedia.net"],
        "stgYourls"      => ["app1v-yourls.sbv.stg.lax.gnmedia.net", "app2v-yourls.sbv.stg.lax.gnmedia.net"],
        "stgSqlCms"      => ["sql1v-cms.sbv.stg.lax.gnmedia.net", "sql2v-cms.sbv.stg.lax.gnmedia.net"],
        "stgSqlStatsCms" => ["sql1v-stats-cms.sbv.stg.lax.gnmedia.net", "sql2v-stats-cms.sbv.stg.lax.gnmedia.net"],
        "stgSqlYourls"   => ["sql1v-yourls.sbv.stg.lax.gnmedia.net", "sql2v-yourls.sbv.stg.lax.gnmedia.net"],
 
    }

    case $fqdn {
        /app[0-9]+v-media.sbv.prd/: {
            $clusterName="prdMedia"
            $collectors=$clusters[$clusterName]
        }
        /app[0-9]+v-cms.sbv.prd/: {
            $clusterName="prdCms"
            $collectors=$clusters[$clusterName]
        }
        /app[0-9]+v-stats-cms.sbv.prd/: {
            $clusterName="prdStatsCms"
            $collectors=$clusters[$clusterName]
        }
        /app[0-9]+v-yourls.sbv.prd/: {
            $clusterName="prdYourls"
            $collectors=$clusters[$clusterName]
        }
        /sql[0-9]+v-cms.sbv.prd/: {
            $clusterName="prdSqlCms"
            $collectors=$clusters[$clusterName]
        }
        /sql[0-9]+v-stats-cms.sbv.prd/: {
            $clusterName="prdSqlStatsCms"
            $collectors=$clusters[$clusterName]
        }
        /sql[0-9]+v-yourls.sbv.prd/: {
            $clusterName="prdSqlYourls"
            $collectors=$clusters[$clusterName]
        }
        /app[0-9]+v-media.sbv.stg/: {
            $clusterName="stgMedia"
            $collectors=$clusters[$clusterName]
        }
        /app[0-9]+v-cms.sbv.stg/: {
            $clusterName="stgCms"
            $collectors=$clusters[$clusterName]
        }
        /app[0-9]+v-stats-cms.sbv.stg/: {
            $clusterName="stgStatsCms"
            $collectors=$clusters[$clusterName]
        }
        /app[0-9]+v-gweb.sbv/: {
            $clusterName="gweb"
            $collectors=$clusters[$clusterName]
        }
        /app[0-9]+v-yourls.sbv.stg/: {
            $clusterName="stgYourls"
            $collectors=$clusters[$clusterName]
        }
        /sql[0-9]+v-cms.sbv.stg/: {
            $clusterName="stgSqlCms"
            $collectors=$clusters[$clusterName]
        }
        /sql[0-9]+v-stats-cms.sbv.stg/: {
            $clusterName="stgSqlStatsCms"
            $collectors=$clusters[$clusterName]
        }
        /sql[0-9]+v-yourls.sbv.stg/: {
            $clusterName="stgSqlYourls"
            $collectors=$clusters[$clusterName]
        }
 
    }

}
