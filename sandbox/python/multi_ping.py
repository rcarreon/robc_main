#!/bin/python
#!/usr/bin/env python

import subprocess
import threading
import re
import json
import paramiko
import sys 
import smtplib
import webbrowser
from email.mime.text import MIMEText
import wave
import struct
import random 
import argparse
import pyaudio
import urllib2
from urlparse import urlparse
import gi
gi.require_version('Notify', '0.7')
from gi.repository import Notify
import time 

chunk = 1024
### We need to generate a dictionare for the string  for each site -- do this during graveyard! -- 
strings = {'admin.sherdog.com':'Connected successfully','www.craveonline.com':'81f1107463d5e188739a27bccd18dab9','forums.thefashionspot.com':'058526dd2635cb6818386bfd373b82a4','microsites.gorillanation.com':'microsites.gorillanation.com','pubops.evolvemediacorp.com':'0caddf8502437caa3be1c97cd25b89a1','publishers.springboard.gorillanation.com':'Forgot Password','www.gamerevolution.com':'9825918b2b361fb0e003f4935ce18ae6','www.craveonlinemedia.com':'7969b4f244a918da8ee9de80341c066b','hfboards.com':'e4251c93e2ba248d29da988d93bf5144','www.hockeysfuture.com':'bc2ae3134a3dd058ed8105843eaa87e4','www.idontlikeyouinthatway.com':'22d45bdc067561dba9c385ff3f5352c8','www.sherdog.com':'Sherdog.com is a property of','www.sherdog.net':'is a property of','www.sherdogvideos.com':'','www.thefashionspot.com':'9269efc11618653b8a079a0ac376e69a','www.wrestlezone.com':'851cc24eadecaa7a82287c82808f23d0','geo.gorillanation.com':'gn_country','vpn.gorillanation.com':'Username','cms.springboard.gorillanation.com':'allow-access-from domain','forums.wrestlezone.com':'afb8e5d7348ab9e99f73cba908f10802','origin.assets.gorillanation.com':'assets.gorillanation.com','origin.assets.craveonline.com':'assets.craveonline.com','microsites.craveonline.com':'microsites.craveonline.com','www.momtastic.com':'b24acb040fb2d2813c89008839b3fd6a','sherdog.com':'Sherdog.com is a property of','comingsoon.net':'df292225381015080a5c6c04a6e2c2dc','training.sherdog.com':'98990d7e939e4a8d26c6e6b539094b9c','forums.superherohype.com':'dee460792f24517621e3ca080805de7e','www.liveoutdoors.com':'68ec033d54c4f3b1ca4aca7f4c1e01ca','widget.crowdignite.com/widgets/36':'CI-Zerg','triggertag.gorillanation.com':'TriggerTag','www.superherohype.com':'d254514d58fda348db17b12227af3867','www.babyandbump.com':'c48fb0faa520c8dfff8c4deab485d3d2','campaigns.craveonline.com':'campaigns.craveonline.com','campaigns.actiontrip.com':'campaigns.actiontrip.com','campaigns.comingsoon.net':'campaigns.comingsoon.net','campaigns.evolvemediacorp.com':'campaigns.evolvemediacorp.com','campaigns.gamerevolution.com':'campaigns.gamerevolution.com','campaigns.globetrottingdigitalmedia.com':'campaigns.globetrottingdigitalmedia.com','campaigns.gorillanation.com':'campaigns.gorillanation.com','campaigns.liveoutdoors.com':'campaigns.liveoutdoors.com','campaigns.momtastic.com':'campaigns.momtastic.com','campaigns.sherdog.com':'campaigns.sherdog.com','campaigns.springboardvideo.com':'campaigns.springboardvideo.com','campaigns.superherohype.com':'campaigns.superherohype.com','campaigns.thefashionspot.com':'campaigns.thefashionspot.com','campaigns.totallyher.com':'campaigns.totallyher.com','campaigns.youthologymedia.com':'campaigns.youthologymedia.com','webecoist.com':'c860c0135746db40fcbcf7e4ce4808b6','analytics.springboardvideo.com':'','origin-akamai.sherdog.com':'98990d7e939e4a8d26c6e6b539094b9c','webservices.evolvemediacorp.com':'2012 All Right','www.springboardplatform.com':'All Rights Reserved','wholesomebabyfood.momtastic.com':'b34086dc6007987c015178dd20871b7a','www.realitytea.com':'0f53d3d4577b5763f618949fdfd65ade','m.sherdog.com':'2017 All Rights Reserved.','origin-akamai.m.sherdog.com':'is a property of','www.playstationlifestyle.net':'e648000e5cd42cece065ea6b2f880692','home.springboardplatform.com':'All Rights Reserved','forums.sherdog.com':'is a property of','mumtastic.com.au':'886fac40cab09d6eb355eb6d60349d3c','evolvemediallc.com':'All Rights Reserved. EVOLVE MEDIA, LLC','idly.craveonline.com':'fc2df264294aaa0a8b854e856a84a2ec','forums.playstationlifestyle.net':'c4568df34a4eab80a0d9879fe9bce549','test.gorillanation.com':'','webecoist.momtastic.com':'498e6e663c8b7ecce565ee3818a6ba99','craveonline.com.au':'e515715cc11bfd2d7009dd73cfdbe162','craveonline.ca':'630c2418a1cab4c8f99991b8657516a3','craveonline.co.uk':'bf8a6c0d3e406dfcff758c00f8179ae8','origin.originplatform.com':'e3f0db1e5aca8c4ad784b726c27c9388','afterellen.com':'6ac7804500c6bbac0d90a0fe8c68e7d8','totalbeauty.com':'e4ea8133a649aad124e80f99f8831005','beautyriot.com':'1cf554775f0077076d7b71e563042308','dogtime.com':'','cattime.com':'44e5bb901650ec61e9e0af1ff1bef5fe','mediaads.gorillanation.com/test_sites/index.php':'','adopt.dogtime.com':'','rmdemo.evolvemediacorp.com':'','tags.evolvemediallc.com/websites/evolve_tags/1':'','stg.tags.evolvemediallc.com/websites/evolve_tags/1024':'','awards.totalbeauty.com/awards2016':'an Evolve Media, LLC company','www.pregnancyforum.co.uk':'Pregnancy Forum - The Pregnancy Community','martini.media':'passion-based','www.totallyhermedia.com':'23321ccc63b26ac760ef525e1c1cf37c','widget.crowdignite.com/widgets/32499':'zergnet-widget','flow.evolvemediallc.com':'ed1404e7ff5536e16edc6c904f6ffe78','showcase.evolvemediallc.com':'759de302dcdf08a4a052745d32064a6f'}


