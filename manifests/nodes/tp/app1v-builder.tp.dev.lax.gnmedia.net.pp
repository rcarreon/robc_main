node 'app1v-builder.tp.dev.lax.gnmedia.net' {
  include newrelic
  include newrelic::params
  include newrelic::sysmond
  include newrelic::nfsiostat

    include base
    include yum::mysql5527
        $project="admin"

    include mock

}
