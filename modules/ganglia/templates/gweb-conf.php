<?php
$conf['rrdcached_socket']="/var/rrdtool/rrdcached/rrdcached.sock";
$conf['overlay_events'] = "true";
$conf['auth_system'] = 'disabled';

# Where gmetad stores the rrd archives.
$conf['gmetad_root'] = "/app/data/ganglia";
$conf['rrds'] = "${conf['gmetad_root']}/rrds";

# Where Dwoo (PHP templating engine) store compiled templates
$conf['dwoo_compiled_dir'] = "${conf['gmetad_root']}/dwoo/compiled";
$conf['dwoo_cache_dir'] = "${conf['gmetad_root']}/dwoo/cache";

# Where to store web-based configuration
$conf['views_dir'] = $conf['gmetad_root'] . '/conf';
$conf['conf_dir'] = $conf['gmetad_root'] . '/conf';

$conf['cachefile'] = $conf['conf_dir'] . "/ganglia_metrics.cache";
$conf['nagios_cache_file'] = $conf['conf_dir'] . "/nagios_ganglia.cache";
$conf['overlay_events_file'] = $conf['conf_dir'] . "/events.json";
$conf['overlay_events_color_map_file'] = $conf['conf_dir'] . "/event_color.json";

?>
