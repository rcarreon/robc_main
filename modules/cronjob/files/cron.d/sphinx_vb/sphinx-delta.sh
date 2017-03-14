#!/bin/sh

# $Id$
# $URL$

/usr/bin/indexer --config /etc/sphinx/sphinx-shh.conf --rotate postdelta threaddelta >> /var/log/sphinx/shh-index-delta.log 2>&1
/usr/bin/indexer --config /etc/sphinx/sphinx-sdn.conf --rotate postdelta threaddelta >> /var/log/sphinx/sdn-index-delta.log 2>&1
/usr/bin/indexer --config /etc/sphinx/sphinx-hfb.conf --rotate postdelta threaddelta >> /var/log/sphinx/hfb-index-delta.log 2>&1
/usr/bin/indexer --config /etc/sphinx/sphinx-bab.conf --rotate postdelta threaddelta >> /var/log/sphinx/bab-index-delta.log 2>&1
/usr/bin/indexer --config /etc/sphinx/sphinx-tfs.conf --rotate postdelta threaddelta >> /var/log/sphinx/tfs-index-delta.log 2>&1
/usr/bin/indexer --config /etc/sphinx/sphinx-wzf.conf --rotate postdelta threaddelta >> /var/log/sphinx/wzf-index-delta.log 2>&1
