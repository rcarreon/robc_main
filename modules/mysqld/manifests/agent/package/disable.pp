# Class: mysqld::agent::package::disable
#
# This class disable mysql-monitor-agent package
#

class mysqld::agent::package::disable inherits mysqld::agent::package{
    Package['mysqlmonitoragent'] {
        ensure    => 'absent',
    }
}
