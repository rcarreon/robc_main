# kibana vhost definition
# This is a test comment
define kibana::vhost ($elasticsearch_servers) {
    include kibana::docroot

    file {"/app/shared/docroots/${name}":
        ensure  => directory,
        owner   => 'deploy',
        group   => 'deploy',
        mode    => '0755',
        require => File["/app/shared/docroots"],
    }

    file {"/app/shared/docroots/${name}/releases":
        ensure  => directory,
        owner   => 'deploy',
        group   => 'deploy',
        mode    => '0755',
        require => File["/app/shared/docroots/${name}"],
    }

    file {"/app/shared/docroots/${name}/shared":
        ensure  => directory,
        owner   => 'deploy',
        group   => 'deploy',
        mode    => '0755',
        require => File["/app/shared/docroots/${name}"],
    }

    file {"/app/shared/docroots/${name}/config":
        ensure  => directory,
        owner   => 'root',
        group   => 'root',
        mode    => '0755',
        require => File["/app/shared/docroots/${name}"],
    }

    file {"/app/shared/docroots/${name}/config/KibanaConfig.rb":
        content => template('kibana/KibanaConfig.erb'),
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        require => File["/app/shared/docroots/${name}/config"],
    }

    httpd::virtual_host {$name: }
}
