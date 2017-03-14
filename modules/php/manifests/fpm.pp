# this is generic, so just call the class, and we don't need to change anything on php-fpm config
# just make sure to make change on nginx or apache to send req to php-fpm port 9000
#
# to call it, php-fpm {'anything_here': $pkgname => php53u-fpm, } or php-fpm {'hooray': $pkgname => php58-fpm, }
# hopefully, we don't have to change this when we upgrade php, just call with a new pkg name

define php::fpm ($pkgname) {
    if $pkgname == '' {
      $pkgname = php53u-fpm
    }

    package { $pkgname:
        ensure  => present,
    }

    service {'php-fpm':
        ensure    => running,
        enable    => true,
        hasstatus => true,
        require   => Package[$pkgname],
    }

    file { '/app/log/php-fpm':
        ensure  => directory,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        require => Package[$pkgname];
    }

    file { '/etc/php-fpm.conf':
        ensure  => file,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        content => template("php/${pkgname}/php-fpm.conf.erb"),
        notify  => Service[php-fpm],
        require => Package[$pkgname];
    }

    file { '/etc/php-fpm.d/www.conf':
        ensure  => file,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        content => template("php/${pkgname}/www.conf.erb"),
        notify  => Service[php-fpm],
        require => Package[$pkgname];
    }

    file { '/etc/logrotate.d/php-fpm':
        ensure  => file,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        source  => "puppet:///modules/php/php-fpm/logrotate_${pkgname}",
        require => Package[$pkgname];
    }
}
