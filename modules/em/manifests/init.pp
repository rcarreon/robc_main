class em {
  $em_database_username = "service_manager"
  $em_database_password = decrypt("pZLc3cGZ3MNNo68Ofd82AC5w0I9aiOFrqF+Ev7UMAZI=")
  $em_key = $fqdn_env ? {
    'prd'   => '1D11BAB00A8888D0',
    default   => 'C1EB734F82C8DBC4',
  }
  include em::package
  include em::service

  file { "/opt/mysql/enterprise/monitor/apache-tomcat/webapps/ROOT/WEB-INF/web.xml":
    source => "puppet:///modules/em/web.xml",
    mode   => "664",
    owner  => "root",
    group  => "root",
    require => Exec[mysqlmonitor_install],
    notify => Service[mysql-monitor-server],
  }
  file { "/opt/mysql/enterprise/monitor/apache-tomcat/webapps/ROOT/WEB-INF/urlrewrite.xml":
    source => "puppet:///modules/em/urlrewrite.xml",
    mode   => "664",
    owner  => "root",
    group  => "root",
    require => Exec[mysqlmonitor_install],
    notify => Service[mysql-monitor-server],
  }
  file { "/opt/mysql/enterprise/monitor/apache-tomcat/webapps/ROOT/WEB-INF/lib/urlrewrite-3.2.0.jar":
    source => "puppet:///modules/em/urlrewrite-3.2.0.jar",
    mode   => "664",
    owner  => "root",
    group  => "root",
    require => Exec[mysqlmonitor_install],
    notify => Service[mysql-monitor-server],
  }
  file { "/opt/mysql/enterprise/monitor/apache-tomcat/webapps/ROOT/graphall.html":
    source => "puppet:///modules/em/graphall.html",
    mode   => "664",
    owner  => "root",
    group  => "root",
    require => Exec[mysqlmonitor_install],
  }
  file { "/opt/mysql/enterprise/monitor/apache-tomcat/webapps/ROOT/game_over.png":
    source => "puppet:///modules/em/game_over.png",
    mode   => "664",
    owner  => "root",
    group  => "root",
    require => Exec[mysqlmonitor_install],
  }

  file {"/opt/mysql/enterprise/monitor/apache-tomcat/bin/setenv.sh":
    source => "puppet:///modules/em/setenv.sh",
    owner  => root,
    group  => root,
    mode   => "0644",
    require => Exec[mysqlmonitor_install],
    notify  => Service[mysql-monitor-server],
  }

  # db config file
  file { "/opt/mysql/enterprise/monitor/apache-tomcat/webapps/ROOT/WEB-INF/config.properties":
    content => template("em/config.properties.erb"),
    require => Exec[mysqlmonitor_install],
    notify => Service[mysql-monitor-server],
    owner  => root,
    group  => root,
    mode   => "0640",
  }
}
