#!/bin/sh
#
# Put custom values for JAVA_HOME, JRE_HOME and JAVA_OPTS here.
# This file and your edits are preserved during upgrade.
#
# Do NOT put custom values for those parameters in catalina.sh
# because they will be lost when upgrading.

export CATALINA_OPTS="-Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.port=9010 -Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.authenticate=false"
JAVA_HOME=/opt/mysql/enterprise/monitor/java
JRE_HOME=/opt/mysql/enterprise/monitor/java
JAVA_OPTS="-Xmx2048M -Xms1024M -Xss512M -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=/opt/mysql/enterprise/monitor/apache-tomcat/temp -XX:+UseParallelOldGC"
export JAVA_HOME
export JRE_HOME
export JAVA_OPTS
umask 066
unset DISPLAY

