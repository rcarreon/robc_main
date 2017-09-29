#!/usr/bin/python
import dns.zone
from dns.exception import DNSException
from dns.rdataclass import *
from dns.rdatatype import *
from ciscoconfparse import *
from build_ip_tree_for_vlan import *
import Pyro.core
from build_ip_tree_for_vlan import *

from Model_Buff import *

SILO = ('3')
Session = sessionmaker(bind=db)()

rserver_str = r"""^rserver host (.*?)$"""
rserver_rx = re.compile(rserver_str)
filename_str = r"""^configs/(.*?)\."""
filename_rx = re.compile(filename_str)
ip_address_str = r"""ip address (.*?)$"""
ip_address_rx = re.compile(ip_address_str)
serverfarm_str = r"""^    (serverfarm|sticky-serverfarm) (.*?)( |$)"""
serverfarm_rx = re.compile(serverfarm_str)
sec_serverfarm_str = r"""^  (serverfarm|sticky-serverfarm) (.*?)( |$)"""
sec_serverfarm_rx = re.compile(sec_serverfarm_str)
serverfarm_rserver_str = r"""^  rserver (.*?)$"""
serverfarm_rserver_rx = re.compile(serverfarm_rserver_str)
sticky_str = r"""^sticky .* (.*?)$"""
sticky_rx = re.compile(sticky_str)
virtual_address_str = r"""  [0-9] match virtual-address (.*?) tcp eq (.*?)$"""
virtual_address_str_rx = re.compile(virtual_address_str)
digit_str = r""" (\d+)"""
digit_rx = re.compile(digit_str)
natpool_str = r"""nat-pool (\d+) (\d+.\d+.\d+.\d+) (\d+.\d+.\d+.\d+) netmask (\d+.\d+.\d+.\d+) pat"""
natpool_rx = re.compile(natpool_str)
intip_str = r"""ip address (\d+.\d+.\d+.\d+) (\d+.\d+.\d+.\d+)"""
intip_rx = re.compile(intip_str)
fname_str = r"""(\w+).(\w+).(\w+).*"""
fname_rx = re.compile(fname_str)
ip_str = r"""(\d+).(\d+).(\d+).(\d+)"""
ip_rx = re.compile(ip_str)

interface_keywords = {
"interface":0,
"ip address":1,
"access group":2,
"nat-pool":3,
"service-policy":4,
"no shutdown":5,
}

vertical_map = {
"Tech Platform": "tp",
"Management": "mgm",
"XenMaster": "xen",
"Double Helix": "dbx",
"Springboard Video": "sbv",
"Adops": "ap",
"Sheknows": "wuo",
"Atomic Online": "ao",
}

cmd = Pyro.core.getProxyForURI("PYROLOC://10.11.20.28:8889/remote")

def striplist(l):
    return([x.strip() for x in l])

def loadconf(filename):
    parse = CiscoConfParse(filename)
    # Start parsing VIP lines
    # Try to pull out all rservers IP first
    interface_conf = parse.find_all_children("^interface")
    interface_lines = CiscoConfParse(interface_conf).find_lines("^interface")
    status = 0
    silo_node = Session.query(Silo).filter_by(silo_id=SILO).first()
    no_path_filename = filename.replace("configs/","")
    m = fname_rx.search(no_path_filename)
    if m != None:
        context = m.group(1)
        loc = m.group(3)
    instance_node = Session.query(Instance).filter_by(name=m.group(1)).first()

    for x in interface_lines:
        #print x
        # get single interface config
        single_interface_conf = CiscoConfParse(\
                interface_conf).find_all_children(x, exactmatch=True)
        node = Interface()
        node.alias = x.replace('interface ', '')
        # check ip and inservice
        result = cmd.interface_status(node.alias.replace('vlan ',''),no_path_filename)
        if len(result) > 0:
            if result[0][1] == "up":
                print "it's up"
                node.status = 1
            else:
                print "it's down"
                node.status = 0
        print striplist(single_interface_conf)
        for y in single_interface_conf:
            for key in interface_keywords.keys():
                if key in y:
                    node_detail = Detail()
                    node_detail.name = key
                    node_detail.parameters = y.replace(key,'').strip()
                    n = intip_rx.search(y)
                    #interface IP
                    if n != None:
                        print "----------------------------------------------"
                        print n.group(1)
                        ip = n.group(1)
                        output = get_vlan(ip)
                        print "int-%s.%s.%s.gnmedia.net %s" % (output[0],context,loc,ip)
                    # natpool
                    m = natpool_rx.search(y)
                    if m != None:
                        nat_ip1, nat_ip2 = m.group(2), m.group(3)
                        index = m.group(1)
                        print 'nat_ip1 :%s , nat_ip2 %s' % (nat_ip1, nat_ip2)
                        if nat_ip1 == nat_ip2:
                            print "----------------------------------------------"
                            print m.group(1), m.group(2), m.group(3)
                            ip = m.group(3)
                            output = get_vlan(ip)
                            print "natpool-%s-%04d.%s.%s.gnmedia.net %s" % (str(index), int(output[0].replace('vlan','')), context, loc, ip)
                        # If it pool
                        else:
                            ip_m = ip_rx.search(nat_ip1)
                            if ip_m != None:
                                print ip_m.groups()
                                ip1_fd = int(ip_m.group(1))
                                ip1_sd = int(ip_m.group(2))
                                ip1_td = int(ip_m.group(3))
                                ip1_octal = int(ip_m.group(4)) 
                            ip_m = ip_rx.search(nat_ip2)
                            if ip_m != None:
                                print 'ip2', nat_ip2
                                ip2_octal = int(ip_m.group(4))
                            #for multiple IPs
                            for x in range(1, (ip2_octal - ip1_octal + 1)):
                                target_ip = "%d.%d.%d.%d" % (ip1_fd, ip1_sd, ip1_td, ip1_octal+x)
                                print "natpool-%s-%04d-%d.%s.%s.gnmedia.net %s" % (str(index), int(output[0].replace('vlan','')), x, context, loc, target_ip)
                        node.details.append(node_detail)


        # Assign interface type to the node
        type_node = Session.query(Types).filter_by(name="interface").first()
        node._types = type_node
        node._silo = silo_node
        node._instance = instance_node
        Session.add(node)
    Session.commit()

if __name__ == '__main__':
    loadconf("configs/admin.ace1.lax2.gnmedia.net")
    loadconf("configs/prod.ace1.lax2.gnmedia.net")
    loadconf("configs/sb.ace1.lax2.gnmedia.net")
    loadconf("configs/stage.ace1.lax2.gnmedia.net")
