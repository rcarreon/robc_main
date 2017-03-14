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
        --script "$bin/hdfs" stop journalnode 
  fi
;;
esac

#---------------------------------------------------------
# namenodes

NAMENODES=$($HADOOP_PREFIX/bin/hdfs getconf -namenodes)

if [ "${NAMENODES/$SERVER_NAME}" != "$NAMENODES" ];
then
# stop namenode
  "$HADOOP_PREFIX/sbin/hadoop-daemon.sh" \
    --config "$HADOOP_CONF_DIR" \
    --hostnames "$SERVER_NAME" \
    --script "$bin/hdfs" stop namenode 

# stop zookeeper HA
  "$HADOOP_PREFIX/sbin/hadoop-daemon.sh" \
    --config "$HADOOP_CONF_DIR" \
    --hostnames "$SERVER_NAME" \
    --script "$bin/hdfs" stop zkfc

# stop history server
  "$HADOOP_PREFIX/sbin/mr-jobhistory-daemon.sh" stop historyserver

# stop resourceManager
  "$HADOOP_PREFIX/sbin/yarn-daemon.sh" --config $YARN_CONF_DIR --hosts "$SERVER_NAME" stop resourcemanager

# stop http rest file system service
  "$HADOOP_PREFIX/sbin/httpfs.sh" stop

fi

#---------------------------------------------------------
# datanodes (using default slaves file)
SLAVE_FILE=${HADOOP_SLAVES:-${HADOOP_CONF_DIR}/slaves}
SLAVE_NAMES=$(cat "$SLAVE_FILE" | sed  's/#.*$//;/^$/d')

for slave in $SLAVE_NAMES ; do
  if [ "$SERVER_NAME" == "$slave" ];
  then
# stop datanode
    "$HADOOP_PREFIX/sbin/hadoop-daemon.sh" \
      --config "$HADOOP_CONF_DIR" \
      --hosts "$SERVER_NAME" \
      --script "$bin/hdfs" stop datanode 

# stop nodeManager
    "$HADOOP_PREFIX/sbin/yarn-daemon.sh" --config $YARN_CONF_DIR --hosts "$SERVER_NAME" stop nodemanager

  fi
done
