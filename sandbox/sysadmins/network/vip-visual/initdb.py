#!/usr/bin/python
from Model_Buff import *

Session = sessionmaker(bind=db)()  
types_list = ['rserver', 'serverfarm','sqlvip','appvip','interface']
silo_list = ['CORE1','LAX1','LAX2','LAX3']
instance_list = ['admin','prod','sb','stage','gn1','legacy','ap','doublehelix','10g','apstg']
predictor_list = ['roundrobin','hash url','leastconns','response app-req-to-resp']
business_owner = {
"CraveOnline": "ao",
"GameRevolution": "ao",
"HFBoards": "ao",
"PebbleBed": "ao",
"TeenCrunch": "ao",
"TheFashionSpot": "ao",
"Sherdog": "ao",
"AdPlatform": "ap",
"SBVideo": "sbv",
"DoubleHelix": "si",
"SheKnows": "wuo",
"TechPlatform": "tp",
"Momtastic": "unk",
"CrowdIgnite": "unk",
}
vertical_list = ['AdPlatform','Atomic_Sites','Atomic_Sites_HMO','Nagios','Sheknows', \
'Springboard_Video','TechPlatform','Xen']
environment_list = ['prd','stg','dev']


for x in types_list:
   type_node = Types()
   type_node.name = x
   Session.add(type_node)

for x in silo_list:
   silo_node = Silo()
   silo_node.name = x
   Session.add(silo_node)

for x in instance_list:
   instance_node = Instance()
   instance_node.name = x
   Session.add(instance_node)

for x in predictor_list:
   predictor_node = Predictor()
   predictor_node.name = x
   Session.add(predictor_node)

for x in business_owner.keys():
   bo_node = Business_Owner()
   bo_node.name = x
   bo_node.short = business_owner[x]
   Session.add(bo_node)

for x in vertical_list:
   vertical_node = Vertical()
   vertical_node.name = x
   Session.add(vertical_node)

for x in environment_list:
   environment_node = Environment()
   environment_node.name = x
   Session.add(environment_node)

Session.commit()

