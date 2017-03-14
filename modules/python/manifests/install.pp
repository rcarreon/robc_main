# Since we don't need to overwrite thing, we use includsion
# https://gist.github.com/309708
class python::install ($prefix = '/usr/local',$tmpdir = '/tmp',$pipversion = '1.0.2',$version = '2.6.5') {
    include python
        if $pythonversion != $version {
            Exec { path => '/usr/bin:/usr/sbin:/bin:/sbin' }
            file { [$prefix, $tmpdir]:
                ensure  => directory,
                owner   => 'root',
                group   => 'root',
                mode    => '0755',
            }

# This is for untar gzip file
            package { 'zlib-devel':
                ensure => installed,
            }
# This is for untar bz2 file
            package { 'bzip2-devel':
                ensure => installed,
            }

            package { ['openssl', 'openssl-devel']:
                ensure => installed,
            }

            package { 'gcc':
                ensure => installed,
            }

            exec { 'retrieve-distribute':
                command      => 'wget http://python-distribute.org/distribute_setup.py',
                cwd          => $tmpdir,
                require      => File[$prefix],
            }

            exec { 'retrieve-pip':
                command      => "wget --no-check-certificate https://pypi.python.org/packages/source/p/pip/pip-${pipversion}.tar.gz",
                cwd          => $tmpdir,
                require      => File[$prefix],
                notify       => Exec['extract-pip'],
            }

            exec { 'extract-pip':
                command      => "tar -zxf pip-${pipversion}.tar.gz",
                cwd          => $tmpdir,
                creates      => "${tmpdir}/pip-${pipversion}",
                require      => Exec['retrieve-pip'],
                subscribe    => Exec['retrieve-pip'],
            }

            source_install { "Python-${version}":
                prefix       => $prefix,
                tarball      => "http://python.org/ftp/python/${version}/Python-${version}.tgz",
                tmpdir       => $tmpdir,
                flags        => '--with-zlib=/usr/include --enable-shared --with-threads LDFLAGS=\"-Wl,--rpath /usr/local/lib\"',
                add_require  => Package['zlib-devel', 'bzip2-devel', 'openssl-devel', 'openssl', 'gcc'],
            }

            exec { "install-distribute-${version}":
                command  =>"${prefix}/bin/python ${tmpdir}/distribute_setup.py",
                cwd      => $tmpdir,
                require  => [
                                Exec['retrieve-distribute'],
                                Source_install["Python-${version}"]
                            ],
                before   => Exec["install-pip-${version}"],
            }

            exec { "install-pip-${version}":
                command      => "${prefix}/bin/python ${tmpdir}/pip-${pipversion}/setup.py install",
                cwd          => "${tmpdir}/pip-${pipversion}",
                creates      => "${prefix}/bin/pip",
                subscribe    => Exec['extract-pip'],
                require      => [
                                    Exec['extract-pip'],
                                    Source_install["Python-${version}"],
                                    Exec["install-distribute-${version}"]
                                ],
            }

            file {"/etc/ld.so.conf.d/python${version}.conf":
                owner        => root,
                group        => root,
                mode         => '0644',
                content      => "${prefix}/lib",
                require      => [
                                    Exec["install-distribute-${version}"],
                                    Exec["install-pip-${version}"],
                                ],
                subscribe    => Exec["install-distribute-${version}"],
            }

            exec { 'reload ldconfig':
                command      => '/sbin/ldconfig',
                refreshonly  => true,
                require      => [
                                    File["/etc/ld.so.conf.d/python${version}.conf"],
                                ],
                subscribe    => File["/etc/ld.so.conf.d/python${version}.conf"],
            }

        } # End of version check
}
