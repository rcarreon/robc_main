#!/usr/bin/python
# -*- coding: utf-8 -*-
from Model import *
from AT.Model import *
import socket
import re
import sys,getopt
import adns
import pydot
from sqlalchemy.sql import and_, or_
import argparse
import os,sys,codecs
from subprocess import Popen, PIPE
from threading import Thread
import types
from urlparse import urlparse
from build_ip_tree_for_vlan import *

Session = sessionmaker(bind=db, autoflush=True, autocommit=True)()
Session2 = sessionmaker(bind=db_locale)()  
Description = { 1:"In Service",
                0:"Out of Service",
              }
Description[None] = "Out of Service"

business_owner = {
"CraveOnline": "ao",
"GameRevolution": "ao",
"HFBoards": "ao",
"PebbleBed": "ao",
"TeenCrunch": "ao",
"TheFashionSpot": "ao",
"Sherdog": "ao",
"AdPlatform": "ap",
"SBVideo": "sbv",
"DoubleHelix": "si",
"SheKnows": "wuo",
"TechPlatform": "tp",
"Momtastic": "unk",
"CrowdIgnite": "unk",
}

vertical_map = {
"Tech Platform": "TechPlatform",
"Management": "mgm",
"XenMaster": "Xen",
"Double Helix": "dbx",
"Springboard Video": "Springboard_Video",
"Adops": "AdPlatform",
"Sheknows": "Sheknows",
"Atomic Online": "Atomic_Sites",
}

class testit(Thread):
   def __init__ (self,ip):
      Thread.__init__(self)
      self.ip = ip
      self.status = -1
   def run(self):
      pingaling = os.popen("ping -q -c2 "+self.ip,"r")
      while 1:
        line = pingaling.readline()
        if not line: break
        igot = re.findall(testit.lifeline,line)
        if igot:
           self.status = int(igot[0])

testit.lifeline = re.compile(r"(\d) received")
report = ("No response","Partial Response","Alive")

def extract(hostname,dns="Google DNS"):
    try:
        skip_mapping = 0
        ip = None
        response = "<br />"
        host_name = ""
        print "looking up ", hostname
        if dns == "Google DNS":
            dns_ip = "8.8.8.8"
        elif dns == "Internal DNS":
            dns_ip = "10.2.10.23"
        else:
            dns_ip = "10.2.10.23"
        if re.match('(?:[\d]{1,3})\.(?:[\d]{1,3})\.(?:[\d]{1,3})\.(?:[\d]{1,3})', hostname):
            ip_ext = Session.query(Ipmap).filter(\
                    Ipmap.in_ip == hostname).first()
            if ip_ext:
                skip_mapping = 0
                host_name = Session.query(Ipmap).filter(\
                        Ipmap.in_ip == hostname).first()
            else:
                skip_mapping = 1
                ip = Session.query(IP).filter(IP.address == hostname).first()
        # Could be CNAME
        else:
            s = adns.init(adns.iflags.noautosys, \
                    sys.__stderr__, "nameserver " + dns_ip)
            url = urlparse(hostname)
            if "http" in url.scheme:
                print 'url', url
                hostname = url.netloc
                print 'hostname 1', hostname
            else:
                hostname = url.path
                print 'hostname 2', hostname
            resolve = s.synchronous(url.hostname, adns.rr.A)
            print 'resolve', resolve
            if len(resolve[3]) == 0:
                if not re.match('(?:[\d]{1,3})\.(?:[\d]{1,3})\.(?:[\d]{1,3})\.(?:[\d]{1,3})', resolve[1]):
                    resolve = s.synchronous(resolve[1], adns.rr.A)
                    print 'Cname'
                else:
                    return "Domain doesn't exist."
            ext_ip = resolve[3][0]
            # Need to validate if it's External ip
            if re.match('(72)\.(172)\.(?:[\d]{1,3})\.(?:[\d]{1,3})', ext_ip):
                if dns == "Google DNS":
                    host_name = Session.query(Ipmap).filter(\
                            Ipmap.in_ip == ext_ip).first()
            else:
                print "internal IP"
                skip_mapping = 1
                ip = Session.query(IP).filter(\
                    IP.address == ext_ip).first()
                print ip
        if host_name != None and skip_mapping == 0:
            response += "EXT IP: %s <br /> INT IP: %s<br />" % \
                    (host_name.in_ip, host_name.out_ip)
            ip = Session.query(IP).filter(\
                    IP.address == host_name.out_ip).first()
        if ip != None:
            print ip.address
            for x in ip.device:
                print "found device"
                #response += x._getself_html()
                response += x._gettree(0, True)

        #os.system('/var/www/html/vip-visual/cli_query.py %s'% hostname)
        return response

    except Exception, err:
        return(str(err))

