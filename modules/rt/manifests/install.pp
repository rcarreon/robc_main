# install class for RT
class rt::install {
  include httpd

      file { '/etc/rt3':
          ensure       => directory,
          mode         => '0755',
                owner  => 'root',
                group  => 'root',
      }

        # symlink for rt

        file {'/etc/smrsh/rt-mailgate':
                ensure => link,
                target => '/usr/sbin/rt-mailgate',
        }

  package{'rt3':
    ensure => present,
  }
  package{'perl-HTML-Template':
    ensure => present
  }
  package{'perl-DBD-MySQL':
    ensure => present
  }
  package{'perl-DBD-Pg':
    ensure => present
  }
  package{'perl-LDAP':
    ensure => present
  }
  package{'perl-RT-Authen-ExternalAuth':
    ensure => present
  }
  package{'perl-RT-Extension-CommandByMail':
    ensure => present
  }
  package{'perl-RTx-AssetTracker':
    ensure => present
  }
  package{'perl-RT-Extension-MenubarSearches':
    ensure => present
  }
}
