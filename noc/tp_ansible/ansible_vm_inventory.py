#!/usr/bin/python
import ansible.runner
import sys
import json
import collections
import ansible.playbook
from ansible import callbacks
from ansible import utils
import subprocess


# Get facts from metals
setup_results = ansible.runner.Runner(
	remote_user = 'reporter',
    private_key_file = '/home/jbustamante/ansible/reporter_id_rsa',
    host_list = "/etc/ansible/hosts",
    pattern='metals',
    module_name='setup',
    module_args='',
).run()

# Get VMs info from VMs
vm_results = ansible.runner.Runner(
    remote_user = 'reporter',
    private_key_file = '/home/jbustamante/ansible/reporter_id_rsa',
    host_list = "/etc/ansible/hosts",
    pattern='metals',
    module_name='virt_lib',
    module_args='',
).run()


hosts = setup_results['contacted'].keys()



all_tp = []
all_si = []
all_ap = []
all_og = []
all_ao = []
all_af = []
all_ci = []
all_sbv = []

all_tp_prd = []
all_tp_stg = []
all_tp_dev = []
all_si_prd = []
all_si_stg = []
all_si_dev = []
all_ap_prd = []
all_ap_stg = []
all_ap_dev = []
all_ao_prd = []
all_ao_stg = []
all_ao_dev = []
all_og_prd = []
all_og_stg = []
all_og_dev = []
all_af_prd = []
all_af_stg = []
all_af_dev = []
all_ci_prd = []
all_ci_stg = []
all_ci_dev = []
all_sbv_prd = []
all_sbv_stg = []
all_sbv_dev = []
others = []
app_tp_prd = []
app_tp_stg = []
app_tp_dev = []
sql_tp_prd = []
sql_tp_stg = []
sql_tp_dev = []
rds_tp_prd = []
rds_tp_stg = []
rds_tp_dev = []
uid_tp = []
app_si_prd = []
app_si_stg = []
app_si_dev = []
sql_si_prd = []
sql_si_stg = []
sql_si_dev = []
uid_si = []
app_ap_prd = []
app_ap_stg = []
app_ap_dev = []
sql_ap_prd = []
sql_ap_stg = []
sql_ap_dev = []
mem_ap_prd = []
mem_ap_stg = []
mem_ap_dev = []
els_ap_prd = []
els_ap_stg = []
els_ap_dev = []
uid_ap = []
app_og_prd = []
app_og_stg = []
app_og_dev = []
sql_og_prd = []
sql_og_stg = []
sql_og_dev = []
mem_og_prd = []
mem_og_stg = []
mem_og_dev = []
rds_og_prd = []
rds_og_stg = []
rds_og_dev = []
uid_og = []
app_ao_prd = []
app_ao_stg = []
app_ao_dev = []
sql_ao_prd = []
sql_ao_stg = []
sql_ao_dev = []
mem_ao_prd = []
mem_ao_stg = []
mem_ao_dev = []
els_ao_prd = []
els_ao_stg = []
els_ao_dev = []
pxy_ao_prd = []
pxy_ao_stg = []
pxy_ao_dev = []
spx_ao_prd = []
spx_ao_stg = []
spx_ao_dev = []
uid_ao = []
app_af_prd = []
app_sbv_prd = []
app_sbv_stg = []
app_sbv_dev = []
sql_sbv_prd = []
sql_sbv_stg = []
sql_sbv_dev = []
uid_sbv = []
app_ci_prd = []
app_ci_stg = []
app_ci_dev = []
sql_ci_prd = []
sql_ci_stg = []
sql_ci_dev = []
eng_ci_prd = []
eng_ci_stg = []
eng_ci_dev = []
kes_ci_prd = []
kes_ci_stg = []
kes_ci_dev = []
mem_ci_prd = []
mem_ci_stg = []
mem_ci_dev = []
ngx_ci_prd = []
ngx_ci_stg = []
ngx_ci_dev = []
els_ci_prd = []
els_ci_stg = []
els_ci_dev = []
pxy_ci_prd = []
pxy_ci_stg = []
pxy_ci_dev = []
spx_ci_prd = []
spx_ci_stg = []
spx_ci_dev = []
uid_ci = []