def ping_retired():
    pinglist = []
    command = "rt list -l -t asset \"Type = \'Servers\' AND Status = \'retired\'\"|grep Name:" 
    run = Popen(command, shell=True,
                stdout=PIPE, stderr=PIPE) 
    for host in run.stdout.readlines():
       ip = host.strip().replace("Name: ","")
       current = testit(ip)
       pinglist.append(current)
       current.start()
    
    #print '------------------------------------------ pinglist',pinglist
    for pingle in pinglist:
       pingle.join()
       if pingle.status == -1:
           print "Status from " + pingle.ip + " is " + "unable to resolve dns"
       else:
           print "Status from " + pingle.ip + " is " + report[pingle.status]

    return
    
def getxen(vm_name):
      response = ""
      current_asset = Session2.query(AT_Asset).filter(AT_Asset.Name==vm_name).first()
      if current_asset != None:
         if current_asset.assoc != None:
           if current_asset.parent:
               response += "%s\n"%(current_asset.parent.get_Name())
               if current_asset.parent.field_values:
                    last_terminal = ""
                    for term in current_asset.parent.field_values:
                        # 27 is Console
                        if term.CustomField == 27:
                            ssh_terminal = term.Content
                            if "ssh" in ssh_terminal:
                                last_terminal = "%s\n" % ssh_terminal
                    response += last_terminal

      return response

def getdetail(tag_number):
      response = ""
      current_value = Session2.query(Object_Custom_Field_Values).filter(and_(Object_Custom_Field_Values.CustomField==23,Object_Custom_Field_Values.Content==tag_number)).first()
      response += "%s\n"%current_value.asset.Name
      for x in current_value.asset.field_values:
         # 27 is Console
         if x.CustomField == 28:
              response += "Serial Number :%s\n"% x.Content
         elif x.CustomField == 30:
              response += "Rack Number :%s\n"% x.Content
         elif x.CustomField == 31:
              response += "Rack Position :%s\n"% x.Content
      return response
     
def getvm(xen_name):
      response = ""
      current_asset = Session2.query(AT_Asset).filter(AT_Asset.Name==xen_name).first()
      if current_asset != None:
           last_terminal = ""
           for term in current_asset.field_values:
               # 27 is Console
               if term.CustomField == 27:
                   ssh_terminal = term.Content
                   if "ssh" in ssh_terminal:
                       last_terminal = "%s\n" % ssh_terminal
                   response += last_terminal
           #if current_asset.assoc != None:
           if current_asset.children:
               for x in current_asset.children:
                   response += "%s\n"%(x.get_Name())
      return response
     
def searchip(hostname):
    if re.match('(?:[\d]{1,3})\.(?:[\d]{1,3})\.(?:[\d]{1,3})\.(?:[\d]{1,3})', hostname):
         ip = hostname
    else:
         s = adns.init(adns.iflags.noautosys,sys.stderr, "nameserver " + "10.2.10.23")
         resolve = s.synchronous(hostname, adns.rr.A)
         if len(resolve[3]) == 0:
             return -1
         else:
             ip = resolve[3][0]
    ip = Session.query(IP).filter(IP.address==ip).first()
    if ip and len(ip.device) != 0:
       if ip.device[0].alias == "place holder":
          return 0
       else:
          return 1
    else:
       return 0

def owner_getsite(owner):
    response = []
    command = "rt list -l -t asset \"Type = \'Site\' AND Status != \'retired\' AND \'CF.{BusinessOwner}\' LIKE \'%s\'\"" % owner
    run = Popen(command, shell=True,
                stdout=PIPE, stderr=PIPE) 
    for x in run.stdout.readlines():
        if "Name:" in x.strip():
            response.append(x.strip().replace("Name: ",""))
    return response

def run_command(cmd, hostname):
    cmd = " ".join(cmd)
    command = "/usr/local/bin/pssh -i -H \"%s\" \"%s\"" % (hostname, cmd)
    run = Popen(command, shell=True,
                stdout=PIPE, stderr=PIPE) 
    return run.stdout.readlines()

