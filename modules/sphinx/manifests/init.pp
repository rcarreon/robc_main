# Sphinx

class sphinx {
  include common::app

    group { 'sphinx':
        ensure    => 'present',
        gid       => '113',
    }

    user { 'sphinx':
        ensure    => 'present',
        password  => '!!',
        uid       => '113',
        gid       => '113',
        comment   => 'Sphinx Server',
        home      => '/var/lib/sphinx',
        shell     => '/sbin/nologin',
        require   => Group['sphinx'],
    }


  package { 'sphinx':
        ensure    => present,
        require   => [User[sphinx],Group[sphinx]]
  }

  service { 'searchd':
        ensure    => running,
        enable    => true,
        hasstatus => true,
        require   => [ Package[sphinx], File['/var/sphinx'] ],
  }

  file { '/app/sphinx':
        ensure    => directory,
        owner     => 'sphinx',
        group     => 'sphinx',
        mode      => '0755',
  }

  file { '/app/log/sphinx':
        ensure    => directory,
        owner     => 'sphinx',
        group     => 'sphinx',
        mode      => '0755',
        recurse   => true
  }

  file { '/var/sphinx':
        ensure    => directory,
        owner     => 'sphinx',
        group     => 'sphinx',
        mode      => '0755',
  }

}
