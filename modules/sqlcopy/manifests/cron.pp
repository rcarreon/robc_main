# schedule sqlcopy cronjobs
define sqlcopy::cron(
  $ensure='present',
  $mapfile='',
  $mailto='DBA@gorillanation.com',
  $user='root',
  $weekday=['0-6'],
  $minute='',
  $hour='') {

  include sqlcopy

  if ! $mapfile {
    fail('A mapfile must be defined.')
  }

  # mapfile defs
  file { "/usr/local/mapfiles/$mapfile":
    source  => "puppet:///modules/sqlcopy/mapfiles/${mapfile}",
    mode    => '0755',
    require => File['/usr/local/mapfiles'],
    owner   => 'deploy',
    group   => 'deploy',
  }

  if $user == 'root' {
    cron { "${name}":
      ensure      => $ensure,
      command     => "time /usr/local/bin/sqlcopy --nothrottle /usr/local/mapfiles/${mapfile}",
      environment => "MAILTO=${mailto}",
      user        => $user,
      weekday     => $weekday,
      hour        => $hour,
      minute      => $minute,
    }
  } else {
    cron { "${name}":
      ensure      => $ensure,
      command     => "/usr/bin/sudo time /usr/local/bin/sqlcopy --nothrottle /usr/local/mapfiles/${mapfile}",
      environment => "MAILTO=${mailto}",
      user        => $user,
      weekday     => $weekday,
      hour        => $hour,
      minute      => $minute,
    }
  }
}
