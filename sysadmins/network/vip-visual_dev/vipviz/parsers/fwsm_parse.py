#!/usr/bin/python
from ciscoconfparse import *
from lib.multiple_replace import multiple_replace

from Model_Buff import *

Session = sessionmaker(bind=db)()

name_str = r"""name (.*?) (.*?)$"""
name_rx = re.compile(name_str)
static_str = r"""static \(.*?\) (.*?) (.*?) .*$"""
static_rx = re.compile(static_str)

SILO, SERVERFARM = ('5', 2)


def loadconf(filename):
    parse = CiscoConfParse(filename)
    name_conf = parse.find_all_children("^name")
    name_lines = CiscoConfParse(name_conf).find_lines("^name")

    name_ip = dict()
    # Build Name-IP Dictionary
    for name_line in name_lines:
        m = name_rx.search(name_line)
        if m != None:
            name_ip[m.group(2)] = m.group(1)
    print name_ip
    static_conf = parse.find_all_children("^static")
    static_lines = CiscoConfParse(static_conf).find_lines("^static")
    for s_line in static_lines:
        map_node = Ipmap()
        m = static_rx.search(s_line)
        if m != None:
            map_node.in_ip = multiple_replace(name_ip, m.group(1))
            map_node.out_ip = multiple_replace(name_ip, m.group(2))
        Session.add(map_node)
    Session.commit()
if __name__ == '__main__':
    loadconf("configs/fwsm1.core1.gnmedia.net")
