# Class: tomcat-package
#
# This is the tomcat-package in the tomcat module.

class tomcat::package {
    if ($::lsbmajdistrelease == 5) {
        package { ['tomcat5', 'xml-commons-apis', 'dejavu-lgc-fonts'] :
            ensure => installed
        }

        file { '/etc/tomcat5/server.xml':
            ensure => present,
            source => 'puppet:///modules/tomcat/server.xml',
            owner  => 'root',
            group  => 'root',
            mode   => '0644',
        }

    } else {

        package { ['tomcat6'] :
                ensure => installed
        }

        file { '/etc/tomcat6/server.xml':
            ensure => present,
            source => 'puppet:///modules/tomcat/server_tomcat6.xml',
            owner  => 'root',
            group  => 'root',
            mode   => '0644',
        }
    }
}
