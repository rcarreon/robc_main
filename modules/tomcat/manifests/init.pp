# Class: tomcat
# This module manages tomcat
#
# Sample Usage:
# - include tomcat

class tomcat {
    include tomcat::package, tomcat::service
}
