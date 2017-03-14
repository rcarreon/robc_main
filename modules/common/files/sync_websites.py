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


def sync_websites_table():
    try:

        sql = "SELECT CONCAT('INSERT LOW_PRIORITY INTO websites(id, domain_primary, status, visible, name, category, tier, user_id, account_id, content_rating, demographic_sex) VALUES(', id, ',', domain_primary, ',', IFNULL(status, 2), ',', IFNULL(visible, 0), ',''', IFNULL(REPLACE(name, \"'\", \"''\"), ''), ''', ', IFNULL(category, -1), ',', tier, ',', IFNULL(user_id, 0), ',', IFNULL(account_id, 0), ',', IFNULL(content_rating, -1), ',',  IFNULL(demographic_sex, -1), ') ON DUPLICATE KEY UPDATE name = VALUES(name), domain_primary = VALUES(domain_primary), status = VALUES(status), visible = VALUES(visible), category = VALUES(category), tier = VALUES(tier), user_id = VALUES(user_id), account_id = VALUES(account_id), content_rating = VALUES(content_rating), demographic_sex = VALUES(demographic_sex);') FROM websites"
        command = "mysql tewn -h %s -u %s -e \"%s\" -p%s -Ns | mysql warehouse -h %s -u %s -p%s"\
                  % (sql_ci_host[environment], db_extract['user'], sql.replace('"', '\\"'), b64decode(db_extract['password']),sql_dw_host[environment], db_load['user'], b64decode(db_load['password']))
        output = commands.getstatusoutput(command)

        if output[0] != 0:
            email['text'] = "ETL from websites table between OLTP Cluster and Data Warehouse get an error \n\t%s" % (output[1])
            email['subject'] = "%s:CI-ERROR [ETL websites table]" %(environment.upper())
            sendEmail()
        return True
    except:
        return False

def sync_widgets_table():
    try:

        sql = "SELECT CONCAT('INSERT LOW_PRIORITY INTO widgets(id, domain_bitfield, status, visible, website_id, name) VALUES(', id, ',', domain_bitfield, ',', IFNULL(status, 2), ',', visible, ',', website_id, ',''', IFNULL(REPLACE(name, \"'\", \"''\"), ''), ''') ON DUPLICATE KEY UPDATE name = VALUES(name), domain_bitfield = VALUES(domain_bitfield), status = VALUES(status), visible = VALUES(visible), website_id = VALUES(website_id);') FROM widgets"
        command = "mysql tewn -h %s -u %s -e \"%s\" -p%s -Ns | mysql warehouse -h %s -u %s -p%s"\
                  % (sql_ci_host[environment], db_extract['user'], sql.replace('"', '\\"'), b64decode(db_extract['password']),sql_dw_host[environment], db_load['user'], b64decode(db_load['password']))
        output = commands.getstatusoutput(command)

        if output[0] != 0:
            email['text'] = "ETL from widgets table between OLTP Cluster and Data Warehouse get an error \n\t%s" % (output[1])
            email['subject'] = "%s:CI-ERROR [ETL widgets table]" %(environment.upper())
            sendEmail()

        return True
    except:
        return False


def sync_accounts_table():
    try:

        sql = "SELECT CONCAT('INSERT LOW_PRIORITY INTO accounts(id, user_id, domain_bitfield, status, website_id, paid, refer_transfer_rate, incoming, outgoing) VALUES(', id, ',', IFNULL(user_id, 0), ',', IFNULL(domain_bitfield, 0), ',', IFNULL(status, 0), ',', IFNULL(website_id, 0), ',', IFNULL(paid, 0), ',', IFNULL(refer_transfer_rate,0), ',', IFNULL(incoming,0), ',', IFNULL(outgoing,0), ') ON DUPLICATE KEY UPDATE paid = VALUES(paid), refer_transfer_rate = VALUES(refer_transfer_rate), domain_bitfield = VALUES(domain_bitfield), status = VALUES(status), website_id = VALUES(website_id), incoming = VALUES(incoming), outgoing = VALUES(outgoing), user_id = VALUES(user_id);') FROM accounts"
        command = "mysql tewn -h %s -u %s -e \"%s\" -p%s -Ns | mysql warehouse -h %s -u %s -p%s"\
                  % (sql_ci_host[environment], db_extract['user'], sql.replace('"', '\\"'), b64decode(db_extract['password']),sql_dw_host[environment], db_load['user'], b64decode(db_load['password']))
        output = commands.getstatusoutput(command)

        if output[0] != 0:
            email['text'] = "ETL from accounts table between OLTP Cluster and Data Warehouse get an error \n\t%s" % (output[1])
            email['subject'] = "%s:CI-ERROR [ETL accounts table]" %(environment.upper())
            sendEmail()

        return True
    except:
        return False