####
#### Function to crawl the site and seek for string  ###

def html_string(rsite):
    #code = print urllib.urlopen("http://"+ rsite).getcode()
    #if code == 200:
        site = urllib2.urlopen('http://'+rsite).read()
        vrsite = strings.get(rsite)
        #print   vrsite
        #print "aqui ando %s " % vrsite
        #if vrsite == '':
        #     print "String for %s was empty" % rsite
        #     return 1
        match = re.findall(str(vrsite), site)
        ## Compare the length  if less that 0 not, found. 
        #print len(match)
        if len(match) > 4:
            print 'string not found,site prob down..'
            return 1
        else:
            print 'string "%s" found for "%s", all good' % (vrsite, rsite)
            return 0
    #else:
    #    print code

class Alertas(object):
    #Making sounds ! 
    #open a wav format for Critical --alerts.wav--  
    def critical(self):
        critical = wave.open(r"/home/rcarreon/sandbox/python/alerts.wav","rb")  
        #instantiate PyAudio  
        p = pyaudio.PyAudio()  
        #open stream  
        stream = p.open(format = p.get_format_from_width(critical.getsampwidth()),  
                channels = critical.getnchannels(),  
                rate = critical.getframerate(),  
                output = True)  
        #read data  
        data = critical.readframes(chunk)  
        #play stream  
        while data:  
            stream.write(data)  
            data = critical.readframes(chunk)  
        #stop stream  
        stream.stop_stream()  
        stream.close()  
        #close PyAudio  
        p.terminate()  
    def warning(self):
            warning = wave.open(r"/home/rcarreon/sandbox/python/alert2.wav","rb")
            #instantiate PyAudio  
            p = pyaudio.PyAudio()
            #open stream  
            stream = p.open(format = p.get_format_from_width(warning.getsampwidth()),  
                channels = warning.getnchannels(),
                rate = warning.getframerate(),
                output = True)
        #read data  
            data = warning.readframes(chunk)
        #play stream  
            while data:
                stream.write(data)
                data = warning.readframes(chunk)
        #stop stream  
            stream.stop_stream()
            stream.close()
        #close PyAudio  
            p.terminate()

def emailing(msg):
    ##### sending email #####
    ### if any errors comes up first check sendmail and postfix service are running ####
    sender = 'rcarreon@rcarreon'
    receivers = ['roberto.carreon@evolvemediallc.com']
    try:
       smtpObj = smtplib.SMTP('localhost')
       smtpObj.sendmail(sender, receivers, msg)         
       print "Successfully sent email"
       smtpObj.quit()
    except SMTPException:
       print "Error: unable to send email"

class Pinger(object):
    status = {'alive': [], 'dead': []} # Populated while we are running
    hosts = [] # List of all hosts/ips in our input queue

    # How many ping process at the time.
    thread_count = 4

    # Lock object to keep track the threads in loops, where it can potentially be race conditions.
    lock = threading.Lock()

    def ping(self, ip):
        # Use the system ping command with count of 1 and wait time of 1.
        ret = subprocess.call(['ping', '-c', '1', '-W', '1', ip],
                              stdout=open('/dev/null', 'w'), stderr=open('/dev/null', 'w'))
        return ret == 0 # Return True if our ping command succeeds
    def pop_queue(self):
        ip = None
        self.lock.acquire() # Grab or wait+grab the lock.
        if self.hosts:
            ip = self.hosts.pop()
        self.lock.release() # Release the lock, so another thread could grab it.
        return ip
    def dequeue(self):
        while True:
            ip = self.pop_queue()
            if not ip:
                return None
            result = 'alive' if self.ping(ip) else 'dead'
            self.status[result].append(ip)
    def start(self):
        threads = []
        for i in range(self.thread_count):
            # Create self.thread_count number of threads that together will
            # cooperate removing every ip in the list. Each thread will do the
            # job as fast as it can.
            t = threading.Thread(target=self.dequeue)
            t.start()
            threads.append(t)
        # Wait until all the threads are done. .join() is blocking.
        [ t.join() for t in threads ]
        return self.status
