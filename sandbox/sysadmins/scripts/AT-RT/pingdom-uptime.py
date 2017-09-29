#!/usr/bin/env python

import urllib2
import pingdomapi, os, time
from optparse import OptionParser

try:
	import simplejson as json
except ImportError:
	import json

PINGDOM_AUTHFILE = 'auth.json'

def auth():
    """Initialize the connection to Pingdom"""
    if os.path.exists(PINGDOM_AUTHFILE):
        auth_data = json.loads(open(PINGDOM_AUTHFILE).read())
    try:
        return pingdomapi.Pingdom(username=auth_data['PINGDOM_USERNAME'],
                password=auth_data['PINGDOM_PASSWORD'],
                appkey=auth_data['PINGDOM_APPKEY'])
    except HTTPError, err:
        sys.stderr.write(str(err) + "\n")
        sys.exit(1)

def get_list(conn):
    """Get the list of IDs/Names we defined in Pingdom"""
    all_probes = {}
    for check in conn.method("checks")["checks"]:
        all_probes[check["id"]] = check["name"]
    return all_probes

def get_info(conn, siteid, fromDate):
	incUptime = "true"
	bycountry = "true"
	parameterDict = {}
	parameterDict['from'] = fromDate
	parameterDict['includeuptime'] = incUptime
	parameterDict['bycountry'] = bycountry
	response = conn.method('summary.average/%s' % siteid, parameters=parameterDict)
	if len(response['summary']['responsetime']['avgresponse']) > 0:
		avgResponseTime = response['summary']['responsetime']['avgresponse'][0]['avgresponse']
	else:
		avgResponseTime = "ERR"
	avgUptime = (float(response['summary']['status']['totalup'])/(float(response['summary']['status']['totalup'])+float(response['summary']['status']['totaldown'])))*100
	avgUptime = '%.8f' % avgUptime
	return (avgResponseTime, avgUptime)

def get_bu(site):
	osCmd = "/usr/local/bin/rt list -l -t asset \"Name = '%s'\"" % site
	a = os.popen(osCmd)
	b = a.readlines()
	if b == ['No matching results.\n']:
		return "No Business Unit"
	elif "CF.{BusinessUnit}:\n" in b:
		return "No Business Unit"
	for entry in b:
		if entry.strip().startswith("CF.{BusinessUnit}:"):
			return entry.strip().replace("CF.{BusinessUnit}: ", "")
	return "error %s" % b

currentTime = int(time.time())

usage = "usage: %prog [options]"
parser = OptionParser(usage=usage, version="%prog 0.1")
parser.add_option("-f", "--from", dest="fromDate", help="Get report as of: [epoch]. Defaults to current time", default=currentTime)
parser.add_option("-o", "--output", dest="outputFile", help="Full path of outputfile. Defaults to ./uptime.json", default="./uptime.json")
parser.add_option("-d", "--dateoutput", dest="dateFile", help="Full path of datefile. Defaults to ./date.json", default="./date.json")
(options, args) = parser.parse_args()

currentTime = int(options.fromDate)
outputFile = options.outputFile
dateFile = options.dateFile

finalDict = {}
dayAgo = currentTime-(((24*60)*60)*1)
weekAgo = currentTime-(((24*60)*60)*7)
monthAgo = currentTime-(((24*60)*60)*30)

pp_conn = auth()
id_name = get_list(pp_conn)
for entry in id_name:
	bu = get_bu(id_name[entry])
	if bu not in finalDict:
		finalDict[bu] = []
	finalDict[bu].append([id_name[entry], (get_info(pp_conn, entry, dayAgo)), (get_info(pp_conn, entry, weekAgo)), (get_info(pp_conn, entry, monthAgo)) ])

uptimeFileHandle = open(outputFile, 'w')
uptimeFileHandle.write(json.dumps(finalDict, indent=4))
uptimeFileHandle.close()
dateFileHandle = open(dateFile, 'w')
dateFileHandle.write(time.strftime("%b %d %Y @ %I:%M%p"))
dateFileHandle.close()
#print json.dumps(finalDict, indent=4)
