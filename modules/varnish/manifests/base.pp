# Varnish Installation Base

class varnish::base {
    # Safe default
    File {
        owner   => 'varnish',
        group   => 'varnish',
    }

        file {'/pxy':
                ensure  => directory,
                owner   => 'varnish',
                group   => 'varnish',
                mode    => '0755',
        }

        file {'/pxy/log':
                ensure  => directory,
                owner   => 'varnish',
                group   => 'varnish',
                mode    => '0755',
        }

        file {'/pxy/log/varnish':
                ensure  => directory,
                owner   => 'varnish',
                group   => 'varnish',
                mode    => '0755',
        }

    # Don't want to fight Varnish packager design choices
    # Let's live happily with the default location and symlink
    # (so we don't need to alter logrotate & varnishncsa init script)
    file {'/var/log/varnish':
        ensure => 'link',
        target => '/pxy/log/varnish',
        force  => true,
        backup => false,
    }

    # This holds the 'vsl' file, a binary log buffer that is constantly written
    file {'/var/lib/varnish':
        ensure => 'link',
        target => '/dev/shm',
        force  => true,
        backup => false,
    }
}
