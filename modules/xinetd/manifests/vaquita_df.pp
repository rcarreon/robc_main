class xinetd::vaquita_df {

    include xinetd

  file  { '/etc/xinetd.d/rvaquita-df':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    source  => 'puppet:///modules/xinetd/rvaquita-df.xinet',
    notify => Service['xinetd'],
  }
  file  { '/usr/libexec/vaquita-df':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    source  => 'puppet:///modules/xinetd/vaquita-df',
  }
}
