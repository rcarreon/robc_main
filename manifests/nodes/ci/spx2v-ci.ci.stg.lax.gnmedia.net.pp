node 'spx2v-ci.ci.stg.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base
    $project='crowdignite'
    class { 'sphinxrt': sphinx_version => '2.2.4-1.rhel6' }
#    class { 'sphinxrt': sphinx_version => '2.0.8-1.el6' }

    include common::app
}
