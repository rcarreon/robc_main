#!/usr/bin/python
from Model import *
Session = sessionmaker(bind=db)()  
# First VIP
for x in Session.query(Device).filter(Device.types==3).filter(Device.silo==1).all():
   print "=========================================================================================="
   print 'VIP :', x.alias, x.device_id
   for y in x.ips:
       print 'IP', y.address
   current_status = 0
   device_ip = ''
   # for multiple layers, we need to check the depth
   for l in x.children:
      current_status = l.get_status(x)
      print 'Serverfarm ----',l.device_id, l.alias, current_status, host
      for z in l.children:
          current_status = z.get_status(l)
          for g in z.ips:
              if g.hosts:
                 for k in g.hosts:
                      host = k.name
                      print 'RSERVER ----', z.device_id, z.alias, current_status, g.address, host
                      host = ''
                      for link in g.device:
                          #print '----- LINK -----',link.types, link.device_id, link.alias
                          if link.types == 3:
                               for l in link.children:
                                  current_status = l.get_status(x)
                                  print "------------------------------------------------------------------------------------------"
                                  print '---- 2nd VIP ----',l.device_id, l.alias, current_status, host
                                  for z in l.children:
                                      current_status = z.get_status(l)
                                      for g in z.ips:
                                          if g.hosts:
                                             for k in g.hosts:
                                                  host = k.name
                                                  print '---- RSERVER ----', z.device_id, z.alias, current_status, g.address, host
                                                  host = ''
                                          else:
                                              print '---- RSERVER ----', z.device_id, z.alias, current_status, g.address
              else:
                  print 'RSERVER ----', z.device_id, z.alias, current_status, g.address
