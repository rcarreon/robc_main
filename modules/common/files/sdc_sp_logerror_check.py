#!/usr/bin/python
import sys, getopt
import commands
import mysql.connector
import string
import smtplib
from base64 import b64decode
from email.mime.text import MIMEText
from datetime import datetime, timedelta

db = {
  'user': 'dbops',
  'password': 'ZXZvbHZlZ2VuaXVzOTg3',

}
email = {
  'to': 'dba@evolvemediallc.com',
  'from': 'mysql@app1v-dbops.tp.prd.lax.gnmedia.net',
  'subject': '[sdc-sp-errorlog]',
  'text': '',
}
master = {
  'host': 'sql1v-56-sdc.ao.prd.lax.gnmedia.net',
  'databases': 'db_system',
  'table': 'sp_log_error'
}
slave = []

def searchError():
    try:
        one_hours_less = datetime.now() + timedelta(hours=-1)
        qry = "SELECT db_name, user_name, called, created FROM db_system.sp_log_error WHERE created >= '" + format(one_hours_less, '%Y-%m-%d %H:%M:%S') + "';"
        for item in sorted(slave):
            cnx1 = mysql.connector.connect(host=item, user=db['user'], password=b64decode(db['password']))
            cur1 = cnx1.cursor()
            cur1.execute(qry)
            if cur1.with_rows:
                rows = cur1.fetchall()
                if rows:
                    email['text'] = email['text'] + "\n\n" + string.upper(item)
                    for row in rows:
                        email['text'] = email['text'] + "\n\tdb: " + row[0] + "\tuser: " + row[1] + "\t\tcall: " + str(row[2]) + "\t\ttime: " + str(row[3])
            cur1.close()
            cnx1.close()
            cnx1.disconnect()
    except mysql.connector.Error as err:
        print "Can't open mysql connection %s " + str(err)
        email['subject'] = email['subject'] + "-[ERROR]"
        email['text'] = email['text'] + "\n" +  "Can't open mysql connection %s " + str(err)
    except:
        print "Can't execute query %s" + str(sys.stderr)
        email['subject'] = email['subject'] + "-[ERROR]"
        email['text'] = email['text'] + "\n" +  "Can't open mysql connection %s " + str(err)

def getSlave():
    next = True
    while next:
        tot = len(slave)
        for server in slave:
            cnx1 = mysql.connector.connect(host=server, user=db['user'], password=b64decode(db['password']))
            cur1 = cnx1.cursor()
            qry = ("SHOW SLAVE HOSTS;")
            cur1.execute(qry)
            if cur1.with_rows:
                rows = cur1.fetchall()
                for row in rows:
                    exist = False
                    for x in slave:
                        if (x == row[1]):
                            exist = True
                            break
                    if not exist:
                        slave.append(row[1])
            cur1.close()
            cnx1.close()
            cnx1.disconnect()
        if len(slave) > tot:
            next = True
        else:
            next = False

def sendEmail():
    if email['text']:
        print email['text']
        email['subject'] = email['subject'] + " DB:" + master['databases']
        msg = MIMEText(email['text'])
        msg['Subject'] = email['subject']
        msg['From'] = email['from']
        msg['To'] = email['to']
        s = smtplib.SMTP('localhost')
        s.sendmail(email['from'], email['to'], msg.as_string())
        s.quit()

def initial():
    try:
        slave.append(master['host'])
        getSlave()
        searchError()
    except getopt.GetoptError,e:
        print e
        sys.exit(2)
    # print email['text']
    sendEmail()
    sys.exit()

def main():
    try:
        initial()
    except getopt.GetoptError,e:
        print e
        sys.exit(2)

if __name__ =='__main__':
    main()