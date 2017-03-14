#!/bin/bash
# Starts Hadoop Cluster
#
# chkconfig: 345 90 10
# description: Hadoop Cluster
#
### BEGIN INIT INFO
# Provides:          hadoop-cluster
# Required-Start:    $remote_fs
# Should-Start:
# Required-Stop:     $remote_fs
# Should-Stop:
# Default-Start:     3 4 5
# Default-Stop:      0 1 2 6
# Short-Description: Hadoop Cluster
### END INIT INFO

. /lib/lsb/init-functions

IS_HADOOP_HOME_SET=`env | grep HADOOP_HOME`

if [ -e ${IS_HADOOP_HOME_SET} ]; then
  . /etc/profile.d/hadoop.sh
fi

STATUS_RUNNING=0
STATUS_DEAD=1
STATUS_DEAD_AND_LOCK=2
STATUS_NOT_RUNNING=3
ERROR_PROGRAM_NOT_INSTALLED=5

HADOOP_LOCK_DIR="/var/lock/subsys/"
LOCKFILE="${HADOOP_LOCK_DIR}/evolve_origin_zoo"
desc="Hadoop Cluster Daemon"
EXEC_PATH="${HADOOP_HOME}/sbin"
CLUSTER_PID_FILE=${HADOOP_PID_DIR}/hadoop_cluster.pid

HADOOP_SHUTDOWN_TIMEOUT=${HADOOP_SHUTDOWN_TIMEOUT:-60}

start() {
  [ -x $exec ] || exit $ERROR_PROGRAM_NOT_INSTALLED

  pidofproc -p $CLUSTER_PID_FILE java > /dev/null
  status=$?
  if [ "$status" -eq "$STATUS_RUNNING" ]; then
    exit 0
  fi

  log_success_msg "Starting $desc : "
  /bin/su -s /bin/bash -c "/bin/bash -c 'echo \$\$ > ${CLUSTER_PID_FILE} && exec ${EXEC_PATH}/start-hdfs.sh 2>&1 ' " hadoop
  RETVAL=$?
  [ $RETVAL -eq 0 ] && touch $LOCKFILE
  return $RETVAL
}

stop() {
  if [ ! -e $CLUSTER_PID_FILE ]; then
    log_failure_msg "Hadoop Cluster is not running"
    exit 0
  fi

  log_success_msg "Stopping $desc: "

  CLUSTER_PID=`cat $CLUSTER_PID_FILE`
  if [ -n $CLUSTER_PID ]; then

    /bin/su -s /bin/bash -c "/bin/bash -c 'exec ${EXEC_PATH}/stop-hdfs.sh 2>&1 ' " hadoop
    RETVAL=$?

    [ $RETVAL -eq 0 ] && rm -f $LOCKFILE $CLUSTER_PID_FILE
  fi
  
  return $RETVAL
}

restart() {
  stop
  start
}

checkstatus(){
  pidofproc -p $CLUSTER_PID_FILE java > /dev/null
  status=$?

  case "$status" in
    $STATUS_RUNNING)
      log_success_msg "Hadoop Cluster is running"
      ;;
    $STATUS_DEAD)
      log_failure_msg "Hadoop Cluster is dead and pid file exists"
      ;;
    $STATUS_DEAD_AND_LOCK)
      log_failure_msg "Hadoop Cluster is dead and lock file exists"
      ;;
    $STATUS_NOT_RUNNING)
      log_failure_msg "Hadoop Cluster is not running"
      ;;
    *)
      log_failure_msg "Hadoop Cluster status is unknown"
      ;;
  esac
  return $status
}

condrestart(){
  [ -e ${LOCKFILE} ] && restart || :
}

case "$1" in
  start)
    start
    ;;
  stop)
    stop
    ;;
  status)
    checkstatus
    ;;
  restart)
    restart
    ;;
  condrestart|try-restart)
    condrestart
    ;;
  *)
    echo $"Usage: $0 {start|stop|status|restart|try-restart|condrestart}"
    exit 1
esac

exit $RETVAL