def getshmux(hostname=None, dns="Google DNS"):
    response=""
    try:
        skip_mapping = 0
        ip = None
        host_name = ""
        if dns == "Google DNS":
            dns_ip = "8.8.8.8"
        elif dns == "Internal DNS":
            dns_ip = "10.2.10.23"
        else:
            dns_ip = "10.2.10.23"
        if re.match('(?:[\d]{1,3})\.(?:[\d]{1,3})\.(?:[\d]{1,3})\.(?:[\d]{1,3})', hostname):
            ip_ext = Session.query(Ipmap).filter(\
                    Ipmap.in_ip == hostname).first()
            if ip_ext:
                skip_mapping = 0
                host_name = Session.query(Ipmap).filter(\
                        Ipmap.in_ip == hostname).first()
            else:
                skip_mapping = 1
                ip = Session.query(IP).filter(IP.address == hostname).first()
        else:
            s = adns.init(adns.iflags.noautosys, \
                    sys.__stderr__, "nameserver " + dns_ip)
            url = urlparse(hostname)
            if "http" in url.scheme:
                hostname = url.netloc
            else:
                hostname = url.path
            resolve = s.synchronous(hostname, adns.rr.A)
            if len(resolve[3]) == 0:
                if not re.match('(?:[\d]{1,3})\.(?:[\d]{1,3})\.(?:[\d]{1,3})\.(?:[\d]{1,3})', resolve[1]):
                    resolve = s.synchronous(resolve[1], adns.rr.A)
                else:
                    return "Domain doesn't exist."
            ext_ip = resolve[3][0]
            if re.match('(72)\.(172)\.(?:[\d]{1,3})\.(?:[\d]{1,3})', ext_ip):
                if dns == "Google DNS":
                    host_name = Session.query(Ipmap).filter(\
                            Ipmap.in_ip == ext_ip).first()
            else:
                print "internal IP"
                skip_mapping = 1
                ip = Session.query(IP).filter(\
                    IP.address == ext_ip).first()
        if host_name != None and skip_mapping == 0:
            ip = Session.query(IP).filter(\
                    IP.address == host_name.out_ip).first()
        rserver_dict = {}
        app_vip_dict = {}
        sql_vip_dict = {}
        sfarm_dict = {}
        if ip != None:
            for device_node in ip.device:
                #import pdb; pdb.set_trace()
                for x in device_node.breadth_first(device_node.children):
                    if x.getType().name == "rserver":
                        # Need to consider what if it doesn't have a hostname "Blank"
                        if x.getHostname():
                            # TODO, need to consider multiple parent situation
                            rserver_dict[x.getHostname()]=x.get_status(x.parent[0],html=False)
                    elif x.getType().name == "appvip":
                        if x.alias:
                            app_vip_dict[x.alias]=[x.silo, x._instance, x.ips[0]]
                    elif x.getType().name == "sqlvip":
                        if x.alias:
                            sql_vip_dict[x.alias]=[x.silo, x._instance, x.ips[0]]
                    elif x.getType().name == "serverfarm":
                        if x.alias:
                            sfarm_dict[x.alias]=[x.silo, x._instance]
                            
        return rserver_dict, app_vip_dict, sql_vip_dict, sfarm_dict

    except Exception, err:
        return(str(err))

DNS_ALIASES = {
    'google':'Google DNS',
    'internal':'Internal DNS', 
}

#import dis
#dis.disassemble(getshmux.func_code)

