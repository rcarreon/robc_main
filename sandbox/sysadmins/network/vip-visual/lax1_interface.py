#!/usr/bin/python
import dns.zone
from dns.exception import DNSException
from dns.rdataclass import *
from dns.rdatatype import *
from ciscoconfparse import *
from build_ip_tree_for_vlan import *
import Pyro.core

from Model_Buff import *

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

SILO, SERVERFARM = ('2', 2)

interface_keywords = {
"interface":0,
"ip address":1,
"access group":2,
"nat-pool":3,
"service-policy":4,
"no shutdown":5,
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
    m = instance = filename_rx.search(filename)
    instance_node = Session.query(Instance).filter_by(name=m.group(1)).first()

    for x in interface_lines:
        #print x
        # get single interface config
        single_interface_conf = CiscoConfParse(\
                interface_conf).find_all_children(x, exactmatch=True)
        node = Interface()
        node.alias = x.replace('interface ', '')
        # check ip and inservice
        if filename == "configs/10g.ace1.lax1.gnmedia.net":
            result = cmd.interface_status(node.alias.replace('vlan ',''),"10g.ace1.lax1.gnmedia.net")
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
                    m = natpool_rx.search(y)
                    if m != None:
                        print "----------------------------------------------"
                        print m.group(1), m.group(2), m.group(3)
                        output = m.group(3).split('.')
                        print "natpool-%03d." % int(output[3])
                    node.details.append(node_detail)


        # Assign interface type to the node
        type_node = Session.query(Types).filter_by(name="interface").first()
        node._types = type_node
        node._silo = silo_node
        node._instance = instance_node
        Session.add(node)
    Session.commit()

if __name__ == '__main__':
    loadconf("configs/admin.ace1.lax1.gnmedia.net")
    loadconf("configs/prod.ace1.lax1.gnmedia.net")
    loadconf("configs/sb.ace1.lax1.gnmedia.net")
    loadconf("configs/stage.ace1.lax1.gnmedia.net")
    loadconf("configs/10g.ace1.lax1.gnmedia.net")