def sync_pages_table():
    try:

        sql = "SELECT CONCAT('INSERT LOW_PRIORITY INTO pages(id, website_id, category, status) VALUES(', id, ',', IFNULL(website_id, 0), ',', IFNULL(category, -1), ',', IFNULL(status, 2), ') ON DUPLICATE KEY UPDATE category = VALUES(category), status = VALUES(status), website_id = VALUES(website_id);') FROM pages WHERE category IS NOT NULL"
        command = "mysql tewn -h %s -u %s -e \"%s\" -p%s -Ns | mysql warehouse -h %s -u %s -p%s"\
                  % (sql_ci_host[environment], db_extract['user'], sql.replace('"', '\\"'), b64decode(db_extract['password']),sql_dw_host[environment], db_load['user'], b64decode(db_load['password']))
        output = commands.getstatusoutput(command)

        if output[0] != 0:
            email['text'] = "ETL from pages table between OLTP Cluster and Data Warehouse get an error \n\t%s" % (output[1])
            email['subject'] = "%s:CI-ERROR [ETL pages table]" %(environment.upper())
            sendEmail()

        return True
    except:
        return False


def sync_websites_to_audit():
    try:

        sql = "SELECT CONCAT('INSERT LOW_PRIORITY INTO oltp_websites(id, domain_primary, status, visible, name, category, tier, user_id, account_id, content_rating, demographic_sex) VALUES(', id, ',', domain_primary, ',', IFNULL(status, 2), ',', IFNULL(visible, 0), ',''', IFNULL(REPLACE(name, \"'\", \"''\"), ''), ''', ', IFNULL(category, -1), ',', tier, ',', IFNULL(user_id, 0), ',', IFNULL(account_id, 0), ',', IFNULL(content_rating, -1), ',',  IFNULL(demographic_sex, -1), ') ON DUPLICATE KEY UPDATE name = VALUES(name), domain_primary = VALUES(domain_primary), status = VALUES(status), visible = VALUES(visible), category = VALUES(category), tier = VALUES(tier), user_id = VALUES(user_id), account_id = VALUES(account_id), content_rating = VALUES(content_rating), demographic_sex = VALUES(demographic_sex);') FROM websites"
        command = "mysql tewn -h %s -u %s -e \"%s\" -p%s -Ns | mysql audit -h %s -u %s -p%s"\
                  % (sql_ci_host[environment], db_extract['user'], sql.replace('"', '\\"'), b64decode(db_extract['password']),sql_audit_host[environment], db_load['user'], b64decode(db_load['password']))
        output = commands.getstatusoutput(command)

        if output[0] != 0:
            email['text'] = "ETL from websites table between OLTP Cluster and Audit get an error \n\t%s" % (output[1])
            email['subject'] = "%s:CI-ERROR [ETL websites to Audit]" %(environment.upper())
            sendEmail()

        return True
    except:
        return False


def sync_widgets_to_audit():
    try:

        sql = "SELECT CONCAT('INSERT LOW_PRIORITY INTO oltp_widgets(id, domain_bitfield, status, visible, website_id, name) VALUES(', id, ',', domain_bitfield, ',', IFNULL(status, 2), ',', visible, ',', website_id, ',''', IFNULL(REPLACE(name, \"'\", \"''\"), ''), ''') ON DUPLICATE KEY UPDATE name = VALUES(name), domain_bitfield = VALUES(domain_bitfield), status = VALUES(status), visible = VALUES(visible), website_id = VALUES(website_id);') FROM widgets"
        command = "mysql tewn -h %s -u %s -e \"%s\" -p%s -Ns | mysql audit -h %s -u %s -p%s"\
                  % (sql_ci_host[environment], db_extract['user'], sql.replace('"', '\\"'), b64decode(db_extract['password']),sql_audit_host[environment], db_load['user'], b64decode(db_load['password']))
        output = commands.getstatusoutput(command)

        if output[0] != 0:
            email['text'] = "ETL from widgets table between OLTP Cluster and Audit get an error \n\t%s" % (output[1])
            email['subject'] = "%s:CI-ERROR [ETL widgets to Audit]" %(environment.upper())
            sendEmail()

        return True
    except:
        return False


def sync_pages_to_audit():
    try:

        sql = "SELECT CONCAT('INSERT LOW_PRIORITY INTO oltp_pages(id, website_id, category, status) VALUES(', id, ',', IFNULL(website_id, 0), ',', IFNULL(category, -1), ',', IFNULL(status, 2), ') ON DUPLICATE KEY UPDATE category = VALUES(category), status = VALUES(status), website_id = VALUES(website_id);') FROM pages WHERE category IS NOT NULL"
        command = "mysql tewn -h %s -u %s -e \"%s\" -p%s -Ns | mysql audit -h %s -u %s -p%s"\
                  % (sql_ci_host[environment], db_extract['user'], sql.replace('"', '\\"'), b64decode(db_extract['password']),sql_audit_host[environment], db_load['user'], b64decode(db_load['password']))
        output = commands.getstatusoutput(command)

        if output[0] != 0:
            email['text'] = "ETL from pages table between OLTP Cluster and Audit get an error \n\t%s" % (output[1])
            email['subject'] = "%s:CI-ERROR [ETL pages to Audit]" %(environment.upper())
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
            sync_websites_table()
            sync_widgets_table()
            sync_accounts_table()
            sync_pages_table()
            sync_pages_to_audit()
            sync_websites_to_audit()
            sync_widgets_to_audit()
    except getopt.GetoptError,e:
        print e
        usage()

if __name__ =='__main__':
    main(sys.argv[1:])
