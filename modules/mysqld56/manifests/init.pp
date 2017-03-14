#
# Parameterized class to install mysqld56.
# $template names the my.cnf template.
# $sqlclass is 'supported', 'unsupported', or a default based on fqdn.
# If sqlclass is usupported, then $template is ignored.
#
class mysqld56($template='NOTSET',$sqlclass='default') {
    include yum::mysql5619
    include yum::mysql5627

    $version=56
    $mysqldatadir='/sql/data/mysql'

    include xinetd::vaquita_df
    include logrotate::mysql55
    include collectd::plugins::mysql

    $rootpass=decrypt("6XJQE0FYMxdunHboDKW95w==")
    $uidrootpass=decrypt("LQ+bJ6V8V22ILAEl1ZOmlA==")
    $logrotpass=decrypt("pF92iCE58Qx8HlZhPRa58g==")
    $uidlogrotpass=decrypt("OyIdcKvhGAaCB0AIs+EWsg==")

    #Install the next packages for the nagios check_mysqlroutines
    package { 'perl-DBD-MySQL': ensure => installed }
    package { 'perl-WWW-Curl': ensure => installed }

    file {"/sql/data":
        ensure => directory,
        owner => "mysql",
        group => "mysql",
        mode => "0755",
    }
    file {"/sql/log":
        ensure => directory,
        owner => "mysql",
        group => "mysql",
        mode => "0755",
    }
    file {"/sql/binlog":
        ensure => directory,
        owner => "mysql",
        group => "mysql",
        mode => "0755",
    }
    file {"/root/.puppet-mysqld56-module":
        ensure => file,
        content => "This VM uses the puppet mysql56 module, which needs support from the mysqld56-postboot script.\n",
        owner => "mysql",
        group => "mysql",
        mode => "0644",
    }
    file { '/usr/local/bin/mysqld56-postboot':
        ensure => present,
        owner  => 'root',
        group  => 'root',
        mode   => '0755',
        source => 'puppet:///modules/mysqld56/mysqld56-postboot',
    }

    nagios::service{'mysql':
        command   => 'check_mysql!read!me',
        use       => 'mysql-services',
        notes_url => 'http://docs.gnmedia.net/wiki/Nagios-mysql',
    }
    nagios::service{'mysqlstartupconf':
        command   => 'check_nrpe!check_mysqlstartupconf',
        use       => 'mysql-services',
        notes_url => 'http://docs.gnmedia.net/wiki/Nagios-mysqlstartupconf',
    }
    nagios::service{'mysqlerrorlog':
        command              => 'check_nrpe!check_mysqlerror',
        use                  => 'mysql-services',
        max_check_attempts   => '1',
        notification_options => 'w,u,c,s',
        notes_url            => 'http://docs.gnmedia.net/wiki/Nagios-mysqlerror',
    }
    nagios::service{'mysqlroutines':
        command   => 'check_nrpe!check_mysqlroutines',
        use       => 'mysql-services',
        notes_url => 'http://docs.gnmedia.net/wiki/Nagios-mysqlroutines',
    }

    if ($::architecture == 'x86_64') {
        $nagpluglibdir = 'lib64'
    } else {
        $nagpluglibdir = 'lib'
    }
    cron{'check_mysqlstartupconf':
        user    => 'root',
        minute  => '0',
        hour    => '*',
        command => "/usr/${nagpluglibdir}/nagios/plugins/check_mysqlstartupconf"
    }
    cron{'check_mysqlroutines':
        user    => 'root',
        minute  => '0',
        hour    => '*',
        command => "/usr/${nagpluglibdir}/nagios/plugins/check_mysqlroutines"
    }

    case $sqlclass {
        'supported': {$supported = true}
        'unsupported': {$supported = false}
        default: {if $::fqdn_role != 'uid' {$supported = true} else {$supported = false}}
    }

    # The password changes based on the hostname containing ^uid
    file{'/root/.my.cnf':
        ensure  => file,
        path    => '/root/.my.cnf',
        owner   => 'root',
        group   => 'root',
        mode    => '0640',
        content => template("mysqld${version}/my.cnf-root.erb"),
    }
    # The password changes based on the hostname containing ^uid
    file {'/root/.my.logrot.cnf':
        ensure  => file,
        path    => '/root/.my.logrot.cnf',
        owner   => 'root',
        group   => 'root',
        mode    => '0600',
        content => template("mysqld${version}/my.logrot.cnf-root.erb"),
    }

    sysctl::conf {'vm.swappiness': value => '1' }

    if $supported == true {
        # Box is Supp

        # grants
        #include mysqld::grants
        # backup
        include zmanda
        # monitoring stuff
        class { 'emagent': supported => $supported }

        # This file is different based on supp vs unsupp
        file { 'mysqld_config':
            ensure  => file,
            path    => '/etc/my.cnf',
            owner   => 'root',
            group   => 'root',
            mode    => '0644',
            content => template("mysqld/${version}/my.cnf-${template}.erb"),
        }

    }
    else {
        # Box is Unsupp
        file { 'mysqld_config':
            ensure   => present,
            path     => '/etc/my.cnf',
            owner    => 'root',
            group    => 'dba',
            mode     => '0664',
            replace  => false,
            content  => template("mysqld${version}/my.cnf-${version}-default-uid.erb"),
        }
    }
}

