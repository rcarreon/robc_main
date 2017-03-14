#!/usr/bin/python
from Model_Buff import *
import re

Session = sessionmaker(bind=db)()  

readfile = open("/app/shared/vipvisual/vlan.dat","r")
vlan_str = r'^"(.*?)","(.*?)/(.*?)"'
vlan_rx = re.compile(vlan_str)

for x in readfile.readlines():
    m = vlan_rx.search(x)
    if m != None:
        print m.group(1), m.group(2), m.group(3)
        vlan_node = Vlan()
        vlan_node.name = m.group(1)
        vlan_node.ip = m.group(2)
        vlan_node.netmask = m.group(3)
        Session.add(vlan_node)
Session.commit()