def main():
    parser = argparse.ArgumentParser(description='Vipvisual CLI query')
    parser.add_argument('-H', '--host', action="store", dest="hostname", \
            help='Show Infrastrucure of a Hostname')
    parser.add_argument('-x', '--xen', action="store", dest="xen", \
            help='Find xen server')
    parser.add_argument('-c', '--vms', action="store", dest="vms", \
            help='Find VMs in a XenServer')
    parser.add_argument('-G', '--graph', action="store", dest="dot_graph",\
            help='Generate DOT Graph for the Architecture')
    parser.add_argument('-d', '--dns', action="store", dest="dns",\
            choices=DNS_ALIASES, \
            default='google', \
            help='Specify which DNS to use for query')
    parser.add_argument('-s', '--ip', action="store", dest="ip",\
            help='Find an IP in server tree')
    parser.add_argument('-ipv', '--iptovlan', action="store", dest="ipv",\
            help='Find the VLAN for a IP/Hostname')
    parser.add_argument('-t', '--tag', action="store", metavar="NUMBER", \
            dest="tag",\
            help='Find Service Related Info based on Tag NUMBER')
    parser.add_argument('-dc', '--decom', action="store", \
            dest="dservers",\
            help='Show Decom command to remove a VIP')
    parser.add_argument('-g', '--servers', action="store", \
            dest="servers",\
            help='Find all servers (APP/SQL) by domain')
    parser.add_argument('-vip', '--vip', action="store_true", \
            default=False,\
            help='Find all vips (APP/SQL) by domain')
    parser.add_argument('-sf', '--serverfarm', action="store_true", \
            default=False,\
            help='Find all serverfarm by domain')
    parser.add_argument('-r', '--run', nargs = '+', action="store", metavar="COMMAND", \
            dest="run",\
            help='Run command on the result server list, please add \\\\ to -')
    parser.add_argument('-SS', '--status', action="store_true", \
            default=False,\
            help='Show Server Status (Based on VIP Setup)')
    parser.add_argument('-b', '--business', action="store", \
            dest="owner",\
            help="Show All Site of a Particular Business Owner : %s" % (" ".join(business_owner.keys())))
    parser.add_argument('-BA', '--business_all', action="store_true", \
            default=False,\
            help='Show a list of servers that belongs to a Particular Business Owner')
    parser.add_argument('-pr', '--ping_retired', action="store_true", \
            default=False,\
            help='Ping All Retired Servers')

    options = parser.parse_args(sys.argv[1:])
    if not len(sys.argv[1:]):
            var = raw_input("Website : ")
            print extract(var)
            sys.exit(0)

    if options.ping_retired:
       ping_retired()
       sys.exit(0)
    if options.ipv:
       output = get_vlan(options.ipv)
       for x in output:
           if x in vertical_map.keys():
               print vertical_map[x]
           else:
               print x
       sys.exit(0)
    if options.hostname:
       print extract(options.hostname)
    if options.xen:
       print getxen(options.xen)
    if options.tag:
       print getdetail(options.tag)
    if options.tag:
       print getdetail(options.tag)
    if options.vms:
       print getvm(options.vms)
    if options.ip:
       return_value = searchip(options.ip)
       if return_value == -1:
           print "Domain not found"
           sys.exit(-1)
       #elif return_value == 1:
       elif return_value == 1:
           print "IP Found"
           sys.exit(0)
       else:
           print "IP not Found"
           sys.exit(1)
       sys.exit(0)
    if options.owner:
       if options.business_all:
           for site_name in owner_getsite(options.owner):
               print "========== Site Name: %s ========" % site_name
               rs_dict, appv_dict, sqlv_dict, sf_dict = getshmux(site_name, dns=DNS_ALIASES[options.dns])
               # verify result is dictionary
               if isinstance(rs_dict, types.DictType):
                   keys = rs_dict.items()
                   keys.sort()
                   for server, status in keys:
                       if '-inv' not in server:
                           if options.status == True:
                               print server, rs_dict[server]
                           else:
                               print server
               else:
                   pass

       else:
           for x in owner_getsite(options.owner):
               print x

    if options.dservers:
       rs_dict, appv_dict, sqlv_dict, sf_dict = getshmux(options.servers, dns=DNS_ALIASES[options.dns])
       sys.exit(0)

    if options.servers:
       rs_dict, appv_dict, sqlv_dict, sf_dict = getshmux(options.servers, dns=DNS_ALIASES[options.dns])
       if options.vip == True:
           if isinstance(appv_dict, types.DictType):
               keys = appv_dict.items()
               keys.sort()
               for server, location in keys:
                   if '-INV' not in server:
                       print server, location[0], location[1], location[2].address, get_vlan(location[2].address)
           if isinstance(sqlv_dict, types.DictType):
               keys = sqlv_dict.items()
               keys.sort()
               for server, location in keys:
                   if '-INV' not in server:
                       print server, location[0], location[1], location[2].address, get_vlan(location[2].address)
       if options.serverfarm == True:
           if isinstance(sf_dict, types.DictType):
               keys = sf_dict.items()
               keys.sort()
               for server, location in keys:
                   if '-INV' not in server:
                       print server, location[0], location[1]
       else:
           # verify result is dictionary
           if isinstance(rs_dict, types.DictType):
               keys = rs_dict.items()
               keys.sort()
               for server, status in keys:
                   if '-inv' not in server:
                       if options.status == True:
                           print server, rs_dict[server]
                       else:
                           if options.run:
                               for result in run_command(options.run,server):
                                   if "(RSA) to the list of known hosts" in result:
                                       pass
                                   else:
                                       print result.strip()
                           else:
                               print server
       sys.exit(0)
if __name__ == '__main__':
    main()
