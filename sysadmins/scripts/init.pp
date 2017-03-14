import "*.pp"

class mysql::client {
    define version ($version="51") {
        case $version {
            "50":{
                package {"mysql":
                    ensure => present,
                }
            }
            "51":{
                include yum::mysql
                #FIXME:: HINT:: ARRAY
                package {"MySQL-client-community":
                    ensure => present,
                    require => Class["yum::mysql"],
                }
                package {"MySQL-shared-compat":
                    ensure => present,
                    require => Class["yum::mysql"],
                }
            }
        }
    }
}

class mysql::server {
    include mysql::server_base

    # install
    define install ($mysqldatadir="/sql/data/mysql", $version="51") {
        case $version {
            "50":{
                file{"/etc/yum.repos.d/CentOS-mysql.repo": ensure => absent }
                $package="mysql-server"
            }
            "51":{
                $package="MySQL-server-community"
            }
        }
        # install server package
        package{"$package":
            ensure  => present,
            require => File["mysql_log_dir","mysql_data_dir","mysql_binlog_dir","/etc/yum.repos.d/CentOS-mysql.repo"],
        }
        file{"mysql_config":
            path    => "/etc/my.cnf",
            ensure  => file,
            owner   => root,
            group   => root,
            mode    => 644,
            content => template("mysql/my.cnf-$name.erb"),
            require  => Package["$package"],
        }
        case $version {
            "51":{
                file {"/etc/init.d/mysqld":
                    source  => "puppet:///mysql/init-mysql",
                    ensure  => file,
                    require => Package["MySQL-server-community"],
                }
                # mysql 5.1 installs its service as mysql instead of mysqld
                # this causes a problem for monit, who looks for mysqld
                # rather than manage two monit configs we will fix the service
                exec {"fix-mysql-service":
                    command => "/sbin/chkconfig --del mysql && /sbin/chkconfig --add mysqld",
                    unless  => "/sbin/chkconfig --list mysqld",
                    require => File["/etc/init.d/mysqld"],
                }
            }
        }
        # service
        service {"mysqld":
            enable    => true,
            hasstatus => true,
            require   => Package["$package"],
        }
    }
}

class mysql::server_base {
    # create folders
    file{"mysql_base_dir":
        path   => "/sql",
        ensure => directory,
        owner  => root,
        group  => root,
    }
    file{"mysql_log_dir":
        path    => "/sql/log",
        ensure  => directory,
        owner   => mysql,
        group   => mysql,
        require => File["mysql_base_dir"],
    }
    file{"mysql_data_dir":
        path   => "/sql/data",
        ensure => directory,
        owner  => mysql,
        group  => mysql,
        require => File["mysql_base_dir"],
    }
    file{"mysql_binlog_dir":
        path   => "/sql/binlog",
        ensure => directory,
        owner  => mysql,
        group  => mysql,
        require => File["mysql_base_dir"],
    }
    file{"mysql_pid_dir":
        path   => "/var/run/mysqld",
        ensure => directory,
        owner  => mysql,
        group  => mysql,
    }

    # monitoring stuff
    include mysql::agent20
    include monit::mysql
    nagios::service{"mysql": command => "check_mysql!read!me"}
    #FIXME:: HINT:: include munin::mysql
    include munin::client
    file{"/etc/munin/plugins/mysql_bytes":
        ensure  => "/usr/share/munin/plugins/mysql_bytes",
        require => Package["munin-node"],
        notify  => Service["munin-node"],
    }
    file{"/etc/munin/plugins/mysql_queries":
        ensure => "/usr/share/munin/plugins/mysql_queries",
        require => Package["munin-node"],
        notify => Service["munin-node"],
    }
    file{"/etc/munin/plugins/mysql_slowqueries":
        ensure => "/usr/share/munin/plugins/mysql_slowqueries",
        require => Package["munin-node"],
        notify => Service["munin-node"],
    }
    file{"/etc/munin/plugins/mysql_threads":
        ensure => "/usr/share/munin/plugins/mysql_threads",
        require => Package["munin-node"],
        notify => Service["munin-node"],
    }
    #FIXME:: HINT:: include logrotate::mysql
    include logrotate
    file{"logrotate-mysql":
        path    => "/etc/logrotate.d/mysql",
        ensure  => file,
        owner   => root,
        group   => root,
        mode    => 644,
        content => template("mysql/logrotate.erb"),
        require => Package["logrotate"],
    }

    # snapshot scripts
    package{"expect":
        ensure => present,
    }
    file{"/root/.ssh/id_rsa":
        owner  => root,
        group  => root,
        mode   => 600,
        source => "puppet:///mysql/snap-id_rsa",
    }
    file{"/root/.ssh/id_rsa.pub":
        owner  => root,
        group  => root,
        mode   => 644,
        source => "puppet:///mysql/snap-id_rsa.pub",
    }
    file{"/usr/local/bin/snap.sh":
        owner  => root,
        group  => root,
        mode   => 700,
        source => "puppet:///mysql/snap.sh",
    }
    file{"/usr/local/bin/snap.exp":
        owner  => root,
        group  => root,
        mode   => 700,
        source => "puppet:///mysql/snap.exp",
    }
    cron{"nightly_snapshot":
        user    => root,
        ensure  => present,
        hour    => 0,
        minute  => 0,
        command => "/usr/bin/expect /usr/local/bin/snap.exp > /usr/local/bin/snap.log 2>&1"
    }
    file{"root-my-cnf":
        path    => "/root/.my.cnf",
        ensure  => file,
        owner   => root,
        group   => root,
        mode    => 640,
        content => template("mysql/my.cnf-root.erb"),
    }
}

class mysql::server::v50{
    define install(){
        include mysql::client::v50
        include mysql::server
        mysql::server::install{ $name: version => "50"}
    }
}

class mysql::server::v51{
    define install(){
        include mysql::client::v51
        include mysql::server
        mysql::server::install{ $name: version => "51"}
    }
}

class mysql::client::v50{
    mysql::client::version{"50": version => "50",}
}

class mysql::client::v51 {
    mysql::client::version{"51": version => "51",}
}
