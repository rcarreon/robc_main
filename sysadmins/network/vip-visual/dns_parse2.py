#!/usr/bin/python
import dns.zone
from dns.exception import DNSException
from dns.rdataclass import *
from dns.rdatatype import *
from ciscoconfparse import *

from Model_Buff import *
#http://agiletesting.blogspot.com/2005/08/managing-dns-zone-files-with-dnspython.html

domain = "iconator.com"
print "Getting zone object for domain", domain
zone_file = "zones/%s.hosts" % domain

Session = sessionmaker(bind=db)()  

# First Step: Start Parsing DNS Records
try:
    zone = dns.zone.from_file(zone_file, domain)
    print "Zone origin:", zone.origin
    for name, node in zone.nodes.items():
        rdatasets = node.rdatasets
        #print "\n**** BEGIN NODE ****"
        #print "node name:", name
        for rdataset in rdatasets:
            print "--- BEGIN RDATASET ---"
            print "rdataset string representation:", rdataset
            print "rdataset rdclass:", rdataset.rdclass
            print "rdataset rdtype:", rdataset.rdtype
            print "rdataset ttl:", rdataset.ttl
            print "rdataset has following rdata:"
            for rdata in rdataset:
                print "-- BEGIN RDATA --"
                print "rdata string representation:", rdata
                if rdataset.rdtype == SOA:
                    print "** SOA-specific rdata **"
                    print "expire:", rdata.expire
                    print "minimum:", rdata.minimum
                    print "mname:", rdata.mname
                    print "refresh:", rdata.refresh
                    print "retry:", rdata.retry
                    print "rname:", rdata.rname
                    print "serial:", rdata.serial
                if rdataset.rdtype == MX:
                    print "** MX-specific rdata **"
                    print "exchange:", rdata.exchange
                    print "preference:", rdata.preference
                if rdataset.rdtype == NS:
                    print "** NS-specific rdata **"
                    print "target:", rdata.target
                if rdataset.rdtype == CNAME:
                    print "** CNAME-specific rdata **"
                    print "target:", rdata.target
                if rdataset.rdtype == A:
                    print "** A-specific rdata **"
                    print "address:", rdata.address
                    db_node = Host()
                    db_node.name = str(name) + "." + re.sub(r'''.$''','',str(zone.origin))
                    db_ip = IP()
                    db_ip.address = str(rdata.address)
                    db_node.ips.append(db_ip) 
                    print 'RADDR', rdata.address
                    if Session.query(IP).filter_by(address=str(rdata.address)).first():
                         pass
                    else:
                         Session.add(db_node)
    Session.commit()
except DNSException, e:
    print e.__class__, e
