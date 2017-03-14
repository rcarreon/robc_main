
#!/usr/bin/python
import mysql.connector, sys, traceback, subprocess, string, re, csv, getopt, calendar, smtplib, os, collections, base64
from os.path import basename
from datetime import date, timedelta, datetime
from mysql.connector.errors import Error
from email.mime.application import MIMEApplication
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
from email.utils import COMMASPACE, formatdate

class EmailManager():
    def __init__(self, report_dates):
        self._from = "Hadoop <mysql@app1v-hadoop-bd.tp.prd.lax.gnmedia.net>"      
        self._to = ['dba@evolvemediallc.com','marc.geraldez@evolvemediallc.com']
        self._subject = "ORIGIN [Events and values] {0}".format(report_dates)
        self._body = "Greetings, I'm attaching the list of events and values from last week.\n\nDBA Team"

    def set_body(self, body):
        self._body = body

    def send_alert(self, files=None):
        #MIMEMultipart necessary for attachments
        msg = MIMEMultipart()
        msg["From"] = self._from
        msg["To"] = ", ".join(self._to)
        msg["Subject"] = self._subject
        msg.attach(MIMEText(self._body))
        
        for f in files or []:
            with open(f, "rb") as file:
                msg.attach(MIMEApplication(
                    file.read(),
                    Content_Disposition='attachment; filename={0}'.format(basename(f)),
                    Name=basename(f)
                ))
        if (self._body != ""):
            smtp = smtplib.SMTP("localhost")
            smtp.sendmail(self._from , self._to, msg.as_string())
            smtp.close()

class RptManager():
    #Enable only for debugging 1 otherwise 0
    debug = 0
    def __init__(self, since, until, dbms, db):
        self._since = since
        self._until= until
        self._dbms = dbms
        self._db = db
        self._set = set()
        self._file_names = []
        if dbms == 'mysql':
            self._date_fnc = "DATE"        
        if dbms == 'hive':
            self._date_fnc = "TO_DATE"

    def myconn(self):
        self.connection_string = {
            "user"     : "report",
            "password" : base64.b64decode("enJYMGhuTmJDTnNa"),
            "host": "VIP-SQLRO-BD.OG.PRD.LAX",
            "database": "analytics"
        }

    def rowTotal(self, newdict):
        total = 0
        for item in newdict:
            total = total + newdict[item]
        return total

    def addHeader(self, writer):
        #writer.writerow(['List of events and values'])
        #writer.writerow(['{0} - {1}'.format(self._since, self._until)])
        writer.writerows([['Event']+['Value']])

    def processEvent(self):
        #writer = csv.writer(f)
        if self._dbms == 'hive':        
            table = "origin_{0}_{1}".format(self._since.year, str(self._since.month).zfill(2))
        if self._dbms == 'mysql':        
            table = 'aggregates_by_date'
        #If "since" and "until" belong to diferent months i will make the requests to different tables ei: origin_2015_08 and origin_2015_09 
        if self._since.month==self._until.month:
            #Request to only one month
            self.queryExec(self._dbms, table, self._since, self._until)
        else:
            #Last day of the month will be used
            month_last_day=date(self._since.year, self._since.month, calendar.monthrange(self._since.year, self._since.month)[1])
            #Request to month 1
            self.queryExec(self._dbms, table, self._since, month_last_day)
            #Request to month 2 with diferent table name
            if self._dbms == 'hive': 
                table = "origin_{0}_{1}".format(self._until.year, str(self._until.month).zfill(2))
            if self._dbms == 'mysql':        
                table = 'aggregates_by_date'
            month_first_day=month_last_day+timedelta(days=1)
            self.queryExec(self._dbms, table, month_first_day, self._until)
            #Return self._set which have all the rows will results from hive
        if(len(self._set)>0):
            return self.writeFile(sorted(self._set, key=lambda line: line[0]))
        else:
            return

    def queryExec(self, dbms, table, start, end):
        if dbms == 'hive':
            mycmd = "{0} -e \"SELECT event, attribute \
                FROM {1}.{2} WHERE LPAD(ts, 10, 0) >= UNIX_TIMESTAMP('{3} 00:00:00') \
                AND LPAD(ts, 10, 0) < UNIX_TIMESTAMP('{4} 00:00:00') \
                GROUP BY event, attribute \
                ORDER BY event, attribute; \"".format(self._dbms, self._db, table, start, end + timedelta(days=1))
            if RptManager.debug == 1: print mycmd     
            #Talk with date command i.e. read data from stdout and stderr. Store this info in tuple 
            p = subprocess.Popen(mycmd, stdout=subprocess.PIPE, shell=True)
            #Interact with process: Send data to stdin. Read data from stdout and stderr, until end-of-file is reached. Wait for process to terminate. 
            (output, err) = p.communicate()
            # Wait for date to terminate. Get return returncode 
            p_status = p.wait()
            if RptManager.debug == 1:
                print "Command output : ", output
                print "Command exit status/return code : ", p_status,"\n"
                len(output)
            if p_status==0:
                #Creates a list splitting the output by line
                output = string.split(output, '\n')
                if len(output)>1: 
                    #We remove the first element of the list because it has the headers and the lastone because is always empty
                    output.pop(0)
                    del output[-1]
                    for a in output:
                        a = string.split(a, '\t')
                        b=(a[0],a[1])
                        self._set.add(b)
        if dbms == 'mysql':
            #Create connection in SOURCE host        
            self.myconn()
            cnx = mysql.connector.connect(**self.connection_string)
            cur = cnx.cursor()
            partner_list= []
            query = "SELECT event, attribute \
                FROM {0}.{1} WHERE Received_Date >= '{2}' \
                AND Received_Date < '{3}' \
                GROUP BY event, attribute \
                ORDER BY event, attribute;".format(self._db, table, start, end + timedelta(days=1))
            if RptManager.debug == 1: print query
            cur.execute(query)
            for a in cur:
                b=(a[0],a[1])
                self._set.add(b)
            cur.close()
            cnx.close()
            cnx.disconnect()
        return

    def writeFile(self, result_list):
        #Distinct values for event and day in the results
        file_name="event_value_report_{0}_{1}.csv".format(self._since, self._until)
        f = open(file_name, "wt")
        writer = csv.writer(f)
        print " "
        self.addHeader(writer)
       
        for result_line in result_list:
            writer.writerows([ [result_line[0]] + [result_line[1]] ])
        self._file_names.append(file_name)
        f.close()
        print " "
        if RptManager.debug == 1: print open(file_name, "rt").read()

    def getSets(self, adids_dict_list, adid):
        for line in adids_dict_list:
            for param in line:
                if int(param["adid"])==int(adid):
                    return (param)

    def resetDict(self, event_set):
        mydict = {}
        for event in event_set:
            mydict[event]=0
        mydict = collections.OrderedDict(sorted(mydict.items()))
        return mydict

    def deleteFiles(self, files):
        for f in files:
            if os.path.isfile(f):
                    os.remove(f)
            else:   
                    print("Error: %s file not found" % f)