if __name__ == '__main__':
    criticals = [] 
    warnings = []
    domains = []
#    domains2 = []
    ping = Pinger()
    ping.thread_count = 8
###  Putting the hosts from a file in a list ###
    ping.hosts = [line.strip() for line in open("rt_sites", 'r')]
#   ping.hosts = [
#        '10.0.0.1', '10.0.0.2', '10.0.0.3', '10.0.0.4', '10.0.0.0', '10.0.0.255', '10.0.0.100',
#        'google.com', 'github.com', 'nonexisting', '127.0.1.2', '*not able to ping!*', '8.8.8.8'
#        ]
    resultado = ping.start()
    ##### THIS WAY YOU PRINT VALUES OF A KEY IN A DICTIONARY IN PYTHON!!!  ###
    #print resultado['alive']
    ###############################
    alerta = Alertas()
def chequeo():
    if resultado['dead']:
        #alerta.critical()
        f = open('ping_hosts', 'w')
        ### write to file using json notation for further strip ###
        f.write (json.dumps(resultado['dead']))
        f.close
    with open ('ping_hosts', 'r') as f:
        for line in f: 
            for site in line.split():
                ### regex substitution, removing unsed characters trailed by the dict ###
                rsite = re.sub('[\[\]"\,]','',site)
                ## site unresponsive prob because of the uri, checking string ###
                print rsite, 'is unresponsive to ping, checking string '  
                html_status = html_string(rsite) 
                if html_status == 1:
                    parsed_uri = urlparse('http://'+rsite)
                    domain = '{uri.scheme}://{uri.netloc}'.format(uri=parsed_uri)
                    #print "aqui ando " + domain
                    domains.append(domain)
                    for x in domains:
                        ## We have the sites  that didnt have the string, we need to ping them 
                        urls = re.sub("http://","",x)            
                        reto = subprocess.call(['ping', '-c', '1', '-W', '1', urls], 
                        stdout=open('/dev/null', 'w'), stderr=open('/dev/null', 'w'))
                        #print "sitio "+ urls + " esta abajo"
                        if reto != 0:
                        ## by now we have the sites that dont have string and didnt responded to ping   will fill up  the criticals list ##
                            criticals.append(urls)
                            if criticals:    
                                for m in criticals:
                                    dom = re.sub('[\[\]"\,]','',m)
                                    print "Sites down: " + dom
                                    print "Mandando correos por que %s esta abajo " % dom
                        else:
                        ### Sites responsive but without string , fill up the warnings list
                            warnings.append(urls)
                            print "Site %s is responsive but dont have string " % x
                else: 
                    print "Sitio %s is fine " % rsite

    if criticals: 
        critical = Notify.Notification.new("Critical!")
        critical.show()
#    import time 
#    time.sleep(5)
        alerta.critical()
        for t in criticals:
            print "Sending emails because %s is DOWN " % t
            subject =  'Host %s is Down check on it ! ' % t 
            msg = 'Subject: %s \n\n Host %s is DOWN look it up!!!' % (subject, t)
            emailing(msg) 

    if warnings:
        def sendmessage():
            Notify.init("Check for Sites")
            message = "String missing for %s " % warnings
            warning = Notify.Notification.new("Warning! string missing for these sites: ",message)
            warning.add_action("ackd", "Acknowledge",ok)
            warning.add_action("ignore", "Ignore",ignore)
            warning.show()
        def ok():
            pass
        def ignore():
            pass
#### The Following lines are to add a button to the notification, need to be worked on ###
#               warning.add_action("ackd", "Ack'd",ackdd,'w2')
#               warning.add_action("not ackd", "Not Ack'd", ack)
#               warning.add_action("Dissmised", "Dissmissed", ack)
### Buttons ###
        sendmessage()
        alerta.warning()
        for k in warnings:
            print "Sending emails because %s doesnt have  string but is responsive " % k
            subject =  'Host %s is missing monitoring string check on it ! ' % k  
            msg = 'Subject: %s \n\n Host %s is missing monitoring string look it up!!!' % (subject, k)
           # emailing(msg)  
#                         alerta.warning()
#    for y in domains:
#         ## msg for email to send using emailing function, sent msg which contains subject and site
#         print "Mandando correos por que "+ y + " esta abajo"
#         #    subject =  'Host %s is Down check on it ! ' % y 
#         #    msg = 'Subject: %s \n\n Host %s is DOWN look it up!!!' % (subject, y)
#         #    emailing(msg) 
chequeo()

#print strings['admin.sherdog.com']
#print strings['www.craveonline.com']
