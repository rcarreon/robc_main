# Class: emagent::package::disable
#
# This class disable mysql-monitor-agent package
#

class emagent::package::disable inherits emagent::package{
    Package['mysqlmonitoragent'] {
        ensure    => 'absent',
    }
}
