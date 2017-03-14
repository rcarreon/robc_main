# Shared sphinx configs

define sphinx::multiple_sphinx_config($sql_host='',$sql_user='',$sql_pass='',$sql_prefix='',$sql_db='',$port='') {
        include sphinx::multiple_sphinx_install

        file { "/sphinx/${name}":
            ensure    => directory,
            owner     => sphinx,
            group     => sphinx,
            mode      => '0664',
            require   => Class['sphinx::multiple_sphinx_install'],
        }

        service {"searchd-${name}":
            ensure    => running,
            enable    => true,
            hasstatus => true,
            require   => File["/etc/sphinx/sphinx-${name}.conf"],
        }

        file { "/etc/sphinx/sphinx-${name}.conf":
            content   => template("sphinx/multiconf/${project}_multiconf_template.erb"),
            require   => File["/sphinx/${name}"],
            #notify   => Service[searchd],
            owner     => 'root',
            group     => 'root',
            mode      => '0644',
        }

        # for init prog name
        exec { "symlink-searchd-${name}":
            command   => "/bin/ln -s /usr/bin/searchd /usr/bin/searchd-${name}",
            unless    => "/usr/bin/test -L /usr/bin/searchd-${name}",
            require   => File["/etc/sphinx/sphinx-${name}.conf"],
        }

        file { "/etc/init.d/searchd-${name}":
            content   => template('sphinx/multiconf/multiconf_init.erb'),
            mode      => '0755',
            require   => [ File["/etc/sphinx/sphinx-${name}.conf"],Exec["symlink-searchd-${name}"] ],
            #notify   => Service[searchd],
            owner     => 'root',
            group     => 'root',
        }


        # for big post and thread tables, it might take 30 mins or upto an hour to do full index. this will timeout on puppet, so just run cmd below manually.
        exec { "indexer-${name}":
            path      => '/usr/bin:/bin',
            command   => "test -f /sphinx/${name}/sphinx.stopwords || /usr/bin/indexer --config /etc/sphinx/sphinx-${name}.conf post thread >> /var/log/sphinx/${name}-index-full.log;/usr/bin/indexer --config /etc/sphinx/sphinx-${name}.conf postdelta threaddelta >> /var/log/sphinx/${name}-index-delta.log;touch /sphinx/${name}/sphinx.stopwords",
            require   => File["/etc/sphinx/sphinx-${name}.conf"],
        }

}

