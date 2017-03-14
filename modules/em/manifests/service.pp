class em::service {
  service {"mysql-monitor-server":
    require => Exec[mysqlmonitor_install],
  }
}
