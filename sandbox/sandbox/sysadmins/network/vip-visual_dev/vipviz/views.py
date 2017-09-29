import logging
import re
import adns
import sys
import pydot
import types
import os
from pyramid.view import view_config
from urlparse import urlparse

from paste.deploy.loadwsgi import appconfig
from settings import *

from .models import (
    DBSession,
    Device,
    Ipmap,
    IP,
    )

log = logging.getLogger(__name__)
strm_out = logging.StreamHandler(sys.__stdout__)
log.addHandler(strm_out)


#@view_config(route_name='home', renderer='templates/mytemplate.pt')
#def my_view(request):
#    one = DBSession.query(Device).filter(Device.alias == 'APP1V-PHP1_LAX1').first()
#    return {'one': one.alias, 'project': 'VipViz'}


@view_config(route_name='query', renderer='templates/query.pt')
def query_view(request):
    one = DBSession.query(Device).filter(Device.alias == 'APP1V-PHP1_LAX1').first()
    return {'one': one.alias, 'title': 'VipViz-Query'}


@view_config(route_name='ip_lookup', renderer='templates/ip_lookup.pt')
def ip_lookup(request):
    response = {}
    response['title'] = config['title']
    response['external'] = ""
    response['internal'] = ""
    response['error'] = ""
    response['tree'] = ""
    response['dot'] = ""
    response['rservers'] = ""
    hostname = request.params['domain']
    """  Check wether Domain or IP is provided """
    # Validate it is a domain name not IP
    if not re.match('(?:[\d]{1,3})\.(?:[\d]{1,3})\.(?:[\d]{1,3})\.(?:[\d]{1,3})', hostname):
        """ Use Google DNS to do the query if not specified """
        if 'dns' in request.params:
            dns = request.params['dns']
        else:
            dns = "Google DNS"
        host_name = ""
        log.info('Lookup %s' % hostname)
        if dns == "Google DNS":
            dns_ip = "8.8.8.8"
            log.info('Use Google DNS')
        elif dns == "Internal DNS":
            dns_ip = "10.2.10.23"
            log.info('Use Internal DNS')
        else:
            dns_ip = dns
            log.info('Use Custom DNS Server')
        s = adns.init(adns.iflags.noautosys, \
                sys.__stdout__, "nameserver %s" % dns_ip)
        url = urlparse(hostname)

        """ Remove HTTP:// from query string """

        if "http" in url.scheme:
            hostname = url.netloc
            log.info('HTTP URL - hostname %s', (hostname))
        else:
            hostname = url.path
            log.info('Non HTTP URL - hostname %s', (hostname))
        log.info('hostname %s', hostname)
        resolve = s.synchronous(hostname, adns.rr.A)
        log.info('resolved entry %s', resolve)
        # If IP can not be found
        if len(resolve[3]) == 0:
            if resolve[1] != None:
                if not re.match('(?:[\d]{1,3})\.(?:[\d]{1,3})\.(?:[\d]{1,3})\.(?:[\d]{1,3})', resolve[1]):
                    resolve = s.synchronous(resolve[1], adns.rr.A)
                    log.info('record entry is CNAME')
                else:
                    log.info('Domain not found.')
                    response['error'] = 'Domain not found'
                    return response
            else:
                log.info('Domain not found.')
                response['error'] = 'Domain not found'
                return response
        ext_ip = resolve[3][0]
        # Need to validate if it's Gorilla's External ip
        if re.match('(72)\.(172)\.(?:[\d]{1,3})\.(?:[\d]{1,3})', ext_ip):
            log.info("DNS Server: %s, External IP: %s" % (dns, ext_ip))
            try:
                int_ip = DBSession.query(Ipmap).filter(\
                            Ipmap.in_ip == ext_ip).first()
                host_name = int_ip
                log.info("Hostname: %s" % (host_name))
                response["external"] = ext_ip
                response['internal'] = host_name.out_ip
            except Exception, err:
                log.error("Unable to get Internal IP mapping for %s, error %s" % (ext_ip, str(err)))
        else:
            # Not Our Domain
            log.info('Unable to find it in our IP Range')
            response['error'] = 'I wish we host it'
    # Only IP is Provided
    else:
        # Try to find EXT-INT IP Mapping
        ip_map_obj = DBSession.query(Ipmap).filter(\
                Ipmap.in_ip == hostname).first()
        if ip_map_obj:
            ext_ip = ip_map_obj.out_ip
            log.info("External/Internal IP mapping is Found")
            response["external"] = ip_map_obj.in_ip
            response["internal"] = ip_map_obj.out_ip
            log.info('External IP: %s, Internal IP %s' % (ip_map_obj.in_ip, ip_map_obj.out_ip))
            return response
        else:
            # Internal IP perhaps
            ip_obj = DBSession.query(IP).filter(IP.address == hostname).first()
            if ip_obj:
                ext_ip = ip_obj.address
                response["internal"] = ext_ip
            else:
            # Not Found in IP existing IP
                response['error'] = 'IP Address can not be found in FWSM/ACE'
                return response

    return response


