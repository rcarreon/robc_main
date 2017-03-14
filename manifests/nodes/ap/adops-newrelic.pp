# directories needed for adops
class adops::newrelic(
  $app_name = 'Adops',
  $log_dir = false,
  $only_sysmond = false,
) {

  $license = 'b5102cba45e4a6d961ef0611cd76aaec60540507'

    class { 'adops::newrelic::sysmond':}

    if !$only_sysmond {
      class { 'adops::newrelic::apm':}
    }
}
