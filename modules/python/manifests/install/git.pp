# python install git class
define python::install::git($ensure, $url, $tmpdir = '/tmp') {
    case $ensure {
        installed: {
            exec {"Git Clone ${name}":
                command       => "/usr/bin/git clone ${url} ${name}" ,
                cwd           => $tmpdir,
                # refreshonly => true,
                # require     => [Package["git"],Exec["Symlink default to 2.6"]],
                require       => [Package['git'], Class['python::install']],
                subscribe     => Class['python::install'],
                onlyif        => "/usr/bin/test ! -e ${tmpdir}/${name}"
            }

            exec {"Git Install ${name}":
                cwd                => "${tmpdir}/${name}",
                command            => '/usr/bin/python setup.py install',
                refreshonly        => true,
                require            => Exec["Git Clone ${name}"],
                subscribe          => Exec["Git Clone ${name}"],
            }
        }
        default: {
            notify{ 'there is no default python::git... it does nothing.' : }
        }
    }
}
