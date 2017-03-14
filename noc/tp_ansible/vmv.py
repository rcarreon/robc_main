#!/usr/bin/python
import ansible.runner
import ansible
import sys
import json
import shutil
import collections
from email.mime.text import MIMEText
import smtplib
import ansible.playbook
import ansible.inventory
from ansible import callbacks
from ansible import utils

# Get facts from metals
setup_results = ansible.runner.Runner(
    remote_user = 'reporter',
    private_key_file = '/root/reporter_id_rsa',
    host_list = "/etc/ansible/hosts",
    module_args='',
    pattern = 'metals',
    module_name = 'setup'
).run()

uptime_results = ansible.runner.Runner(
    remote_user = 'reporter',
    private_key_file = '/root/reporter_id_rsa',
    host_list = '/etc/ansible/hosts',
    pattern='metals',
    module_name='command',
    module_args='/usr/bin/uptime'
).run()


# Get VMs info from metals
vm_results = ansible.runner.Runner(
    remote_user = 'reporter',
    private_key_file = '/root/reporter_id_rsa',
    host_list = '/etc/ansible/hosts',
    pattern='metals',
    module_name='virt_lib',
    module_args=''

).run()


def sendmail(message):
    msg = MIMEText(str(message))
    msg['Subject'] = 'CRITICAL memory allocation %s' % host_mail
    msg['From'] = 'noreply@evolvemediallc.com'
    msg['To'] = 'techops@evolvemediallc.com'
    s = smtplib.SMTP('localhost')
    s.sendmail('noreply@evolvemediallc.com', ['techops@evolvemediallc.com'], msg.as_string())


if setup_results is None:
   print "No hosts found"
   sys.exit(1)

hosts = setup_results['contacted'].keys()
host_data = {}
metal_data = {}
vm_data = {}


# From every host, creates a dictionary with the information we request 
list_metal = []
for host in hosts:
    memtotal = setup_results['contacted'][host]['ansible_facts']['ansible_memtotal_mb']
    load = uptime_results['contacted'][host]['stdout']
    vm = vm_results['contacted'][host].keys()
    vmmemory_sum = 0
    for x in vm:
        if x != "invocation":
            vmmemory_sum = float(vmmemory_sum) + vm_results['contacted'][host][x]['memtotal']
        vmalloc_percent = (vmmemory_sum * 100) / (setup_results['contacted'][host]['ansible_facts']['ansible_memtotal_mb']/1024)

    #Compare memory allocation and send an email alert if its above 90%
    if vmalloc_percent >= 91:
        message = 'CRITICAL: %s memory allocation is at: %s %%' % (host, vmalloc_percent)
        host_mail = host
        sendmail(message)
        #s = smtp('localhost')
        #m = text('CRITICAL: %s memory allocation is at: %s %%') % host,vmalloc_percent
        #message = """From: Ansible <noreply@evolvemediallc.com>
        #To: TechOps <jose.bustamante@evolvemediallc.com>
        #Subject: CRITICAL memory allocation %s

        #CRITICAL: %s memory allocation is at: %s %%
        #""" % (host, host, vmalloc_percent)
        #m['Subject'] = 'CRITICAL memory allocation %s' % host
        #m['From'] = 'noreply@evolvemediallc.com'
        #m['To'] = 'jose.bustamante@evolvemediallc.com'

        #s.sendmail('noreply@evolvemediallc.com', 'jose.bustamante@evolvemediallc.com', m.as_string())
        #try:
        #    smtpObj = smtplib.SMTP('localhost')
        #    smtpObj.sendmail(sender, receivers, message)         
        #    print "Successfully sent email"
        #except SMTPException:
        #    print "Error: unable to send email"

    host_data[host] = {
                'ip': setup_results['contacted'][host]['ansible_facts']['ansible_default_ipv4']['address'],
                'domain': setup_results['contacted'][host]['ansible_facts']['ansible_domain'],
                'cores': setup_results['contacted'][host]['ansible_facts']['ansible_processor_cores'],
                'cpus': setup_results['contacted'][host]['ansible_facts']['ansible_processor_vcpus'],
                'memtotal': setup_results['contacted'][host]['ansible_facts']['ansible_memtotal_mb'],
                'memfree': setup_results['contacted'][host]['ansible_facts']['ansible_memfree_mb'],
                'swap_total': setup_results['contacted'][host]['ansible_facts']['ansible_swaptotal_mb'],
                'swap_free': setup_results['contacted'][host]['ansible_facts']['ansible_swapfree_mb'],
                'load': ' '.join(load.split()[-1:-4:-1]).replace(",",""),
                'allocated_memory': vmmemory_sum,
                'allocated_percent': vmalloc_percent, 
                'Virtual Machines': vm_results['contacted'][host]
    }
    #print " "
    #print " "
    #print " "

with open("metal-vm.txt", "w") as f:
    for host in hosts:
        vm = vm_results['contacted'][host].keys()
        f.write(host)
        f.write('\n')
        f.write('--- \n')
        for x in vm:
            f.write(x)
            f.write('\n')
        f.write('\n')
        f.write('\n')

with open('/app/shared/http/noctools/vmv/vmv_tmp', 'w') as outfile:
#    json.dumps(host_data, sort_keys=True, indent=4, separators=(',', ': '))
    json.dump(host_data, outfile, sort_keys=True, indent=4, separators=(',', ': '))
#    f.write("Hello World")

shutil.copyfile('/app/shared/http/noctools/vmv/vmv_tmp', '/app/shared/http/noctools/vmv/vmv.json')

#def sendmail(message):
#    msg = MIMEText(str(message))
#    msg['Subject'] = 'CRITICAL memory allocation %s' % host_mail
#    msg['From'] = 'noreply@evolvemediallc.com'
#    msg['To'] = 'jose.bustamante@evolvemediallc.com'
#    s = smtplib.SMTP('localhost')
#    s.sendmail('noreply@evolvemediallc.com', ['jose.bustamante@evolvemediallc.com'], msg.as_string())

#print json.dumps(host_data, sort_keys=True, indent=4, separators=(',', ': '))

#print " "
#print " "

#print sys.path
