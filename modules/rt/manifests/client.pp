# client class for rt
class rt::client {
  include perl::rt

  file {'/usr/local/bin/rt':
    owner   => root,
    group   => root,
    mode    => '0755',
    source  => 'puppet:///modules/rt/rt',
    require => Class['perl::rt'],
  }
  file {'/usr/local/bin/scan_domU.rb':
    owner   => root,
    group   => root,
    mode    => '0755',
    source  => 'puppet:///modules/rt/scan_domU.rb',
    require => File['/usr/local/bin/rt'],
  }
  file {'/usr/local/bin/assetscan.pl':
    ensure => absent,
  }

        $rtpasswd = decrypt('oHuDmymFcNjlXYXMuNUJDA==')

        file { '/etc/rtrc':
          mode    => '0664',
          owner   => root,
          group   => deploy,
          content => "user root\npasswd ${rtpasswd}",
        }
        
    # We can assume the spec of the server won't change more than once a day, if any
  cron {'update-asset-domU':
        user      => 'root',
        hour      => fqdn_rand('24'),
        minute    => fqdn_rand('60'),
    command       => '/usr/local/bin/scan_domU.rb > /var/log/scan_domU.log 2>&1',
    require       => File['/usr/local/bin/scan_domU.rb'],
  }
  # only run on CentOS dom0
    if ($::lsbdistid == 'CentOS') {
        if ($::virtual == 'xen0') {
            file {'/usr/local/bin/scan_dom0.sh':
                owner   => root,
                group   => root,
                mode    => '0755',
                source  => 'puppet:///modules/rt/scan_dom0.sh',
                require => File['/usr/local/bin/rt'],
            }
            # We can assume the spec of the server won't change more than once a day, if any
            cron {'update-asset-dom0':
                user    => 'root',
                hour    => fqdn_rand('24'),
                minute  => fqdn_rand('60'),
                command => '/usr/local/bin/scan_dom0.sh > /var/log/scan_dom0.log 2>&1',
                require => File['/usr/local/bin/scan_dom0.sh'],
        }
        }
    }
}
