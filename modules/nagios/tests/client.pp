include nagios::client
nagios::service {"ganglia_trend_evictions":
    command => "check_ganglia_trending!'http://ci.gweb.gnmedia.net/graph.php?r=week&c=mem-cache-prd&h=mem1v-ci.ci.prd.lax.gnmedia.net&m=mc_evictions&vl=items&json=1'!percent!diff!.15!.25",
    notes_url => "http://docs.gnmedia.net/wiki/Nagios-check_ganglia_trend_evictions",
}
nagios::service {"kestrel":
    command => "check_kestrel",
    notes_url => "http://docs.gnmedia.net/wiki/Nagios-check_kestrel",
}   
