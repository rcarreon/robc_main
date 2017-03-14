#!/usr/bin/env python

# -*- coding: utf-8 -*-
import glob,socket,urllib,json,re,sys
import smtplib
from email.MIMEText import MIMEText

path = "/opt/apache-flume/"
conf = "/etc/apache-flume/flume.conf"

def grep(s,pattern):
    return re.findall(r'^.*%s.*?$'%pattern,s,flags=re.M)

def send_mail(content,subject,send_to):
    msg = MIMEText(content)
    msg['Subject'] = subject
    msg['From'] = 'Flume Monitor\
        <dba@evolvemediallc.com>'
    msg['To'] = send_to
    send = smtplib.SMTP('localhost')
    send.sendmail(msg['From'], msg['To'].split(","), msg.as_string())
    send.quit()

alist = grep(open(conf,'r').read(),"http.monitoring.port")

if (alist):
    hostname = socket.gethostname()
    for fname in glob.glob(path + "flume-http-monitoring-*.count"):
        port = fname[40:-6]
        url = "http://" + hostname + ":" + port + "/metrics"
        previous_total = open(path + "flume-http-monitoring-" + port + ".count",'r').read()

        for aname in alist:
            if grep(aname,port):
                agent_name=aname.split(".",1)[0]

        response = urllib.urlopen(url)
        data = json.loads(response.read())
        for i in data:
            if (i[:6] == "SOURCE"):
                current_total = data[i]['EventReceivedCount']
                current = open(path + "flume-http-monitoring-" + port + ".count",'w')
                current.write("%s" % (current_total))
                current.close()
                break

        if (int(current_total)-int(previous_total) < 10):
            env = str.split(hostname,'.')[-4]
            content = "\r\nWARNING \r\n\r\n \
            Please check the source events for: \n\n \
            Agent  '%s' on %s \r\n \
            Events received since last check: %s \r\n \
            \n\n-Flume Monitor." % (agent_name, hostname, str(int(current_total)-int(previous_total)))
            send_to = "dba@evolvemediallc.com,origintech@evolvemediallc.com"
            subject = "[FLUME " + env.upper() + "] Agent stopped receiving events"
            send_mail(content,subject,send_to)
