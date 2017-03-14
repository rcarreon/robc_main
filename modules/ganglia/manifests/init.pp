class ganglia {

    include "ganglia::data::${fqdn_vertical}"
    include ganglia::data::gweb

    ### Can't use variables in namespaces like the below. I wish I could.
    #$clustername = $ganglia::data::$fqdn_vertical::clustername

    case $::fqdn_vertical {
        'tp': {
            case $::fqdn_env {
                'dev': {
                    $clusters = $ganglia::data::tpdev::clusters
                    $clustername = "$ganglia::data::tpdev::clusterName"
                    $collectors = $ganglia::data::tpdev::collectors

                    # These are required even if not custom.
                    $sampling = "$ganglia::data::tpdev::sampling"
                    $samplingHttp = "$ganglia::data::tpdev::samplingHttp"
                    $samplingMemcache = "$ganglia::data::tpdev::samplingMemcache"
                }
                default: {
                    $clusters = $ganglia::data::tp::clusters
                    $clustername = "$ganglia::data::tp::clusterName"
                    $collectors = $ganglia::data::tp::collectors

                    # These are required even if not custom.
                    $sampling = "$ganglia::data::tp::sampling"
                    $samplingHttp = "$ganglia::data::tp::samplingHttp"
                    $samplingMemcache = "$ganglia::data::tp::samplingMemcache"
                }
            }
        }
        'sbv': {
            $clusters = $ganglia::data::sbv::clusters
            $clustername = "$ganglia::data::sbv::clusterName"
            $collectors = $ganglia::data::sbv::collectors

            $sampling = "$ganglia::data::sbv::sampling"
            $samplingHttp = "$ganglia::data::sbv::samplingHttp"
            $samplingMemcache = "$ganglia::data::sbv::samplingMemcache"

        }
        'ao': {
            $clusters = $ganglia::data::ao::clusters
            $clustername = "$ganglia::data::ao::clusterName"
            $collectors = $ganglia::data::ao::collectors

            $sampling = "$ganglia::data::ao::sampling"
            $samplingHttp = "$ganglia::data::ao::samplingHttp"
            $samplingMemcache = "$ganglia::data::ao::samplingMemcache"
        }
        'ap': {
            $clusters = $ganglia::data::ap::clusters
            $clustername = "$ganglia::data::ap::clusterName"
            $collectors = $ganglia::data::ap::collectors

            $sampling = "$ganglia::data::ap::sampling"
            $samplingHttp = "$ganglia::data::ap::samplingHttp"
            $samplingMemcache = "$ganglia::data::ap::samplingMemcache"
        }
        'ci': {
            $clusters = $ganglia::data::ci::clusters
            $clustername = "$ganglia::data::ci::clusterName"
            $collectors = $ganglia::data::ci::collectors

            $sampling = "$ganglia::data::ci::sampling"
            $samplingHttp = "$ganglia::data::ci::samplingHttp"
            $samplingMemcache = "$ganglia::data::ci::samplingMemcache"
        }
        'si': {
            $clusters = $ganglia::data::si::clusters
            $clustername = "$ganglia::data::si::clusterName"
            $collectors = $ganglia::data::si::collectors

            $sampling = "$ganglia::data::si::sampling"
            $samplingHttp = "$ganglia::data::si::samplingHttp"
            $samplingMemcache = "$ganglia::data::si::samplingMemcache"
        }
        'og': {
            $clusters = $ganglia::data::og::clusters
            $clustername = "$ganglia::data::og::clusterName"
            $collectors = $ganglia::data::og::collectors

            $sampling = "$ganglia::data::og::sampling"
            $samplingHttp = "$ganglia::data::og::samplingHttp"
            $samplingMemcache = "$ganglia::data::og::samplingMemcache"
        }
	 'af': {
            $clusters = $ganglia::data::af::clusters
            $clustername = "$ganglia::data::af::clusterName"
            $collectors = $ganglia::data::af::collectors

            $sampling = "$ganglia::data::af::sampling"
            $samplingHttp = "$ganglia::data::af::samplingHttp"
            $samplingMemcache = "$ganglia::data::af::samplingMemcache"
        }
        default: {
            fail('orphaned ganglia config; please fix.')
        }
    }

    $gwebs = $ganglia::data::gweb::gwebs

    if ($fqdn in $gwebs) {
        $gridName="${fqdn_vertical}-grid"
        if ($fqdn == 'app1v-gweb.tp.prd.lax.gnmedia.net') {
            # This is the super aggregator
            $gwebAggregator = true
        }
    }

    if $clustername or $gridName {
        file { '/etc/ganglia':
            ensure => directory,
            owner  => 'root',
            group  => 'root',
            mode   => '0644',
        }
        file { '/etc/ganglia/conf.d':
            ensure  => directory,
            owner   => 'root',
            group   => 'root',
            mode    => '0644',
            require => File['/etc/ganglia'],
        }
    }

    if $clustername {
        include ganglia::cfg::gmond
        include ganglia::pkg::gmond
        include ganglia::svc::gmond
    } else {
        class {'ganglia::pkg::gmond':
            pkgInstall => 'absent',
        }
        class {'ganglia::cfg::gmond':
            noConfigs => true,
        }
    }


    if $gridName {
        class { 'ganglia::pkg::gweb':
            rrdInstall => true,
        }
        include ganglia::cfg::gweb
        include ganglia::svc::gweb
    } else {
        class {'ganglia::pkg::gweb':
            pkgInstall => 'absent',
        }
        class {'ganglia::cfg::gweb':
            install => false,
        }
        class {'ganglia::svc::gweb':
            serviceStart  => 'stopped',
            serviceEnable => false,
        }
    }

}
