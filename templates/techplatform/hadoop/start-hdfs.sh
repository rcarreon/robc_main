#!/usr/bin/env bash

bin=`dirname "${BASH_SOURCE-$0}"`
bin=`cd "$bin"; pwd`
SERVER_NAME=`hostname`

DEFAULT_LIBEXEC_DIR="$bin"/../libexec
HADOOP_LIBEXEC_DIR=${HADOOP_LIBEXEC_DIR:-$DEFAULT_LIBEXEC_DIR}
. $HADOOP_LIBEXEC_DIR/hdfs-config.sh
. $HADOOP_LIBEXEC_DIR/yarn-config.sh

#---------------------------------------------------------
# quorumjournal nodes

SHARED_EDITS_DIR=$($HADOOP_PREFIX/bin/hdfs getconf -confKey dfs.namenode.shared.edits.dir 2>&-)

case "$SHARED_EDITS_DIR" in
qjournal://*)
  JOURNAL_NODES=$(echo "$SHARED_EDITS_DIR" | sed 's,qjournal://\([^/]*\)/.*,\1,g; s/;/ /g; s/:[0-9]*//g')
  if [ "${JOURNAL_NODES/$SERVER_NAME}" != "$JOURNAL_NODES" ];
  then
    "$HADOOP_PREFIX/sbin/hadoop-daemon.sh" \
        --config "$HADOOP_CONF_DIR" \
        --hostnames "$SERVER_NAME" \
        --script "$bin/hdfs" start journalnode 
  fi
;;
esac

#---------------------------------------------------------
# namenodes

NAMENODES=$($HADOOP_PREFIX/bin/hdfs getconf -namenodes)

if [ "${NAMENODES/$SERVER_NAME}" != "$NAMENODES" ];
then
# start namenode
  "$HADOOP_PREFIX/sbin/hadoop-daemon.sh" \
    --config "$HADOOP_CONF_DIR" \
    --hostnames "$SERVER_NAME" \
    --script "$bin/hdfs" start namenode 

# start zookeeper HA
  "$HADOOP_PREFIX/sbin/hadoop-daemon.sh" \
    --config "$HADOOP_CONF_DIR" \
    --hostnames "$SERVER_NAME" \
    --script "$bin/hdfs" start zkfc

# start resourceManager
  "$HADOOP_PREFIX/sbin/yarn-daemon.sh" --config $YARN_CONF_DIR --hosts "$SERVER_NAME" start resourcemanager

# start history server
  "$HADOOP_PREFIX/sbin/mr-jobhistory-daemon.sh" start historyserver

# start http rest file system service
  "$HADOOP_PREFIX/sbin/httpfs.sh" start 

fi

#---------------------------------------------------------
# datanodes (using default slaves file)
SLAVE_FILE=${HADOOP_SLAVES:-${HADOOP_CONF_DIR}/slaves}
SLAVE_NAMES=$(cat "$SLAVE_FILE" | sed  's/#.*$//;/^$/d')

for slave in $SLAVE_NAMES ; do
  if [ "$SERVER_NAME" == "$slave" ];
  then
# start datanode
    "$HADOOP_PREFIX/sbin/hadoop-daemon.sh" \
      --config "$HADOOP_CONF_DIR" \
      --hosts "$SERVER_NAME" \
      --script "$bin/hdfs" start datanode 

# start nodeManager
    "$HADOOP_PREFIX/sbin/yarn-daemon.sh" --config $YARN_CONF_DIR --hosts "$SERVER_NAME" start nodemanager

  fi
done
