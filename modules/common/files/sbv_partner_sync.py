#!/usr/bin/python
import mysql.connector, base64, smtplib, datetime, time, sys, getopt, string, re, traceback
from mysql.connector.errors import Error
from email.mime.text import MIMEText

class EmailManager():

    def __init__(self):
        self._from = "MYSQL<mysql@app1v-dbops.tp.prd.lax.gnmedia.net>"
        self._to = "dba <dba@evolvemediallc.com>"
        self._subject = "SBV [Partner Sync]"
        self._body = ""

    def set_body(self, result):
        self._body = result

    def send_alert(self):
        msg = MIMEText(self._body)
        msg["From"] = self._from
        msg["To"] = self._to
        msg["Subject"] = self._subject

        if (self._body != ""):
            sender = smtplib.SMTP("localhost")
            sender.sendmail([self._from], self._to, msg.as_string())
            sender.quit()

class PartnerSync():

    def myconn(self, hostname):
        self.connection_string = {
            "user"     : "dbops",
            "password" : base64.b64decode("ZXZvbHZlZ2VuaXVzOTg3"),
            "host": hostname,
            "database": "db_system"
        }

    def get_partner_list(self, hostname):
        #Create connection in SOURCE host        
        self.myconn(hostname)
        cnx = mysql.connector.connect(**self.connection_string)
        cur = cnx.cursor()
        partner_list= []
        query = "SELECT partner_id, partner_name FROM db_system.partners"
        cur.execute(query)
        for (result) in cur:
            #Append each result to a list
            partner_list.append(result)
        cur.close()
        cnx.close()
        cnx.disconnect()

        return partner_list

    def create_partner_schema(self, partner_info, hostname):
        v_o1="@o_result_data"
        v_o2="@o_result"
        #Create connection in DESTINATION host
        self.myconn(hostname)
        cnx = mysql.connector.connect(**self.connection_string)
        cur = cnx.cursor()
        query = "CALL db_system.sp_partner_schema_create(%i , \"%s\", %s, %s)"%(partner_info[0], partner_info[1], v_o1, v_o2)
        cur.execute(query)
        #print  "CALL db_system.sp_partner_schema_create(%i , \"%s\", %s, %s)"%(partner_info[0], partner_info[1], v_o1, v_o2)
        cnx.commit()
        cur.close()
        cnx.close()
        cnx.disconnect()

def main(argv):
    
    try:
        opts, args = getopt.getopt(argv,"s:d:",["sourcehost=","desthost="])
    except getopt.GetoptError:
        print 'partition_monitor.py --sourcehost <hostname> --desthost <hostname>'
        sys.exit(2)

    for opt, arg in opts:
        if opt in ('-s', '--sourcehost'):
            host_src = arg
        if opt in ('-d', '--desthost'):
            host_dst = arg
   
    #SOURCE
    #PRDhost_src = "sql1v-56-stats-cms.sbv.prd.lax.gnmedia.net"
    #DESTINATION
    #host_dst = "sql1v-56-stats-cms.sbv.stg.old.gnmedia.net"
    
    email = EmailManager()

    try:
        db_sync = PartnerSync()
        partner_src = db_sync.get_partner_list(host_src)
        total_src = len(partner_src)
    
        partner_dst = db_sync.get_partner_list(host_dst)
        total_dst = len(partner_dst)
        
        #Subtract src partners from dst (so only new will be created)
        dif_list = set(partner_src) - set(partner_dst)
        dif_list = list(dif_list)
    
        #If no differences were found no partners will be created and no email will be sent           
        if(len(dif_list)>0):
            body="Source: %s (%i partners found) \n"%(host_src, total_src)
            body+="Destination: %s (%i partners found) \n"%(host_dst, total_dst)
            body+="Partners to sync %i \n\n"%(len(dif_list)) 
            body+="Partner(s) created in %s: \n"%(host_dst)
        
            for partner_info in sorted(dif_list):
                #Call function to create schema in DEST HOST
                db_sync.create_partner_schema(partner_info, host_dst)
                body +="\t %i %s \n"%(partner_info[0],partner_info[1])
    
            email.set_body(body)        
            email.send_alert()
            
    except: # catch *all* exceptions
        traceback.format_exc()
        body = traceback.format_exc()
        email.set_body(body)        
        email.send_alert()
   
if __name__ == "__main__":
   main(sys.argv[1:])