#Split all VMs into vertical, environment and technology

for host in hosts:
    vms_host = vm_results['contacted'][host].keys()
    for vm in vms_host:
        if vm != "invocation":
			if vm != "evolve-win-ad01":
	        	#Technology Platform
				if vm.split('.')[0:][1] == 'tp':
					all_tp.append(vm)
					if vm.split('.')[0:][2] == 'prd':
						all_tp_prd.append(vm)
						if 'app' in vm.split('.')[0:][0]:
							app_tp_prd.append(vm)
						elif 'sql' in vm.split('.')[0:][0]:
							sql_tp_prd.append(vm)
						elif 'rds' in vm.split('.')[0:][0]:
							rds_tp_prd.append(vm)
						else:
							others.append(vm)	
					elif vm.split('.')[0:][2] == 'stg':
						all_tp_stg.append(vm)
						if 'app' in vm.split('.')[0:][0]:
							app_tp_stg.append(vm)
						elif 'sql' in vm.split('.')[0:][0]:
							sql_tp_stg.append(vm)
						elif 'rds' in vm.split('.')[0:][0]:
							rds_tp_stg.append(vm)
						else:
							others.append(vm)
					elif vm.split('.')[0:][2] == 'dev':
						all_tp_dev.append(vm)
						if 'app' in vm.split('.')[0:][0]:
							app_tp_dev.append(vm)
						elif 'sql' in vm.split('.')[0:][0]:
							sql_tp_dev.append(vm)
						elif 'rds' in vm.split('.')[0:][0]:
							rds_tp_dev.append(vm)
						elif 'uid' in vm.split('.')[0:][0]:
							uid_tp.append(vm)
						else:
							others.append(vm)

				#Sales Integration
				elif vm.split('.')[0:][1] == 'si':
					all_si.append(vm)
					if vm.split('.')[0:][2] == 'prd':
						all_si_prd.append(vm)
						if 'app' in vm.split('.')[0:][0]:
							app_si_prd.append(vm)
						elif 'sql' in vm.split('.')[0:][0]:
							sql_si_prd.append(vm)
						else:
							others.append(vm)					
					elif vm.split('.')[0:][2] == 'stg':
						all_si_stg.append(vm)
						if 'app' in vm.split('.')[0:][0]:
							app_si_stg.append(vm)
						elif 'sql' in vm.split('.')[0:][0]:
							sql_si_stg.append(vm)
						else:
							others.append(vm)	
					elif vm.split('.')[0:][2] == 'dev':
						all_si_dev.append(vm)
						if 'app' in vm.split('.')[0:][0]:
							app_si_dev.append(vm)
						elif 'sql' in vm.split('.')[0:][0]:
							sql_si_dev.append(vm)
						elif 'uid' in vm.split('.')[0:][0]:
							uid_si.append(vm)
						else:
							others.append(vm)	

				#Ad Platform
				elif vm.split('.')[0:][1] == 'ap':
					all_ap.append(vm)
					if vm.split('.')[0:][2] == 'prd':
						all_ap_prd.append(vm)
						if 'app' in vm.split('.')[0:][0]:
							app_ap_prd.append(vm)
						elif 'sql' in vm.split('.')[0:][0]:
							sql_ap_prd.append(vm)
						elif 'mem' in vm.split('.')[0:][0]:
							mem_ap_prd.append(vm)
						else:
							others.append(vm)	
					elif vm.split('.')[0:][2] == 'stg':
						all_ap_stg.append(vm)
						if 'app' in vm.split('.')[0:][0]:
							app_ap_stg.append(vm)
						elif 'sql' in vm.split('.')[0:][0]:
							sql_ap_stg.append(vm)
						elif 'mem' in vm.split('.')[0:][0]:
							mem_ap_stg.append(vm)
						else:
							others.append(vm)
					elif vm.split('.')[0:][2] == 'dev':
						all_ap_dev.append(vm)
						if 'app' in vm.split('.')[0:][0]:
							app_ap_dev.append(vm)
						elif 'sql' in vm.split('.')[0:][0]:
							sql_ap_dev.append(vm)
						elif 'mem' in vm.split('.')[0:][0]:
							mem_ap_dev.append(vm)
						elif 'uid' in vm.split('.')[0:][0]:
							uid_ap.append(vm)
						else:
							others.append(vm)

				#Origin
				elif vm.split('.')[0:][1] == 'og':
					all_og.append(vm)
					if vm.split('.')[0:][2] == 'prd':
						all_og_prd.append(vm)
						if 'app' in vm.split('.')[0:][0]:
							app_og_prd.append(vm)
						elif 'sql' in vm.split('.')[0:][0]:
							sql_og_prd.append(vm)
						elif 'mem' in vm.split('.')[0:][0]:
							mem_og_prd.append(vm)
						elif 'rds' in vm.split('.')[0:][0]:
							rds_og_prd.append(vm)
						else:
							others.append(vm)
					elif vm.split('.')[0:][2] == 'stg':
						all_og_stg.append(vm)
						if 'app' in vm.split('.')[0:][0]:
							app_og_stg.append(vm)
						elif 'sql' in vm.split('.')[0:][0]:
							sql_og_stg.append(vm)
						elif 'mem' in vm.split('.')[0:][0]:
							mem_og_stg.append(vm)
						elif 'rds' in vm.split('.')[0:][0]:
							rds_og_stg.append(vm)
						else:
							others.append(vm)
					elif vm.split('.')[0:][2] == 'dev':
						all_og_dev.append(vm)
						if 'app' in vm.split('.')[0:][0]:
							app_og_dev.append(vm)
						elif 'sql' in vm.split('.')[0:][0]:
							sql_og_dev.append(vm)
						elif 'mem' in vm.split('.')[0:][0]:
							mem_og_dev.append(vm)
						elif 'rds' in vm.split('.')[0:][0]:
							rds_og_dev.append(vm)
						elif 'uid' in vm.split('.')[0:][0]:
							uid_og.append(vm)
						else:
							others.append(vm)

				#Atomic Online
				elif vm.split('.')[0:][1] == 'ao':
					all_ao.append(vm)
					if vm.split('.')[0:][2] == 'prd':
						all_ao_prd.append(vm)
						if 'app' in vm.split('.')[0:][0]:
							app_ao_prd.append(vm)
						elif 'sql' in vm.split('.')[0:][0]:
							sql_ao_prd.append(vm)
						elif 'mem' in vm.split('.')[0:][0]:
							mem_ao_prd.append(vm)
						elif 'els' in vm.split('.')[0:][0]:
							els_ao_prd.append(vm)
						elif 'pxy' in vm.split('.')[0:][0]:
							pxy_ao_prd.append(vm)
						elif 'spx' in vm.split('.')[0:][0]:
							spx_ao_prd.append(vm)
						else:
							others.append(vm)
					elif vm.split('.')[0:][2] == 'stg':
						all_ao_stg.append(vm)
						if 'app' in vm.split('.')[0:][0]:
							app_ao_stg.append(vm)
						elif 'sql' in vm.split('.')[0:][0]:
							sql_ao_stg.append(vm)
						elif 'mem' in vm.split('.')[0:][0]:
							mem_ao_stg.append(vm)
						elif 'els' in vm.split('.')[0:][0]:
							els_ao_stg.append(vm)
						elif 'pxy' in vm.split('.')[0:][0]:
							pxy_ao_stg.append(vm)
						elif 'spx' in vm.split('.')[0:][0]:
							spx_ao_stg.append(vm)
						else:
							others.append(vm)
					elif vm.split('.')[0:][2] == 'dev':
						all_ao_dev.append(vm)
						if 'app' in vm.split('.')[0:][0]:
							app_ao_dev.append(vm)
						elif 'sql' in vm.split('.')[0:][0]:
							sql_ao_dev.append(vm)
						elif 'mem' in vm.split('.')[0:][0]:
							mem_ao_dev.append(vm)
						elif 'els' in vm.split('.')[0:][0]:
							els_ao_dev.append(vm)
						elif 'pxy' in vm.split('.')[0:][0]:
							pxy_ao_dev.append(vm)
						elif 'spx' in vm.split('.')[0:][0]:
							spx_ao_dev.append(vm)
						elif 'uid' in vm.split('.')[0:][0]:
							uid_ao.append(vm)
						else:
							others.append(vm)

				#AF
				elif vm.split('.')[0:][1] == 'af':
					all_af.append(vm)
					if vm.split('.')[0:][2] == 'prd':
						all_af_prd.append(vm)
						if 'app' in vm.split('.')[0:][0]:
							app_af_prd.append(vm)
					#elif vm.split('.')[0:][2] == 'stg':
					#	af_all_prd.append(vm)
					#elif vm.split('.')[0:][2] == 'dev':
					#	af_all_prd.append(vm)
					else:
						others.append(vm)

				#Springboard Video
				elif vm.split('.')[0:][1] == 'sbv':
					all_sbv.append(vm)
					if vm.split('.')[0:][2] == 'prd':
						all_sbv_prd.append(vm)
						if 'app' in vm.split('.')[0:][0]:
							app_sbv_prd.append(vm)
						elif 'sql' in vm.split('.')[0:][0]:
							sql_sbv_prd.append(vm)
						else:
							others.append(vm)
					elif vm.split('.')[0:][2] == 'stg':
						all_sbv_stg.append(vm)
						if 'app' in vm.split('.')[0:][0]:
							app_sbv_stg.append(vm)
						elif 'sql' in vm.split('.')[0:][0]:
							sql_sbv_stg.append(vm)
						else:
							others.append(vm)
					elif vm.split('.')[0:][2] == 'dev':
						all_sbv_dev.append(vm)
						if 'app' in vm.split('.')[0:][0]:
							app_sbv_dev.append(vm)
						elif 'sql' in vm.split('.')[0:][0]:
							sql_sbv_dev.append(vm)
						elif 'uid' in vm.split('.')[0:][0]:
							uid_sbv.append(vm)
						else:
							others.append(vm)

				#Crowd Ignite
				elif vm.split('.')[0:][1] == 'ci':
					all_ci.append(vm)
					if vm.split('.')[0:][2] == 'prd':
						all_ci_prd.append(vm)
						if 'app' in vm.split('.')[0:][0]:
							app_ci_prd.append(vm)
						elif 'sql' in vm.split('.')[0:][0]:
							sql_ci_prd.append(vm)
						elif 'eng' in vm.split('.')[0:][0]:
							eng_ci_prd.append(vm)
						elif 'kes' in vm.split('.')[0:][0]:
							kes_ci_prd.append(vm)
						elif 'mem' in vm.split('.')[0:][0]:
							mem_ci_prd.append(vm)
						elif 'ngx' in vm.split('.')[0:][0]:
							ngx_ci_prd.append(vm)
						elif 'els' in vm.split('.')[0:][0]:
							els_ci_prd.append(vm)
						elif 'pxy' in vm.split('.')[0:][0]:
							pxy_ci_prd.append(vm)
						elif 'spx' in vm.split('.')[0:][0]:
							spx_ci_prd.append(vm)
						else:
							others.append(vm)
					elif vm.split('.')[0:][2] == 'stg':
						all_ci_prd.append(vm)
						if 'app' in vm.split('.')[0:][0]:
							app_ci_stg.append(vm)
						elif 'sql' in vm.split('.')[0:][0]:
							sql_ci_stg.append(vm)
						elif 'eng' in vm.split('.')[0:][0]:
							eng_ci_stg.append(vm)
						elif 'kes' in vm.split('.')[0:][0]:
							kes_ci_stg.append(vm)
						elif 'mem' in vm.split('.')[0:][0]:
							mem_ci_stg.append(vm)
						elif 'ngx' in vm.split('.')[0:][0]:
							ngx_ci_stg.append(vm)
						elif 'els' in vm.split('.')[0:][0]:
							els_ci_stg.append(vm)
						elif 'pxy' in vm.split('.')[0:][0]:
							pxy_ci_stg.append(vm)
						elif 'spx' in vm.split('.')[0:][0]:
							spx_ci_stg.append(vm)
						else:
							others.append(vm)
					elif vm.split('.')[0:][2] == 'dev':
						all_ci_prd.append(vm)
						if 'app' in vm.split('.')[0:][0]:
							app_ci_dev.append(vm)
						elif 'sql' in vm.split('.')[0:][0]:
							sql_ci_dev.append(vm)
						elif 'eng' in vm.split('.')[0:][0]:
							eng_ci_dev.append(vm)
						elif 'kes' in vm.split('.')[0:][0]:
							kes_ci_dev.append(vm)
						elif 'mem' in vm.split('.')[0:][0]:
							mem_ci_dev.append(vm)
						elif 'ngx' in vm.split('.')[0:][0]:
							ngx_ci_dev.append(vm)
						elif 'els' in vm.split('.')[0:][0]:
							els_ci_dev.append(vm)
						elif 'pxy' in vm.split('.')[0:][0]:
							pxy_ci_dev.append(vm)
						elif 'spx' in vm.split('.')[0:][0]:
							spx_ci_dev.append(vm)
						elif 'uid' in vm.split('.')[0:][0]:
							uid_ci.append(vm)
						else:
							others.append(vm)

				else:
					others.append(vm)


