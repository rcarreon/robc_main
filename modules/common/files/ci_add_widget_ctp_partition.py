#!/usr/bin/python
import mysql.connector, base64, sys, getopt, smtplib, re
from email.mime.text import MIMEText

class DataBaseManager():

    def __init__(self, host):
        self.connection_string = {
            "user"     : "ci_partition",
            "password" : base64.b64decode("bmE0UGpZekc="),
            "host"     : host,
            "database" : "tewn"
        }

    def add_widget_ctp_partition(self):
        cnx = mysql.connector.connect(**self.connection_string)
        cur = cnx.cursor()
        query = "ci_ci_sp_add_ctp_partition"
        cur.callproc(query)
        cur.close()
        cnx.close()
        cnx.disconnect()

class EmailManager():

    def __init__(self):
        self._from = "MySQL Cronjob<mysql@app1v-dbops.tp.prd.lax.gnmedia.net>"
        self._to = "DBA<dba@evolvemediallc.com>"
        self._subject = ""
        self._body = ""

    def set_body(self, Body):
        self._body = Body

    def set_subject(self, subject):
        self._subject = subject

    def send_alert(self):
        msg = MIMEText(self._body)
        msg["From"] = self._from
        msg["To"] = self._to
        msg["Subject"] = self._subject

        if (self._body != ""):
            sender = smtplib.SMTP("localhost")
            sender.sendmail([self._from], self._to, msg.as_string())
            sender.quit()

def main(argv):

    try:
        opts, args = getopt.getopt(argv,"h:",["host="])
    except getopt.GetoptError:
        print 'ci_add_widget_ctp_partition.py -h <hostname>'
        sys.exit(2)

    for opt, arg in opts:
        if opt == '-h':
            hostname = arg
    res = re.match(".*(prd|stg|dev).*", hostname.lower())
    environment = res.group(1)

    db = DataBaseManager(hostname)
    eAlert = EmailManager()

    try:
        db.add_widget_ctp_partition()
    except mysql.connector.Error as err:
        eAlert.set_subject("%s:CI-ERROR [Add Widgets CTP partition]" % environment.upper())
        Body = "Can't connect to %s\n%s" % (hostname, err.msg)
        if (err.errno == 1130 or err.errno == 1154 or err.errno == 1203 or err.errno == 2003):
            Body = "%s\nError code:%s" % (Body, err.msg)
        eAlert.set_body(Body)
        eAlert.send_alert()

if __name__ == "__main__":
   main(sys.argv[1:])
