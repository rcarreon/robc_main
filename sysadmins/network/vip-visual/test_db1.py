#!/usr/bin/python
from Model import *
import re

f = open('/app/shared/vipvisual/sqlhostname', 'r')
sqlhostname=f.readline()
f.close()
f = open('/app/shared/vipvisual/sqlpassword', 'r')
sqlpassword=f.readline()
f.close()

db2 = create_engine('mysql://vipvisual:'+sqlpassword+'@'+sqlhostname+':3306/servers_dev2?use_unicode=1&charset=utf8', pool_size=100, \
                pool_recycle=7200)
Session = sessionmaker(bind=db)()  
Session2 = sessionmaker(bind=db2)()  
# LAX1/LAX2/LAX3/CORE
for x in Session.query(Device).filter(Device.types==3).all():
    #print 'VIP :', x.alias, x.device_id
    for y in x.ips:
       #print 'IP', y.address
       vip_addr = y.address    
    for z in x.children:
        #print z.alias
        for z2 in z.children:
            #print 'yy', z2.alias
            for r in z2.ips:
                print '%s, %s'%( vip_addr, r.address)
                Session2.execute("call sp_push_device_relationship('%s','%s', 0)" %
                        ( vip_addr, r.address))
                # add type
                if len(z2.getHostname()):
                    if "app" in z2.getHostname():
                        Session2.execute("call sp_push_device_type('%s','%s')" %
                            ( r.address, 'appserv' ))
                    elif "sql" in rz2.getHostname():
                        Session2.execute("call sp_push_device_type('%s','%s')" %
                            ( r.address, 'dbserv' ))
                    else:
                        Session2.execute("call sp_push_device_type('%s','%s')" %
                            ( r.address, 'unknown' ))
                else:
                    Session2.execute("call sp_push_device_type('%s','%s')" %
                        ( r.address, 'unknown' ))
    if x.getType().name == "sqlvip":
        Session2.execute("call sp_push_device_type('%s','%s')" %
            ( vip_addr, 'dbvip' ))
    elif x.getType().name == "appvip":
        Session2.execute("call sp_push_device_type('%s','%s')" %
            ( vip_addr, 'appvip' ))
Session2.commit()                

#SQL app Relation
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
            hash_table[x.app_ip]=last_sql_node.sql_ip
            if hash_table.has_key(last_sql_node.sql_ip):
                print "WARNNING", last_sql_node.sql_ip
                continue
            Session2.execute("call sp_push_device_relationship('%s','%s', %s)" %
                             ( x.app_ip, last_sql_node.sql_ip,
                                 last_sql_node.conns))
Session2.commit()                
print hash_table
#Type
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
            hash_table[x.app_ip]=last_sql_node.sql_ip
            if hash_table.has_key(last_sql_node.sql_ip):
                print "WARNNING", last_sql_node.sql_ip
                continue
            Session2.execute("call sp_push_device_relationship('%s','%s', %s)" %
                             ( x.app_ip, last_sql_node.sql_ip,
                                 last_sql_node.conns))
Session2.commit()                
print hash_table
