#!/bin/bash

# gnvpn.sh

HOST="vpn.gorillanation.com"

VPNUSER="roberto.carreon"

REALM="Users"

PASS="Robertalex1"

CERT=${HOME}/.juniper_networks/vpn.cert

NCSVCBIN=${HOME}/.juniper_networks/network_connect/ncsvc

 

${NCSVCBIN} -h ${HOST} -u ${VPNUSER} -r ${REALM} -f ${CERT} -p ${PASS} -L 5

 


#EOF

