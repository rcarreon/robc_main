function die {
  echo $1;
  exit 1;
}
echo "Scheduling Downtime in nagios"
HOSTNAME=app1v-noc.tp.prd.lax.gnmedia.net
NAGIOS_URL="https://nagios.prd.gnmedia.net/nagios/cgi-bin/cmd.cgi"
curl --silent --verbose --data cmd_typ=86 \
     --data cmd_mod=2 \
     --data host=$HOSTNAME \
     --data-urlencode "com_data=Migration to Peak" \
     --data trigger=0 \
     --data-urlencode "start_time=2015-02-10 09:05:00" \
     --data-urlencode "end_time=2015-02-10 09:06:00" \
     --data fixed=1 \
     --data btnSubmit=Commit \
     --insecure \
     $NAGIOS_URL -u "rcarreon:rOBERTALEX1" | grep -q "Your command request was successfully submitted to Nagios for processing." || die "Failed to contact nagios";