def main(argv):
    #Usage: python generate_events_report.py --day 2015-09-07 --dbms mysql --db analytics
    #Usage: python generate_events_report.py --day 2015-09-07 --dbms hive --db origin_analytics
    try:
        opts, args = getopt.getopt(argv,"s:d:",["day=","dbms=","db="])
    except getopt.GetoptError:
        print 'generate_event_attr_report.py --day <%Y-%m-%d> --dbms <hive|mysql> --db <database_name>'
        sys.exit(2)

    for opt, arg in opts:
        if opt in ('-s', '--day'):
            #Based on the date provided will calculate the range dates for the week before
            until = (datetime.strptime(arg, '%Y-%m-%d') - timedelta(days=1)).date()
            since = (datetime.strptime(arg, '%Y-%m-%d') - timedelta(days=7)).date()
        if opt in ('-d', '--dbms'):
            dbms = arg
        if opt in ('-b', '--db'):
            db = arg                

    try:
        email = EmailManager(str(since)+" - "+str(until))
        rpt = RptManager(since, until, dbms, db) 
        rpt.processEvent()
        
        if len(rpt._set)>0:  
            email.send_alert(rpt._file_names)
        else: 
            email.set_body("No data found for the week {0} - {1}".format(since, until))
            email.send_alert()
        #Remove file list created in this process
        rpt.deleteFiles(rpt._file_names)
    except: # catch *all* exceptions
        email = EmailManager(" ")
        body = traceback.format_exc()
        email.set_body(body)        
        email.send_alert()
        rpt.deleteFiles(rpt._file_names)
        if RptManager.debug == 1: print body
    sys.exit(0) 

if __name__ == "__main__":
   main(sys.argv[1:])

