# This class defines members of the hadoop cluster and their properties
class hadoop {
  $members = {
    'namenodes' => [
      'app2v-hadoop-bd.tp.prd.lax.gnmedia.net',
      'app1v-hadoop-bd.tp.prd.lax.gnmedia.net',
    ],
    'datanodes' => [
      'app3v-hadoop-bd.tp.prd.lax.gnmedia.net',
      'app4v-hadoop-bd.tp.prd.lax.gnmedia.net',
      'app5v-hadoop-bd.tp.prd.lax.gnmedia.net',
    ],
    'zookeeper' => [
      'app1v-zookeeper-bd.tp.prd.lax.gnmedia.net',
      'app2v-zookeeper-bd.tp.prd.lax.gnmedia.net',
      'app3v-zookeeper-bd.tp.prd.lax.gnmedia.net',
    ],
    'journalnode' => [
      'app3v-hadoop-bd.tp.prd.lax.gnmedia.net',
      'app4v-hadoop-bd.tp.prd.lax.gnmedia.net',
      'app5v-hadoop-bd.tp.prd.lax.gnmedia.net',
    ],
  }

  $hadoop_cluster_nameservices = 'zootpprd'
  $hadoop_data_dir = '/app/data/hadoop'
  $hadoop_conf_dir = '/etc/hadoop'
  $hadoop_log_dir = '/app/log/hadoop'
  $hadoop_tmp_dir = '/app/data/tmp'

  file { '/var/run/hadoop':
    ensure  => directory,
    owner   => 'hadoop',
    group   => 'hadoop',
    mode    => '0775',
  }

  # files/directories
  file { '/app/data/hadoop':
    ensure  => directory,
    owner   => 'hadoop',
    group   => 'hadoop',
    mode    => '0755',
    require => File['/app/data'],
  }

  file { '/app/log/hadoop':
    ensure  => directory,
    owner   => 'hadoop',
    group   => 'hadoop',
    mode    => '0775',
    require => File['/app/log'],
  }

  file { '/app/data/tmp':
    ensure  => directory,
    owner   => hadoop,
    group   => hadoop,
    mode    => '0644',
  }

}
