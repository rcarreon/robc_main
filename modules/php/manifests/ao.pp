# puppet-lint made me do this
class php::ao inherits php {
    file { '/etc/php.ini':
      ensure    => file,
      owner     => 'root',
      group     => 'root',
      mode      => '0644',
      content   => template('php/adops/php.ini-ao.erb'),
      notify    => Service[httpd],
      require   => Package['httpd'];
    }

    package { 'php-pear-Net_GeoIP':
        ensure => installed;
    }
}
