node 'app1v-wiki.tp.prd.lax.gnmedia.net' {
    include base
  $project="admin"

  include httpd
  include memcached
  #include php::wiki

  package {"php-ldap.x86_64":
    ensure => present,
  }

  httpd::virtual_host {"paste.gnmedia.net":}
  httpd::virtual_host {"docs.gnmedia.net": uri => '/wiki/Main_Page', expect => "Jabber",}

  class {"mysqld56": template=>"wiki.tp.prd.lax-standalone"}

  common::nfsmount { "/sql/binlog":
    device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_app1v_wiki_tp_prd_lax_binlog",
  }
  common::nfsmount { "/sql/data":
    device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_app1v_wiki_tp_prd_lax_data",
  }
  common::nfsmount { "/sql/log":
    device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_tp_lax_prd_sql_log/app1v-wiki.tp.prd.lax.gnmedia.net",
  }
  common::nfsmount { "/app/shared":
    device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_tp_lax_prd_app_shared/wiki-shared",
  }
  common::nfsmount { "/app/log":
    device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_tp_lax_prd_app_log/app1v-wiki.tp.prd.lax.gnmedia.net",
  }
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include newrelic::mysql
}
