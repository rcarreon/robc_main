#!/bin/bash 
echo "Demonio of varnish to redis starting up" >> /tmp/varnish2logstash
while true
do 
	varnishncsa -f| pipestash -t varnish_log_access -R logstash -r redis://vip-rds-logstashprd.tp.prd.lax.gnmedia.net:6379/0 
done