#Print by Vertical
#
#Technology Platform
print "[all_tp]"
for x in all_tp:
	print x

print ""

print "[all_tp_prd]"
for x in all_tp_prd:
	print x

print ""

print "[all_tp_stg]"
for x in all_tp_stg:
	print x

print ""

print "[all_tp_dev]"
for x in all_tp_dev:
	print x

print ""

print "[app_tp_prd]"
for x in app_tp_prd:
	print x

print ""

print "[app_tp_stg]"
for x in app_tp_stg:
	print x

print ""

print "[app_tp_dev]"
for x in app_tp_dev:
	print x

print ""

print "[sql_tp_prd]"
for x in sql_tp_prd:
	print x

print ""

print "[sql_tp_stg]"
for x in sql_tp_stg:
	print x

print ""

print "[sql_tp_dev]"
for x in sql_tp_dev:
	print x

print ""

print "[rds_tp_prd]"
for x in rds_tp_prd:
	print x

print ""

print "[rds_tp_stg]"
for x in rds_tp_stg:
	print x

print ""

print "[rds_tp_dev]"
for x in rds_tp_dev:
	print x

print ""

print "[uid_tp]"
for x in uid_tp:
	print x

print ""

#Sales Integration
print "[all_si]"
for x in all_si:
	print x

