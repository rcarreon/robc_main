# Python class
define python::source_install($prefix, $tarball, $tmpdir='/tmp', $flags='', $add_require=[]) {
    $filename = regsubst($tarball, '.*\/((.*)(\.tar\.gz|\.tgz))','\1')
        exec { "retrieve-${name}":
            command => "wget ${tarball}",
            cwd     => $tmpdir,
            before  => Exec["extract-${name}"],
            notify  => Exec["extract-${name}"],
            onlyif  => "/usr/bin/test ! -e ${tmpdir}/${filename}",
            require => $add_require,
        }

    exec { "extract-${name}":
        command => "tar -zxf ${filename}",
        cwd     => $tmpdir,
        creates => "${tmpdir}/${name}/README",
        require => Exec["retrieve-${name}"],
        before  => Exec["configure-${name}"],
    }

    exec { "configure-${name}":
        cwd     => "${tmpdir}/${name}",
        command => "${tmpdir}/${name}/configure ${flags} --prefix=${prefix}",
        require => Exec["extract-${name}"],
        before  => Exec["make-${name}"],
    }

    exec { "make-${name}":
        cwd     => "${tmpdir}/${name}",
        command => 'make && make install',
        require => Exec["configure-${name}"],
    }
}
