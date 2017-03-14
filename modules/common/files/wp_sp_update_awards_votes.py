#!/usr/bin/python
# -*- coding: utf-8 -*-
import mysql.connector, base64, smtplib, sys, datetime, getopt, string, re, traceback
from mysql.connector.errors import Error
from datetime import date, timedelta, time
from email.mime.application import MIMEApplication
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
from email.utils import COMMASPACE, formatdate

class Connect:
    def __init__(self, env):
        self.connection_string = {
            "user"     : "dbops",
            "password" : "evolvegenius987",
            "host": "sql1v-56-wp.ao.{0}.lax.gnmedia.net".format(env),
            "database": "wp_pb_awards_totalbeauty"
        }

    def execute_query(self, query):
        cnx = mysql.connector.connect(**self.connection_string)
        #print self.connection_string
        cur = cnx.cursor()
        for result in cur.execute(query, multi = True):
          pass
          #print result
        cnx.commit()
        cur.close()
        cnx.close()

def main(argv):

    try:
        opts, args = getopt.getopt(argv,"e:",["env="])
    except getopt.GetoptError:
        print 'wp_sp_update_awards_votes.py -e <dev|stg|prd>'
        sys.exit(2)

    for opt, arg in opts:
        if opt in ('-e', '--env'):
            env = arg
  
    cn = Connect(env)
    now  = datetime.datetime.now().time()

    if now <= time(01,00):
        #print "Is the first of the day i will process yesterdays's data"
        start_date = (datetime.datetime.today() - datetime.timedelta(days=1)).strftime('%Y-%m-%d')
        end_date = datetime.datetime.today().strftime('%Y-%m-%d')
    else:
        #print "Will process current day's data"
        start_date = datetime.datetime.today().strftime('%Y-%m-%d')
        end_date = (datetime.datetime.today() + datetime.timedelta(days=1)).strftime('%Y-%m-%d')

    try:
        query="CALL wp_sp_update_awards_votes('{0} 00:00:00','{1} 00:00:00');".format(start_date, end_date) 
        #print query
        cn.execute_query(query)
    except mysql.connector.Error as err:
        print("Something went wrong: {0}".format(err))
    
if __name__ == "__main__":
   main(sys.argv[1:])
