#!/usr/bin/env python
# -*- coding: utf-8 -*-
import Pyro.naming
import os
import sys
import time
from subprocess import Popen, PIPE
import socket
import time
from BeautifulSoup import BeautifulSoup
import elementtree.ElementTree as etree
import elementtree.SimpleXMLTreeBuilder as XMLTreeBuilder
import pycurl
import StringIO
from Model import *

def netcat(hostname, port, content):
    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    s.connect((hostname, int(port)))
    s.sendall(content)
    s.shutdown(socket.SHUT_WR)
    while 1:
        data = s.recv(1024)
        if data == "":
            break
        print "Received:", repr(data)
    print "Connection closed."
    s.close()

def ext_netcat(hostname, port, content):
    command = 'echo "' + content + '" |/usr/bin/nc ' + hostname + ' ' + str(port)
    run = Popen(command, shell=True,
                stdout=PIPE, stderr=PIPE) 
    print command
    return

def get_interface_tree(root,interface_entry=[]):
    for x in root.getchildren():
        #print x.items(),"1"
        for y in x.findall("xml_interface_entry"):
            #print y,"2"
            for z in y.findall("xml_interface"):
                #print z,"3"
                int_name = ""
                int_status = ""
                for interface_real in z.findall("interface_name"):
                    int_name = interface_real.text.strip()
                for interface_status in z.findall("interface_status"):
                    int_status = interface_status.text.strip()
                interface_entry.append([int_name,int_status])
        if len(interface_entry):
            return interface_entry
        get_interface_tree(x,interface_entry)
    return interface_entry

def get_serverfarm_tree(root,sf_entry={}):
    Session = sessionmaker(bind=db)()
    for x in root.getchildren():
        for y in x.findall("sf_rs_entry"):
            for sf_real in y.findall("sf_realserver"):
                sf_entry[sf_real.text.strip()] = []
            for sf_address in y.findall("address"):
                sf_entry[sf_real.text.strip()].append(sf_address.text.strip())
            for rs_status in y.findall("rs_state"):
                sf_entry[sf_real.text.strip()].append(rs_status.text.strip())
            for rs_curr_conns in y.findall("rs_curr_conns"):
                sf_entry[sf_real.text.strip()].append(rs_curr_conns.text.strip())
        if len(sf_entry):
            #print sf_entry
            print 'sf',sf_entry
            for key in sf_entry.keys():
                ip = Session.query(IP).filter(IP.address == sf_entry[key][0]).first()
                hostname = ""
                if len(ip.hosts):
                    hostname = ip.hosts[0].name.replace('.','_')
                graphite_str = hostname + '.vip.connections.value ' + \
                sf_entry[key][2] + ' ' + str(int(time.time()))
                print graphite_str
                #netcat("relay-graphite.gnmedia.net", "2003", graphite_str)
                ext_netcat("10.11.20.52", "2003", graphite_str)
        get_serverfarm_tree(x,sf_entry)
    Session.close()
    return sf_entry

def get_load_status(root, probe_entry={}):
    Session = sessionmaker(bind=db)()
    for x in root.getchildren():
        for y in x.findall("xml_probe_stats"):
            for rs_address in y.findall("xml_probe_probed_address"):
                #print rs_address
                probe_entry[rs_address.text.strip()] = []
            for sf_real in y.findall("xml_probe_snmp_load"):
                #print sf_real
                probe_entry[rs_address.text.strip()].append(sf_real.text.strip())
        if len(probe_entry):
            #print probe_entry
            for key in probe_entry.keys():
                ip = Session.query(IP).filter(IP.address == key).first()
                hostname = ""
                if len(ip.hosts):
                    hostname = ip.hosts[0].name.replace('.','_')
                graphite_str = hostname + '.vip.load.value ' + \
                probe_entry[key][0] + ' ' + str(int(time.time()))
                print graphite_str
                #netcat("relay-graphite.gnmedia.net", "2003", graphite_str)
                ext_netcat("10.11.20.52", "2003", graphite_str)
        get_load_status(x,probe_entry)
    Session.close()
    return probe_entry

