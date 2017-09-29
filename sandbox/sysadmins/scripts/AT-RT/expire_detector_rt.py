#!/usr/bin/env python
# -*- coding: utf-8 -*-
import sys,string,codecs,os,getopt
import re
import operator
import time
from datetime import timedelta
from subprocess import Popen, PIPE
import optparse

import smtplib
from email.MIMEText import MIMEText
days_til_expiration = 90
__version__ = "1.0"

rx_mapper = [
[r'''Name: (.*)$''', "name"],
[r'''CF.{Expire Date}: (.*)$''', "expire_date"],
[r'''CF.{Registrar}: (.*)$''', "registrar"],
[r'''CF.{Username}: (.*)$''', "username"],
]

def get_days(expire_date):
    try:
        if len(expire_date) < 11:
            target_time = \
            int(time.mktime(time.strptime(expire_date,"%m/%d/%Y")))
        else:
            target_time = \
            int(time.mktime(time.strptime(expire_date,"%m/%d/%Y %H:%M:%S")))
        current_time = int(time.time())
        delta_time = timedelta(seconds=target_time - current_time)
        return int(delta_time.days)
    except:
        return 0

def get_list():
    #print "executing get_list function"
    command = "/usr/local/bin/rt list -l -t asset \"Type = \'Domain\' AND Status != \'retired\' OR Type = \'SSLCert\' AND Status != \'retired\'\" "
    run = Popen(command, shell=True,
                stdout=PIPE, stderr=PIPE)
    domain_name = ""
    expire_date = ""
    registrar = ""
    username = ""
    domain_list = []
    sorted_domain_list = []

    for record in re.split(r'''\n\n--\n\n''', run.stdout.read()):
        domain_name = ""
        for reg_ex, title in rx_mapper:
            match = re.search(reg_ex, record, re.MULTILINE)
            if match != None:
                if title == "name":
                    domain_name = match.group(1).rstrip()
                elif title == "expire_date":
                    expire_date = match.group(1).rstrip()
                elif title == "registrar":
                    registrar = match.group(1).rstrip()
                elif title == "username":
                    username = match.group(1).rstrip()
        #print "domain ",domain_name," expire: ",expire_date
        if get_days(expire_date) <= days_til_expiration:
            domain_list.append({ "domain_name": domain_name, \
                                         "expire_date": expire_date, \
                                         "registrar": registrar, \
                                         "username": username, \
                                         "days": get_days(expire_date)})
            #print domain_list[domain_name]
    for key in sorted(domain_list, key=operator.itemgetter("days")):
        sorted_domain_list.append(key)
    return sorted_domain_list

def send_mail(content,subject,send_to):
    #print "executing send_mail function"
    #MAIL = "/bin/mailx"
    #pp = os.popen("%s \"%s\" -s \"%s\" -v" % (MAIL, send_to, subject),"w")
    #result = "Hi,\nThe following domains/SSL will be expired soon:\n\n" + content
    #pp.write(result)
    #exitcode = pp.close()
    #if exitcode:
    #    return "Exit code is %s" % exitcode
    msg = MIMEText(content)
    msg['Subject'] = subject
    msg['From'] = 'Domain Reporter \
        <TechnologyPlatform@gorillanation.com>'
    msg['To'] = send_to
    send = smtplib.SMTP('localhost')
    send.sendmail(msg['From'], [msg['To']], msg.as_string())
    send.quit()

def main():
    #print "executing main function"
    description = "A domain expiration report generator"
    version = "%prog " + __version__
    parser = optparse.OptionParser(description=description, version=version)
    parser.set_defaults(verbose=False)
    parser.add_option('--recipient', '-r',
                         help='Recipient (if set an email will be sent)')
    options, arguments = parser.parse_args()
    RECIPIENT = str(options.recipient)
    server_list = get_list()
    expired_count = len(server_list)
    #print "exp count", expired_count
    content = ""
    for record in server_list:
        content += "Domain Name/SSL :" + record["domain_name"] + "\n\r"
        content += "Expired in :" + str(record["days"]) + " days\n\r"
        content += "Expired Date :" + record["expire_date"] + "\n\r"
        content += "Registrar :" + record["registrar"] + "\n\r"
        content += "Username :" + record["username"] + "\n\r\n\r\n\r"
    if RECIPIENT == "None":
        print content
    else:
        if expired_count > 0:
            send_mail(content, "Monthly Domain Expired List: " + str(expired_count) + " items expiring", RECIPIENT )
    
if __name__ == "__main__":
    main()
