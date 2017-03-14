# Class: tomcat-service
#
# This is the tomcat-service in the tomcat module.
#
class tomcat::service {
    if ($::lsbmajdistrelease == 5) {
        service { 'tomcat5':
            ensure  => running,
            enable  => true,
            pattern => '-Dcatalina.base=/usr/share/tomcat5',
            require => Class['tomcat::package'],
        }
    } else {
        service { 'tomcat6':
            ensure  => running,
            enable  => true,
            pattern => '-Dcatalina.base=/usr/share/tomcat6',
            require => Class['tomcat::package'],
        }

    }
}
