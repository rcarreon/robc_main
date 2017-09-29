#!/usr/bin/python
from Model_Buff import *
import re
import socket

Session = sessionmaker(bind=db)()

app_ips = Session.query(APP_to_SQL).group_by(APP_to_SQL.app_ip).all()
hash_table = {}
for x in app_ips:
    # For every app server get all sql IPs
    sql_ips = Session.query(APP_to_SQL).filter_by(\
             app_ip=x.app_ip).group_by(APP_to_SQL.sql_ip).all()
    print '-----------%s-------------' % x.app_ip
    raw_regex = '(?:[\d]{1,3})\.(?:[\d]{1,3})\.(?:[\d]{1,3})\.(?:[\d]{1,3})'
    for y in sql_ips:
        if re.match(raw_regex, y.sql_ip):
            # If both App/Sql Servers have the same IP
            if y.sql_ip == x.app_ip:
                continue
            # Get the Last SQL mapped to the server
            last_sql_node = Session.query(\
                    APP_to_SQL).filter_by(\
                    app_ip=x.app_ip).filter_by(\
                    sql_ip=y.sql_ip).order_by(\
                    APP_to_SQL.date_inserted.desc()).first()
            hash_table[x.app_ip] = last_sql_node.sql_ip
            if last_sql_node.sql_ip in hash_table:
                print "WARNNING", last_sql_node.sql_ip
                continue
            ip_node = Session.query(IP).filter_by(\
                    address=last_sql_node.sql_ip).first()
            exit_flag = 0
            if ip_node != None:
                for node in ip_node.device:
                    print node.getType().name
                    # Connect VIP to the APP Server
                    app_ip_node = Session.query(IP).filter_by(\
                            address=x.app_ip).first()
                    # All device IP associated with the ip code
                    if app_ip_node != None:
                        for app_node in app_ip_node.device:
                            if app_node.getType().name == "rserver":
                                for child_node in app_node.children:
                                    print "Comparing %s with %s" % (child_node.device_id, node.device_id)
                                    if child_node.device_id == node.device_id:
                                        print "Deplication detected ~~~ Please check your configuration %s" % child_node.device_id
                                        exit_flag = 1
                                if not exit_flag:
                                    exit_flag = 0
                                    print 'Linking %s(%s) and %s(%s)' % (\
                                        app_node.alias, str(app_node.device_id), \
                                        node.alias, str(node.device_id))
                                    current_assoc = TreeAssoc(node, app_node)
                                    current_assoc.conns = y.conns
                print last_sql_node.sql_ip, last_sql_node.date_inserted
            else:
                # Append new Device Node and
                # Still need to be work on
                single_node = Device()
                db_ip = IP()
                db_ip.address = last_sql_node.sql_ip
                single_node.ips.append(db_ip)
                try:
                    host_result = socket.gethostbyaddr(last_sql_node.sql_ip)
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
