#!/bin/bash
#
# chkconfig: 345 90 10
# description: Hive Services
#
### BEGIN INIT INFO
# Provides:          hive-services
# Required-Start:    $remote_fs
# Should-Start:
# Required-Stop:     $remote_fs
# Should-Stop:
# Default-Start:     3 4 5
# Default-Stop:      0 1 2 6
# Short-Description: Hive Services
### END INIT INFO

. /etc/rc.d/init.d/functions
. /etc/profile.d/hive.sh
. /etc/profile.d/hadoop.sh

if [ "$HADOOP_PID_DIR" = "" ]; then
  HADOOP_PID_DIR=/tmp
fi

hive_pid=$HADOOP_PID_DIR/hiveserver.pid
metastore_pid=$HADOOP_PID_DIR/hive_metastore.pid
startStop=$1
HIVE_BIN="$HIVE_HOME/bin"

start() {
    [ -w "$HADOOP_PID_DIR" ] ||  mkdir -p "$HADOOP_PID_DIR"

    command='hive metastore server'
    if [ -f $metastore_pid ]; then
      if kill -0 `cat $metastore_pid` > /dev/null 2>&1; then
        echo $command running as process `cat $metastore_pid`.  Stop it first.
        exit 1
      fi
    fi

    echo starting $command...

    nohup /usr/bin/sudo -u hadoop -i ${HIVE_BIN}/hive --service metastore &

    echo $! > $metastore_pid
    sleep 3

    if ! ps -p `cat $metastore_pid` > /dev/null ; then
      exit 1
    fi

    command='hive server'
    if [ -f $hive_pid ]; then
      if kill -0 `cat $hive_pid` > /dev/null 2>&1; then
        echo $command running as process `cat $hive_pid`.  Stop it first.
        exit 1
      fi
    fi

    echo starting $command...

    nohup  /usr/bin/sudo -u hadoop -i ${HIVE_BIN}/hive --service hiveserver2 &

    echo $! > $hive_pid
    sleep 3

    if ! ps -p $! > /dev/null ; then
      exit 1
    fi
}

stop() {

    command='hive server'
    if [ -f $hive_pid ]; then
      TARGET_PID=`cat $hive_pid`
      if kill -0 $TARGET_PID > /dev/null 2>&1; then
        echo stopping $command
        kill $TARGET_PID
        sleep 2
        if kill -0 $TARGET_PID > /dev/null 2>&1; then
          echo "$command did not stop gracefully after 2 seconds: killing with kill -9"
          kill -9 $TARGET_PID
        fi
      else
        echo no $command to stop
      fi
      rm -f $hive_pid
    else
      echo no $command to stop
    fi

    command='hive metastore server'
    if [ -f $metastore_pid ]; then
      TARGET_PID=`cat $metastore_pid`
      if kill -0 $TARGET_PID > /dev/null 2>&1; then
        echo stopping $command
        kill $TARGET_PID
        sleep 2
        if kill -0 $TARGET_PID > /dev/null 2>&1; then
          echo "$command did not stop gracefully after 2 seconds: killing with kill -9"
          kill -9 $TARGET_PID
        fi
      else
        echo no $command to stop
      fi
      rm -f $metastore_pid
    else
      echo no $command to stop
    fi

}

checkstatus() {
  status -p $metastore_pid ${JAVA_HOME}/bin/java
  RETVAL=$?  
}
case $startStop in

  (start)
    start 
    ;;
          
  (stop)
    stop 
    ;;

  (restart)
    stop
    start
    ;;

  (status)
    checkstatus
    ;;
    
  (*)
    echo $"Usage: $0 {start|stop|status|restart}"
    exit 1
    ;;

esac
