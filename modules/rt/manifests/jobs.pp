# jobs class for rt
class rt::jobs {
  # session purge script
  file {'/usr/local/bin/session_cleanup.pl':
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    source  => 'puppet:///modules/rt/session_cleanup.pl',
  }
  # nightly session cleaup
        cron { 'nightly_session_cleanup':
                ensure  => present,
                user    => 'root',
                hour    => '0',
                minute  => '0',
                command => '/usr/bin/perl /usr/local/bin/session_cleanup.pl > /usr/local/bin/session_cleaup.log 2>&1'
        }
}
