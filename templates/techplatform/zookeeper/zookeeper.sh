#!/bin/bash

export JAVA_HOME=/usr/java/default
export ZOOKEEPER_HOME=/opt/zookeeper
export ZOOBINDIR=${ZOOKEEPER_HOME}/bin
export ZOOCFGDIR=/etc/zookeeper
export ZOO_DATADIR=/app/data/zookeeper
export ZOO_LOG_DIR=/app/log/zookeeper
export ZOO_LOG4J_PROP='WARN,ROLLINGFILE'
export CLASSPATH=.:${CLASSPATH}:${ZOOKEEPER_HOME}/lib
export PATH=${PATH}:${ZOOKEEPER_HOME}/bin
