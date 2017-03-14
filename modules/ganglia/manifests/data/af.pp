class ganglia::data::af {
    $clusters = {
        "app-media-prd"     => ["app1v-media.af.prd.lax.gnmedia.net", "app2v-media.af.prd.lax.gnmedia.net"],
    }

    case $fqdn {
        /app[0-9]+v-media.af.prd/: {
            $clusterName="app-media-prd"
    	    $collectors=$clusters[$clusterName]
        }
    }
}
