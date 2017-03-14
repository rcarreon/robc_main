#!/usr/bin/env python

"""
    Nagios plugin to report Kestrel Queue's Waiting Items
"""

import urllib2
import sys
import optparse

try:
    import simplejson as json
except ImportError:
    import json

def optional_arg(arg_default):
    def func(option,opt_str,value,parser):
        if parser.rargs and not parser.rargs[0].startswith('-'):
            val=parser.rargs[0]
            parser.rargs.pop(0)
        else:
            val=arg_default
        setattr(parser.values,option.dest,val)
    return func

def main(argv):
    p = optparse.OptionParser(conflict_handler="resolve", description= "This Nagios plugin checks the health of kestrel.")

    p.add_option('-H', '--host', action='store', type='string', dest='host', default='127.0.0.1', help='The hostname you want to connect to')
    p.add_option('-P', '--port', action='store', type='int', dest='port', default=2223, help='The port kestrel is running on')
    p.add_option('-W', '--warning', action='store', type='float', dest='warning', default=None, help='The warning threshold we want to set')
    p.add_option('-C', '--critical', action='store', type='float', dest='critical', default=None, help='The critical threshold we want to set')
    p.add_option('-A', '--action', action='store', type='string', dest='action', default='connect', help='The action you want to take')
    options, arguments = p.parse_args()

    host = options.host
    port = options.port
    warning = options.warning
    critical = options.critical
    action = options.action
    url = '/admin/stats'

    monitor_item = { 'host': host,
                     'port': port,
                     'url': url,
                    }

    try:
        request = urllib2.Request('http://%(host)s:%(port)s%(url)s' % ( monitor_item))
        r = urllib2.urlopen(request)
        stats = json.loads(r.read())
    except Exception, e:
        print "CRITICAL - Unable to connect to kestrel admin port", e

    if action == "items":
        check_queue_items(stats, warning, critical)

def check_queue_items(stats, warning, critical):
    warning = warning or 200
    critical = critical or 400
    try:
        message = ""
        queue_dict = {}
        queue_found = None
        for key in stats['gauges']:
            if key.startswith('q/') and key.endswith('/items'):
                queue_dict[(key.split('/')[1])] = int(stats['gauges'][key])
                queue_found = True
        if queue_found is None:
            print "WARNING - No queue defined."
            sys.exit(1)
        status = "OK"
        for queue in queue_dict:
            message += "Queue %s has %d items waiting:" % (queue, queue_dict[queue])
            if queue_dict[queue] >= critical:
                status = "CRITICAL"
            elif queue_dict[queue] >= warning:
                if status != "CRITICAL":
                    status = "WARNING"
            else:
                if status != "CRITICAL" and status != "WARNING":
                    status = "OK"
        if status == "CRITICAL":
            print "CRITICAL - %s" % message
            sys.exit(2)

        elif status == "WARNING":
            print "WARNING - %s" % message
            sys.exit(1)
        else:
            print "OK - %s" % message
            sys.exit(0)
    except Exception, e:
        exit_with_general_critical(e)

def exit_with_general_critical(e):
    if isinstance(e, SystemExit):
        sys.exit(e)
    else:
        print "CRITICAL - General Kerstrel Error:", e
        sys.exit(2)
#
# main app
#
if __name__ == "__main__":
    main(sys.argv[1:])
