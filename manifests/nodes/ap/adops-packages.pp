# common packages for all adops systems
class adops::common {
    #include subversion::client
    include httpd
    include common::app
    # include git::client

    # moved to ap::cron::gp
    # freetds is a set of libraries that allow your programs to natively talk
    # to Microsoft SQL Server
    #file {'/etc/freetds.conf':
    #    ensure  => file,
    #    content => template('adops/freetds.conf.erb'),
    #    owner   => 'root',
    #    group   => 'root',
    #}
}

# packages for passenger
class adops::mod_passenger {
    class { 'passenger::params':
        passenger_version => '3.0.17'
    }
    include passenger
    file { '/etc/httpd/conf.d/passenger-adops.conf':
        ensure  => file,
        content => template('httpd/adops/passenger-adops.conf.erb'),
        owner   => 'root',
        group   => 'root',
        require => Class['httpd'],
    }
}

# packages for adops
class adops::packages {
    include adops::common
    include rubygems

    package { ['rubygem-bundler', 'ruby-libs', 'ftp', 'ruby-mysql']:
        ensure => installed,
    }
}

# packages for adops
class adops::build {
    include adops::common
    include rubygems

    package {
      [
        'gcc',
        'gcc-c++',
        'apr-devel',
        'apr-util-devel',
        'bison',
        'c-ares19-devel',
        'cmake',
        'cyrus-sasl-devel',
        'db4-devel',
        'expat-devel',
        'fakeroot',
        'gdbm-devel',
        'glibc-devel',
        'httpd-devel',
        'http-parser-devel',
        'keyutils-libs-devel',
        'krb5-devel',
        'libcom_err-devel',
        'libcurl-devel',
        'libffi-devel',
        'libidn-devel',
        'libselinux-devel',
        'libsepol-devel',
        'libstdc++-devel',
        'libuv-devel',
        'mod_ssl',
        'mysql-devel',
        'ncurses-devel',
        'openldap-devel',
        'openssl-devel',
        'patchutils',
        'perl-devel',
        'readline-devel',
        'rpm-build',
        'sqlite-devel',
        'v8-devel',
        'zlib-devel'
      ]:
        ensure => installed,
    }
}

# packages for adops v3 (aka pubops)
class adops::packages::v3 {
    include adops::common
    include php::adops
}
