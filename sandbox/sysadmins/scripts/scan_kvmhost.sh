#!/bin/bash

# /install/custom/install/centos/metal.synclist drops this
# into /etc/cron.daily/ on the XCAT KVM baremetal machines

if test 0 != $(id -u);then
   echo "Run as root."
   exit 1
fi

if ! test -d /xcatpost;then
   echo "Run on xCAT-managed Dells"
   exit 1
fi

PATH=$PATH:/usr/local/bin

hostname=$(hostname)

asset=$(rt list -i -t asset "Name = '$hostname'")
cpu=`grep processor /proc/cpuinfo | wc -l`
#mem=`free -m | grep Mem: | awk '{ print $2 }'` # We lie to shoe-horn ourselves into the monthly report process
mem=2048
xenfreeram=`grep HugePages_Free /proc/meminfo  | awk '{print $2*2}'`
os=`lsb_release -i | awk '{ print $3 }'`
version=`lsb_release -r | awk '{ print $2 }'`
puppet=
description="xCAT KVM Master"
manufacturer="Dell"
    
rt edit ${asset} set Description="${description}" CF-Manufacturer=${manufacturer} CF-CPU=${cpu} CF-Memory=${mem} CF-OS=${os} CF-OSVersion=${version} CF-PuppetVersion=${puppet} CF-XenFreeRam=${xenfreeram}

