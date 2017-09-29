#!/usr/bin/python
import dns.zone
import re
from dns.exception import DNSException
from dns.rdataclass import *
from dns.rdatatype import *
from Model_Buff import *

Session = sessionmaker(bind=db)()
ip_list = Session.query(IP).all()
type_node = Session.query(Types).filter_by(name="rserver").first()
for x in ip_list:
    print x.address
    if len(x.device) == 0:
        print 'ip %s has no device' % x.address
        print x.hosts[0].name
        if "natpool" in x.hosts[0].name:
            continue
        elif "int-vlan" in x.hosts[0].name:
            continue
        elif "int-vlan" in x.hosts[0].name:
            continue
        elif "yum.lax3.gnmedia.net" in x.hosts[0].name:
            continue
        elif "app1v-yum.tp.lax3.gnmedia.net" in x.hosts[0].name:
            continue
        elif "app1v-yum.tp.prd.lax.gnmedia.net" in x.hosts[0].name:
            continue
        # Adding Device
        node = Device()
        node.alias = "place holder"
        node.ips.append(x)
        node._types = type_node
        Session.add(node)
Session.commit()