print ""

print "[all_si_prd]"
for x in all_si_prd:
	print x

print ""

print "[all_si_stg]"
for x in all_si_stg:
	print x

print ""

print "[all_si_dev]"
for x in all_si_dev:
	print x

print ""

print "[app_si_prd]"
for x in app_si_prd:
	print x

print ""

print "[app_si_stg]"
for x in app_si_stg:
	print x

print ""

print "[app_si_dev]"
for x in app_si_dev:
	print x

print ""

print "[sql_si_prd]"
for x in sql_si_prd:
	print x

print ""

print "[sql_si_stg]"
for x in sql_si_stg:
	print x

print ""

print "[sql_si_dev]"
for x in sql_si_dev:
	print x

print ""

print "[uid_si]"
for x in uid_si:
	print x

print ""

#Ad Platform

print "[all_ap]"
for x in all_ap:
	print x

print ""

print "[all_ap_prd]"
for x in all_ap_prd:
	print x

print ""

print "[all_ap_stg]"
for x in all_ap_stg:
	print x

print ""

print "[all_ap_dev]"
for x in all_ap_dev:
	print x

print ""

print "[app_ap_prd]"
for x in app_ap_prd:
	print x

print ""

print "[app_ap_stg]"
for x in app_ap_stg:
	print x

