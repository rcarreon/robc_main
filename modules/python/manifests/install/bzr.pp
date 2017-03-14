# python install bzr class
define python::install::bzr($ensure, $flags, $tmpdir = '/tmp') {
    case $ensure {
        installed: {
            exec {"Bzr branch ${name}":
                cwd          => $tmpdir,
                command      => "/usr/local/bin/bzr branch ${flags} lp:${name}" ,
                #refreshonly => true,
                #require     => [Package['git'],Exec['Symlink default to 2.6']],
                require      => [Package['bzr'], Class['python::install']],
                subscribe    => Class['python::install'],
                onlyif       => "/usr/bin/test ! -e ${tmpdir}/${name}"
            }

            exec {"Bzr Install ${name}":
                cwd         => "${tmpdir}/${name}",
                command     => '/usr/bin/python setup.py install',
                refreshonly => true,
                require     => Exec["Bzr branch ${name}"],
                subscribe   => Exec["Bzr branch ${name}"],
            }
        }
        default: {
            notify { 'python::install::bzr has no default ensure... is noop': }
        }
    }
}
