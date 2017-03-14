<?php

/*

nfslatency report graph

*/

function graph_nfslatency_report ( &$rrdtool_graph ) {

/*
 * this is just the cpu_report (from revision r920) as an example, but
 * with extra comments
 */

// pull in a number of global variables, many set in conf.php (such as colors)
// but other from elsewhere, such as get_context.php

    global $conf,
           $context,
           $range,
           $rrd_dir,
           $size;

    if ($conf['strip_domainname']) {
       $hostname = strip_domainname($GLOBALS['hostname']);
    } else {
       $hostname = $GLOBALS['hostname'];
    }

    //
    // You *MUST* set at least the 'title', 'vertical-label', and 'series'
    // variables otherwise, the graph *will not work*.
    //
    $title = 'NFS Latency';
    if ($context != 'host') {
       //  This will be turned into: "Clustername $TITLE last $timerange",
       //  so keep it short
       $rrdtool_graph['title']  = $title;
    } else {
       $rrdtool_graph['title']  = "$hostname $title last $range";
    }
    $rrdtool_graph['vertical-label'] = 'Latency Seconds';
    // Fudge to account for number of lines in the chart legend
    $rrdtool_graph['height']        += ($size == 'medium') ? 28 : 0;
    //$rrdtool_graph['upper-limit']    = '100';
    //$rrdtool_graph['lower-limit']    = '0';
    //$rrdtool_graph['extras']         = '--rigid';

    /*
     * Here we actually build the chart series.  This is moderately complicated
     * to show off what you can do.  For a simpler example, look at
     * network_report.php
     */
  
    if (file_exists("$rrd_dir/nfsmounts-avg.rrd")) {
        if($context != "host" ) {

        /*
         * If we are not in a host context, then we need to calculate
         * the average
         */
        $series =
              "'DEF:num_nodes=${rrd_dir}/nfsmounts-avg.rrd:num:AVERAGE' "
            . "'DEF:nfsmounts_avg=${rrd_dir}/nfsmounts-avg.rrd:sum:AVERAGE' "
            . "'CDEF:cnfsmounts_avg=nfsmounts_avg,num_nodes,/' "
            . "'DEF:nfsmounts_max=${rrd_dir}/nfsmounts-max.rrd:sum:AVERAGE' "
            . "'CDEF:cnfsmounts_max=nfsmounts_max,num_nodes,/' "
            . "LINE:'cnfsmounts_avg'#${conf['cpu_user_color']}:'Average' "
            . "LINE:'cnfsmounts_max'#${conf['cpu_system_color']}:'Maximum' ";


        } else {

        // Context *is* "host"
        $series =
              "'DEF:nfsmounts_avg=${rrd_dir}/nfsmounts-avg.rrd:sum:AVERAGE' "
            . "'DEF:nfsmounts_max=${rrd_dir}/nfsmounts-max.rrd:sum:AVERAGE' "
            . "LINE:'nfsmounts_avg'#${conf['cpu_user_color']}:'Average' "
            . "LINE:'nfsmounts_max'#${conf['cpu_system_color']}:'Maximum' ";

        }
    } else {
        $series = 'HRULE:1#FFCC33:"No nfsmount metrics found"';
    }

    // We have everything now, so add it to the array, and go on our way.
    $rrdtool_graph['series'] = $series;

    return $rrdtool_graph;
}

?>
