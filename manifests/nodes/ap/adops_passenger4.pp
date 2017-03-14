# use passenger 4.x from /app/software
class adops::passenger4 {

  file { '/etc/httpd/conf.d/ap_passenger_4.conf':
    ensure  => file,
    content => template('adops/ap_passenger_4.conf.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }

}
