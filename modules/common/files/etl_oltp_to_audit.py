#!/usr/bin/env python

import sys, getopt
import commands
import smtplib
from base64 import b64decode
from email.mime.text import MIMEText

db_extract = {
    'user': 'etl_ci_extract',
    'password': "NGNNNkxWQ1g="
}

db_load = {
    'user': 'etl_ci_load',
    'password': "T0Z2REh5SXg="
}

environment = ''

email = {
  'to': 'DBA<dba@evolvemediallc.com>',
  'from': 'MySQL ETL<mysql@app1v-dbops.tp.prd.lax.gnmedia.net>',
  'subject': '',
  'text': ''
}

sql_ci_host = {
    'dev'   : 'sql1v-56-ci.ci.dev.lax.gnmedia.net',
    'stg'   : 'VIP-SQLRO-CI.CI.STG.LAX',
    'prd'   : 'VIP-SQLRO-CI.CI.PRD.LAX'
}

sql_dw_host = {
    'dev'   : 'sql1v-56-dw.ci.dev.lax.gnmedia.net',
    'stg'   : 'VIP-SQLRW-DW.CI.STG.LAX',
    'prd'   : 'VIP-SQLRW-DW.CI.PRD.LAX'
}

sql_audit_host = {
    'dev'   : 'sql1v-56-audit.ci.dev.lax.gnmedia.net',
    'stg'   : 'VIP-SQLRW-AUDIT.CI.STG.LAX',
    'prd'   : 'VIP-SQLRW-AUDIT.CI.PRD.LAX'
}

def usage():
    print 'Usage: '+sys.argv[0]+' -e <environment>'
    sys.exit(2)


def validOpt(options):
    global environment
    for opt, arg in options:
        if opt in ("-H", "--help"):
            usage()
        elif opt in ("-e", "--environment"):
            environment = arg

    if (environment == ''):
        print "Environment is required"
        usage()
    else:
        return True

def sendEmail():
    msg = MIMEText(email['text'])
    msg['Subject'] = email['subject']
    msg['From'] = email['from']
    msg['To'] = email['to']
    s = smtplib.SMTP('localhost')
    s.sendmail(email['from'], email['to'], msg.as_string())
    s.quit()

def sync_pages_table():
    try:

        sql = "SELECT CONCAT('REPLACE INTO pages(id, domain_bitfield, title_url, created) VALUES(', id, ',', domain_bitfield, ',''', title_url, ''',''', created, ''');') FROM pages WHERE status = 0 AND title_url IS NOT NULL"
        command = "mysql tewn -h %s -u %s -e \"%s\" -p%s -Ns | mysql audit -h %s -u %s -p%s"\
                  % (sql_ci_host[environment], db_extract['user'], sql.replace('"', '\\"'), b64decode(db_extract['password']),sql_audit_host[environment], db_load['user'], b64decode(db_load['password']))
        output = commands.getstatusoutput(command)

        if output[0] != 0:
            email['text'] = "ETL from pages table between OLTP Cluster and Audit Cluster get an error \n\t%s" % (output[1])
            email['subject'] = "%s:CI-ERROR [ETL pages table]" %(environment.upper())
            sendEmail()

        return True
    except:
        return False

def remove_old_pages():
    try:

        sql = "DELETE FROM pages WHERE updated < DATE_SUB(CURRENT_TIMESTAMP,INTERVAL 60 MINUTE)"
        command = "mysql audit -h %s -u %s -p%s -e \"%s\""\
                  % (sql_audit_host[environment], db_load['user'], b64decode(db_load['password']), sql)
        output = commands.getstatusoutput(command)

        if output[0] != 0:
            email['text'] = "ETL from pages table on Audit Cluster can't remove old data and get an error \n\t%s" % (output[1])
            email['subject'] = "%s:CI-ERROR [ETL pages table]" %(environment.upper())
            sendEmail()

        return True
    except:
        return False



def main(argv):
    try:
        opts, args = getopt.getopt(argv, 'Hh:e:', ['help','environment='])
        if not opts:
            print 'No options given'
            usage()
        elif validOpt(opts):
            sync_pages_table()
            remove_old_pages()
    except getopt.GetoptError,e:
        print e
        usage()

if __name__ =='__main__':
    main(sys.argv[1:])