print ""

print "[app_ap_dev]"
for x in app_ap_dev:
	print x

print ""

print "[sql_ap_prd]"
for x in sql_ap_prd:
	print x

print ""

print "[sql_ap_stg]"
for x in sql_ap_stg:
	print x

print ""

print "[sql_ap_dev]"
for x in sql_ap_dev:
	print x

print ""

print "[mem_ap_prd]"
for x in mem_ap_prd:
	print x

print ""

print "[mem_ap_stg]"
for x in mem_ap_stg:
	print x

print ""

print "[mem_ap_dev]"
for x in mem_ap_dev:
	print x

print ""

print "[uid_ap]"
for x in uid_ap:
	print x

print ""

#Origin

print "[all_og]"
for x in all_og:
	print x

print ""

print "[all_og_prd]"
for x in all_og_prd:
	print x

print ""

print "[all_og_stg]"
for x in all_og_stg:
	print x

print ""

print "[all_og_dev]"
for x in all_og_dev:
	print x

print ""

print "[app_og_prd]"
for x in app_og_prd:
	print x

print ""

print "[app_og_stg]"
for x in app_og_stg:
	print x

print ""

print "[app_og_dev]"
for x in app_og_dev:
	print x

print ""

print "[sql_og_prd]"
for x in sql_og_prd:
	print x

