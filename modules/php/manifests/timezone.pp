# php 53 something needs a default timezone set
# it cannot trust the system
class php::timezone {
    file { '/etc/php.d/timezone.ini':
      ensure  => file,
      source  => 'puppet:///modules/php/timezone.ini',
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
    }
}
