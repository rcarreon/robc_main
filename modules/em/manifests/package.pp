class em::package {
  exec {"em_installer_download":
    command => "curl -o /var/tmp/mysqlmonitor-2.3.8.2124-linux-x86_64-installer.bin http://yum.gnmedia.net/puppet-binaries/mysqlmonitor-2.3.8.2124-linux-x86_64-installer.bin",
    path    => ["/usr/bin","/usr/local/bin", "/bin"],
    creates => "/var/tmp/mysqlmonitor-2.3.8.2124-linux-x86_64-installer.bin",
  }

  file {"/var/tmp/mysqlmonitor-2.3.8.2124-linux-x86_64-installer.bin":
    ensure => file,
    owner  => root,
    group  => root,
    mode   => "0755",
    require => Exec[em_installer_download],
  }

  # bring these variables in scope for the template (dynamic scoping fix)
  $em_database_username = $em::em_database_username
  $em_database_password = $em::em_database_password
  file {"/var/tmp/mysqlmonitor-options-file.txt":
    content => template("em/mysql-monitor-options-file.txt"),
    ensure  => file,
    owner   => root,
    group   => root,
    mode    => "0644",
  }
  
  exec {"mysqlmonitor_install":
    command => "/var/tmp/mysqlmonitor-2.3.8.2124-linux-x86_64-installer.bin --optionfile /var/tmp/mysqlmonitor-options-file.txt",
    path    => ["/usr/bin","/usr/local/bin", "/bin"],
    onlyif  => "test -S /var/lib/mysql/mysql.sock",
    creates => "/opt/mysql/enterprise/monitor/mysqlmonitorctl.sh",
    require => [File["/var/tmp/mysqlmonitor-2.3.8.2124-linux-x86_64-installer.bin"], File["/var/tmp/mysqlmonitor-options-file.txt"]],
  }

}
