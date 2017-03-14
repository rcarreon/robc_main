sqlcopy::cron { 'jenkins_build':
  mapfile => 'stg-dev.ci',
  minute  => '0',
  hour    => '2',
  ensure  => absent,
}
