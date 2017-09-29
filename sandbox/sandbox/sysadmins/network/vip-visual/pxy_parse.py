#!/usr/bin/python
from Model_Buff import *
import re
import socket

Session = sessionmaker(bind=db)()

pxy_ips = Session.query(PXY_to_APP).group_by(PXY_to_APP.pxy_ip).all()
hash_table = {}
for x in pxy_ips:
    # For every app server get all sql IPs
    app_ips = Session.query(PXY_to_APP).filter_by(\
             pxy_ip=x.pxy_ip).group_by(PXY_to_APP.app_ip).all()
    print '-----------%s-------------' % x.pxy_ip
    raw_regex = '(?:[\d]{1,3})\.(?:[\d]{1,3})\.(?:[\d]{1,3})\.(?:[\d]{1,3})'
    for y in app_ips:
        if re.match(raw_regex, y.app_ip):
            # If both App/Sql Servers have the same IP
            if y.app_ip == x.pxy_ip:
                continue
            # Get the Last SQL mapped to the server
            last_sql_node = Session.query(\
                    PXY_to_APP).filter_by(\
                    pxy_ip=x.pxy_ip).filter_by(\
                    app_ip=y.app_ip).order_by(\
                    PXY_to_APP.date_inserted.desc()).first()
            hash_table[x.pxy_ip]=last_sql_node.app_ip
            if hash_table.has_key(last_sql_node.app_ip):
                print "WARNNING", last_sql_node.app_ip
                continue
            ip_node = Session.query(IP).filter_by(\
                    address=last_sql_node.app_ip).first()
            exit_flag = 0
            if ip_node != None:
                print 'ip_node = ', ip_node.address
                for node in ip_node.device:
                    print node.alias
                    print node.getType().name
                    # Connect VIP to the APP Server
                    pxy_ip_node = Session.query(IP).filter_by(\
                            address=x.pxy_ip).first()
                    if pxy_ip_node != None:
                        for app_node in pxy_ip_node.device:
                            if app_node.getType().name == "rserver":
                                for child_node in app_node.children:
                                    print "Comparing %s with %s" % (child_node.device_id, node.device_id)
                                    if child_node.device_id == node.device_id:
                                        print "Deplication detected ~~~ Please check your configuration %s" % child_node.device_id
                                        exit_flag = 1
                                if not exit_flag and '-INV' not in node.alias:
                                    exit_flag = 0
                                    print 'Linking %s(%s) and %s(%s)' % (\
                                        app_node.alias, str(app_node.device_id), \
                                        node.alias, str(node.device_id))
                                    current_assoc = TreeAssoc(node, app_node)
                                    current_assoc.conns =  y.conns
                print last_sql_node.app_ip, last_sql_node.date_inserted
            else:
                # Append new Device Node and 
                # Still need to be work on
                single_node = Device()
                db_ip = IP()
                db_ip.address = last_sql_node.app_ip
                single_node.ips.append(db_ip)
                try:
                    host_result = socket.gethostbyaddr(last_sql_node.app_ip)
                except:
                    host_result = []
                if len(host_result):
                    single_node.alias = "Individual Server"
                    host_node = Host()
                    host_node.name = host_result[0]
                    host_node.ips.append(db_ip)
                else:
                    print "not found"

Session.commit()
print hash_table
