# Sphinx config

  # $reindex=true, $span='3' by default, where
  # $span should be an integer.  sphinx will
  # reindex every $span hours.  $reindex => false,
  # if reindexing is intended to be done manually.
  define sphinx::conf($reindex=true, $ensure='present', $span='3') {
    include sphinx

    file { '/etc/sphinx/sphinx.conf':
      content   => template("sphinx/$project/${name}.conf.erb"),
      notify    => Service[searchd],
      owner     => 'root',
      group     => 'root',
      mode      => '0644',
    }

    if ! $reindex == false {
      cron { $name:
        ensure  => $ensure,
        command => '/usr/bin/indexer --config /etc/sphinx/sphinx.conf --all --rotate --quiet > /dev/null 2>&1',
        user    => root,
        minute  => '0',
        hour    => "*/${span}"
      }
    }
  }
