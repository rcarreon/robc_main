node 'app2v-cron.ap.dev.lax.gnmedia.net' {
  include base
  $project='adops'
  include common::app

  include newrelic
  include newrelic::params
  include newrelic::sysmond
  include newrelic::nfsiostat

  include yum::adopsgem::wildwest

  include adops::rbenv
  include ap::app::common_mounts
  include ap::app::workers
  include ap::app::workers::reporting
  include ap::app::workers::reporting::dev
  include ap::app::workers::dfp
  include ap::app::workers::dfp::dev

  include ap::app::workers::payout_cache
  include ap::app::workers::payout_cache::dev

  include ap::app::workers::janitor
  include ap::app::workers::janitor::dev
}
