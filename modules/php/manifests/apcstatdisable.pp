# puppet-lint made me do this
class php::apcstatdisable {
    file { '/etc/php.d/apcstatdisable.ini':
      ensure  => file,
      source  => 'puppet:///modules/php/apcstatdisable.ini',
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
    }
}