@view_config(route_name='extract_server', renderer='templates/extractServer.pt')
def extract_server(request):
    response = {}
    response['tree'] = ""
    response['dot'] = ""
    response['error'] = ""
    response['title'] = config['title']
    response['external'] = ""
    response['internal'] = ""
    response['rservers'] = ""
    ip_response = ip_lookup(request)
    if ip_response['error'] != "":
        return ip_response
    if ip_response['internal'] != "":
        response['internal'] = ip_response['internal']
        response['external'] = ip_response['external']
        ip = DBSession.query(IP).filter(\
                IP.address == ip_response['internal']).first()
        if ip != None:
            for device_node in ip.device:
                rserver_dict = {}
                #import pdb; pdb.set_trace()
                for x in device_node.breadth_first(device_node.children):
                    log.info("Device Node : %s " % x.alias)
                    if x.getType().name == "rserver":
                        # Need to consider what if it doesn't have a hostname "Blank"
                        if x.getHostname() and len(x.parent):
                            # TODO, need to consider multiple parent situation
                            log.info(rserver_dict)
                            rserver_dict[x.getHostname()] = x.get_status(x.parent[0], html=False)
                if isinstance(rserver_dict, types.DictType):
                    keys = rserver_dict.items()
                    keys.sort()
                    for server, status in keys:
                        if '-inv' not in server:
                           response['rservers'] += '<br /> %s' % server
                log.info("rservers results %s" % rserver_dict)
            relation_dict = {}
            if not len(response['error']):
                # TODO: relation_dict could be removed since it gets initialized
                # in the function
                response['tree'] = device_node._getdottree(0, True, relation_dict)
                infile = open("%s/images/test.dot" % config['ugc_directory'], "w")
                infile.write(response['tree'] + '}')
                infile.close()
                os.system('/usr/bin/dot -Tpng %s/images/test.dot -o %s/images/test.png -Tcmapx -o %s/images/test.map' %
                        (config['ugc_directory'],config['ugc_directory'],config['ugc_directory']))
                #graph = pydot.graph_from_dot_file('%s/images/test.dot' % config['ugc_directory'])
                #graph.write_png('%s/images/test.png' % config['ugc_directory'])
                #graph.write_cmapx('%s/images/test.cmap' % config['ugc_directory'])
                cmapfile = open('%s/images/test.cmap' % config['ugc_directory'])
                response['dot'] = cmapfile.read().replace('\\n', '  ') + \
                        '<img border="0" align="bottom" src="http://dev.vipvisual.gnmedia.net/images/test.png" usemap="#viviz_idx">'
                response['tree'] = device_node._gethtmltree(0, True)
    else:
        response['error'] = "Something went wrong, please check the log"
    return response
