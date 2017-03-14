# Class: statsd
#
# This module manages statsd
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class statsd {
  package { "statsd" :
    ensure  =>  installed,
  }

  file { "/etc/statsd/config.js" :
    ensure  => file,
    content  => template("statsd/$project/config.js.erb"),
    owner    => "root",
    group    => "root",
    mode     => "0644",
  }
  service { "statsd" : 
    ensure  => running,
  }
}
