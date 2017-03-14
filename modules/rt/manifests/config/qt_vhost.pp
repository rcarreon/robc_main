# qt_vhost
define rt::config::qt_vhost($pass = 'secret') {
    file{'/etc/httpd/conf.d/qt.conf':
          content => template('rt/qt.conf.erb'),
          require => Package[httpd],
          notify  => Service[httpd],
          owner   => 'root',
          group   => 'root',
          mode    => '0644',
    }
}
