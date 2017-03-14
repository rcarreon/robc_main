# Class elasticsearch::install

class elasticsearch::install {
    # set up the user
    user { 'elasticsearch':
        ensure   => 'present',
        password => '!!',
        uid      => '117',
        gid      => '117',
        comment  => 'elasticsearch daemon',
        home     => '/usr/share/java/elasticsearch',
        shell    => '/sbin/nologin',
        require  => [Group['elasticsearch']],
    }

    # set up the group
    group { 'elasticsearch':
        ensure   => 'present',
        gid      => '117',
    }

    # install the package
    include yum::gnrepo
    package { 'elasticsearch':
        ensure   => installed,
        require  => [Class['yum::gnrepo'], User['elasticsearch'], Group['elasticsearch']],
    }

    # set up the limits.conf so ES can have a BUNCH of open files
    file {'/etc/security/limits.d/elasticsearch.conf':
        owner    => 'root',
        group    => 'root',
        mode     => '0644',
        content  => template('elasticsearch/limits.conf.erb'),
    }

    # install paramedic plugin
    exec {'install_plugin_paramedic':
      command    => '/usr/share/java/elasticsearch/bin/plugin -install karmi/elasticsearch-paramedic',
      creates    => '/usr/share/java/elasticsearch/plugins/paramedic/_site',
    }

}