class Remote(Pyro.core.ObjBase):

    def __init__(self):
        Pyro.core.ObjBase.__init__(self)

    def interface_status(self, name, ace_name):
        c = pycurl.Curl()
        c.setopt(pycurl.URL, "https://vipviz:7INrSCXf@%s/bin/xml_agent" % ace_name)
        c.setopt(pycurl.HTTPHEADER, ["Accept:"])
        b = None
        b = StringIO.StringIO()
        wrapper = '''<request_xml><show_interface interface-type="vlan" interface-number="'''+ name +'''"></show_interface></request_xml>'''
        print "Start getting interface info for %s from ace: %s" % (name, ace_name)
        c.setopt(pycurl.POST, 1)
        c.setopt(pycurl.POSTFIELDS, "xml_cmd=%s" % wrapper)
        c.setopt(pycurl.SSL_VERIFYPEER, 0)
        c.setopt(pycurl.SSL_VERIFYHOST, 1)
        c.setopt(pycurl.FOLLOWLOCATION, 1)
        c.setopt(pycurl.MAXREDIRS, 5)
        c.setopt(pycurl.WRITEFUNCTION, b.write)
        c.perform()
        soup = BeautifulSoup(b.getvalue())
        p = XMLTreeBuilder.TreeBuilder()
        p.feed(soup.prettify())
        tree = None
        tree = p.close()
        print "Being asked to check the status of %s" % name
        print wrapper
        link = []
        print get_interface_tree(tree,link)
        return get_interface_tree(tree,link)

    def serverfarm_status(self, name, ace_name):
        c = pycurl.Curl()
        c.setopt(pycurl.URL, "https://vipviz:7INrSCXf@%s/bin/xml_agent" % ace_name)
        c.setopt(pycurl.HTTPHEADER, ["Accept:"])
        b = None
        b = StringIO.StringIO()
        wrapper = '''<request_xml><show_serverfarm sfarm-name="''' + name + '''"></show_serverfarm></request_xml>'''
        print "Start getting serverfarm info for %s from ace: %s" % (name, ace_name)
        c.setopt(pycurl.POST, 1)
        c.setopt(pycurl.POSTFIELDS, "xml_cmd=%s" % wrapper)
        c.setopt(pycurl.SSL_VERIFYPEER, 0)
        c.setopt(pycurl.SSL_VERIFYHOST, 1)
        c.setopt(pycurl.FOLLOWLOCATION, 1)
        c.setopt(pycurl.MAXREDIRS, 5)
        c.setopt(pycurl.WRITEFUNCTION, b.write)
        c.perform()
        soup = BeautifulSoup(b.getvalue())
        p = XMLTreeBuilder.TreeBuilder()
        p.feed(soup.prettify())
        tree = None
        tree = p.close()
        print "Being asked to check the status of %s" % name
        #print wrapper
        link = {}
        print get_serverfarm_tree(tree,link)
        return get_serverfarm_tree(tree,link)

    def probe_load_status(self, name, ace_name):
        c = pycurl.Curl()
        c.setopt(pycurl.URL, "https://vipviz:7INrSCXf@%s/bin/xml_agent" % ace_name)
        c.setopt(pycurl.HTTPHEADER, ["Accept:"])
        b = None
        b = StringIO.StringIO()
        wrapper = '''<request_xml><show_probe probe-name="''' + name + '''" info-type="detail"></show_probe></request_xml>'''
        print "Start getting probe load info for %s from ace: %s" % (name, ace_name)
        c.setopt(pycurl.POST, 1)
        c.setopt(pycurl.POSTFIELDS, "xml_cmd=%s" % wrapper)
        c.setopt(pycurl.SSL_VERIFYPEER, 0)
        c.setopt(pycurl.SSL_VERIFYHOST, 1)
        c.setopt(pycurl.FOLLOWLOCATION, 1)
        c.setopt(pycurl.MAXREDIRS, 5)
        c.setopt(pycurl.WRITEFUNCTION, b.write)
        c.perform()
        soup = BeautifulSoup(b.getvalue())
        p = XMLTreeBuilder.TreeBuilder()
        p.feed(soup.prettify())
        tree = None
        tree = p.close()
        print "Being asked to check the status of probe %s" % name
        #print wrapper
        link = {}
        print get_load_status(tree,link)
        return get_load_status(tree,link)


def main():
        Pyro.core.initServer()
        daemon=Pyro.core.Daemon(port=8889)
        uri=daemon.connect(Remote(), "remote")

        print "The daemon is running on port:", daemon.port
        print "The object's uri is:", uri

        try:
            daemon.requestLoop()
        except KeyboardInterrupt():
            sys.exit(1)
if __name__ == "__main__":
    main()