print ""

print "[sql_og_stg]"
for x in sql_og_stg:
	print x

print ""

print "[sql_og_dev]"
for x in sql_og_dev:
	print x

print ""

print "[mem_og_prd]"
for x in mem_og_prd:
	print x

print ""

print "[mem_og_stg]"
for x in mem_og_stg:
	print x

print ""

print "[mem_og_dev]"
for x in mem_og_dev:
	print x

print ""

print "[rds_og_prd]"
for x in rds_og_prd:
	print x

print ""

print "[rds_og_stg]"
for x in rds_og_stg:
	print x

print ""

print "[rds_og_dev]"
for x in rds_og_dev:
	print x

print ""

print "[uid_og]"
for x in uid_og:
	print x

print ""

#Atomic Online

print "[all_ao]"
for x in all_ao:
	print x

print ""

print "[all_ao_prd]"
for x in all_ao_prd:
	print x

print ""

print "[all_ao_stg]"
for x in all_ao_stg:
	print x

print ""

print "[all_ao_dev]"
for x in all_ao_dev:
	print x

print ""

print "[app_ao_prd]"
for x in app_ao_prd:
	print x

print ""

print "[app_ao_stg]"
for x in app_ao_stg:
	print x

print ""

print "[app_ao_dev]"
for x in app_ao_dev:
	print x

print ""

print "[sql_ao_prd]"
for x in sql_ao_prd:
	print x

print ""

print "[sql_ao_stg]"
for x in sql_ao_stg:
	print x

print ""

print "[sql_ao_dev]"
for x in sql_ao_dev:
	print x

print ""

print "[mem_ao_prd]"
for x in mem_ao_prd:
	print x

print ""

print "[mem_ao_stg]"
for x in mem_ao_stg:
	print x

print ""

print "[mem_ao_dev]"
for x in mem_ao_dev:
	print x

print ""

print "[els_ao_prd]"
for x in els_ao_prd:
	print x

print ""

print "[els_ao_stg]"
for x in els_ao_stg:
	print x

print ""

print "[els_ao_dev]"
for x in els_ao_dev:
	print x

print ""

print "[pxy_ao_prd]"
for x in pxy_ao_prd:
	print x

print ""

print "[pxy_ao_stg]"
for x in pxy_ao_stg:
	print x

print ""

print "[pxy_ao_dev]"
for x in pxy_ao_dev:
	print x

print ""

print "[spx_ao_prd]"
for x in spx_ao_prd:
	print x

print ""

print "[spx_ao_stg]"
for x in spx_ao_stg:
	print x

print ""

print "[spx_ao_dev]"
for x in spx_ao_dev:
	print x

