# add components needed by all uids
class adops::uid {

    include subversion::client
    include git::client
    include puppet_agent::uid

    # mysql community repo until it gets put into modules
    # TODO(sdejean): Get someone to place into modules
    file { '/etc/yum.repos.d/mysql-56-community.repo':
        ensure  => present,
        require => File['/etc/yum.repos.d'],
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
    }

    yumrepo { 'mysql-56-community':
        descr    => 'MySQL 5.6 Community Server - CentOS 6',
        baseurl  => 'http://yumoter.gnmedia.net/mysql-community-tools/6/wildwest/mysql-56-community/',
        gpgcheck => 0,
        enabled  => 0,
    }

    package {['tmux', 'libxml2-devel']: ensure => present }


    # memcached
    package { 'memcached': ensure => installed }
    service { 'memcached': ensure => running, enable => true }

    # rabbitmq
    package { 'rabbitmq-server': ensure => installed }
    service { 'rabbitmq-server': ensure => running, enable => true }
}
