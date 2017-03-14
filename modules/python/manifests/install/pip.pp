# python install pip class
define python::install::pip($ensure, $version = undef, $prefix = '/usr/local', $add_require = []) {
    case $ensure {
        present: {
            $require_append = [Class['python::install'],$add_require]
            exec { "pip-install-${name}":
                command  => "${prefix}/bin/pip install ${name}",
                timeout  => '-1',
                require  => $require_append,
                unless   => "${prefix}/bin/pip freeze | grep -q ${name}==",
                # require => Class["python::install"],
            }
        }
        default: {
            notify{ 'there is no default python::pip... it does nothing.' : }
        }
    }
}