print ""

print "[uid_ao]"
for x in uid_ao:
	print x

print ""

#AF
print "[app_af_prd]"
for x in app_af_prd:
	print x

print ""

#Springboard Video
print "[all_sbv]"
for x in all_sbv:
	print x

print ""

print "[all_sbv_prd]"
for x in all_sbv_prd:
	print x

print ""

print "[all_sbv_stg]"
for x in all_sbv_stg:
	print x

print ""

print "[all_sbv_dev]"
for x in all_sbv_dev:
	print x

print ""

print "[app_sbv_prd]"
for x in app_sbv_prd:
	print x

print ""

print "[app_sbv_stg]"
for x in app_sbv_stg:
	print x

print ""

print "[app_sbv_dev]"
for x in app_sbv_dev:
	print x

print ""

print "[sql_sbv_prd]"
for x in sql_sbv_prd:
	print x

print ""

print "[sql_sbv_stg]"
for x in sql_sbv_stg:
	print x

print ""

print "[sql_sbv_dev]"
for x in sql_sbv_dev:
	print x

print ""

print "[uid_sbv]"
for x in uid_sbv:
	print x

print ""

#Crowd Ignite
print "[all_ci]"
for x in all_ci:
	print x

print ""

print "[all_ci_prd]"
for x in all_ci_prd:
	print x

print ""

print "[all_ci_stg]"
for x in all_ci_stg:
	print x

print ""

print "[all_ci_dev]"
for x in all_ci_dev:
	print x

print ""

print "[app_ci_prd]"
for x in app_ci_prd:
	print x

print ""

print "[app_ci_stg]"
for x in app_ci_stg:
	print x

print ""

print "[app_ci_dev]"
for x in app_ci_dev:
	print x

print ""

print "[sql_ci_prd]"
for x in sql_ci_prd:
	print x

print ""

print "[sql_ci_stg]"
for x in sql_ci_stg:
	print x

print ""

print "[sql_ci_dev]"
for x in sql_ci_dev:
	print x

print ""

print "[eng_ci_prd]"
for x in eng_ci_prd:
	print x

print ""

print "[eng_ci_stg]"
for x in eng_ci_stg:
	print x

print ""

print "[eng_ci_dev]"
for x in eng_ci_dev:
	print x

print ""

print "[kes_ci_prd]"
for x in kes_ci_prd:
	print x

print ""

print "[kes_ci_stg]"
for x in kes_ci_stg:
	print x

print ""

print "[kes_ci_dev]"
for x in kes_ci_dev:
	print x

print ""

print "[mem_ci_prd]"
for x in mem_ci_prd:
	print x

print ""

print "[mem_ci_stg]"
for x in mem_ci_stg:
	print x

print ""

print "[mem_ci_dev]"
for x in mem_ci_dev:
	print x

print ""

print "[ngx_ci_prd]"
for x in ngx_ci_prd:
	print x

print ""

print "[ngx_ci_stg]"
for x in ngx_ci_stg:
	print x

print ""

print "[ngx_ci_dev]"
for x in ngx_ci_dev:
	print x

print ""

print "[els_ci_prd]"
for x in els_ci_prd:
	print x

print ""

print "[els_ci_stg]"
for x in els_ci_stg:
	print x

print ""

print "[els_ci_dev]"
for x in els_ci_dev:
	print x

print ""

print "[pxy_ci_prd]"
for x in pxy_ci_prd:
	print x

print ""

print "[pxy_ci_stg]"
for x in pxy_ci_stg:
	print x

print ""

print "[pxy_ci_dev]"
for x in pxy_ci_dev:
	print x

print ""

print "[spx_ci_prd]"
for x in spx_ci_prd:
	print x

print ""

print "[spx_ci_stg]"
for x in spx_ci_stg:
	print x

print ""

print "[spx_ci_dev]"
for x in spx_ci_dev:
	print x

print ""

print "[uid_ci]"
for x in uid_ci:
	print x

print ""

print "[others]"
for x in others:
	print x

print ""
