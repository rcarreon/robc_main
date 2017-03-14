#!/bin/sh

# $Id$
# $URL$

/usr/bin/indexer --config /etc/sphinx/sphinx-shh.conf --rotate post thread >> /var/log/sphinx/shh-index-full.log 2>&1
/usr/bin/indexer --config /etc/sphinx/sphinx-sdn.conf --rotate post thread >> /var/log/sphinx/sdn-index-full.log 2>&1
/usr/bin/indexer --config /etc/sphinx/sphinx-hfb.conf --rotate post thread >> /var/log/sphinx/hfb-index-full.log 2>&1
/usr/bin/indexer --config /etc/sphinx/sphinx-bab.conf --rotate post thread >> /var/log/sphinx/bab-index-full.log 2>&1
/usr/bin/indexer --config /etc/sphinx/sphinx-tfs.conf --rotate post thread >> /var/log/sphinx/tfs-index-full.log 2>&1
/usr/bin/indexer --config /etc/sphinx/sphinx-wzf.conf --rotate post thread >> /var/log/sphinx/wzf-index-full.log 2>&1
