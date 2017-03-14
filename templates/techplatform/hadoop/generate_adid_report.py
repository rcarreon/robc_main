#!/usr/bin/python
import sys, traceback, subprocess, string, re, csv, getopt, calendar, smtplib, os, collections
from os.path import basename
from datetime import date, timedelta, datetime
from email.mime.application import MIMEApplication
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
from email.utils import COMMASPACE, formatdate

class EmailManager():
    def __init__(self, adids, report_dates):
        self._from = "Hadoop <mysql@app1v-hadoop-bd.tp.prd.lax.gnmedia.net>"      
        self._to = "DBA <dba@evolvemediallc.com>"
        self._subject = "ORIGIN [Weekly Report] {0}".format(report_dates)
        self._body = "Greetings, I'm attaching report for adId {0} from last week.\n\nDBA Team".format(",".join(map(str,adids)))

    def set_body(self, body):
        self._body = body

    def send_alert(self, files=None):
        #MIMEMultipart necessary for attachments
        msg = MIMEMultipart()
        msg["From"] = self._from
        msg["To"] = self._to
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
    def __init__(self, adids, since, until, dbms, db):
        self._adids = adids
        self._since = since
        self._until= until
        self._dbms = dbms
        self._db = db
        self._list = []
        self._file_names = []
        if dbms == 'mysql':
            self._date_fnc = "DATE"        
        if dbms == 'hive':
            self._date_fnc = "TO_DATE"

    def rowTotal(self, newdict):
        total = 0
        for item in newdict:
            total = total + newdict[item]
        return total

    def addHeader(self, adid, mylist, writer):
        writer.writerow(['All Web Site Data'])
        writer.writerow(['Top Events'])
        writer.writerow(['{0} - {1}'.format(self._since, self._until)])
        writer.writerow(['adId: {0}'.format(adid)])
        writer.writerows([['Day']+['   Total   ']+list(mylist)])

    def processAdid(self):
        #writer = csv.writer(f)        
        table = "origin_{0}_{1}".format(self._since.year, str(self._since.month).zfill(2))
        #If "since" and "until" belong to diferent months i will make the requests to different tables ei: origin_2015_08 and origin_2015_09 
        if self._since.month==self._until.month:
            #Request to only one month
            self.queryExec(table, self._since, self._until)
        else:
            #Last day of the month will be used
            month_last_day=date(self._since.year, self._since.month, calendar.monthrange(self._since.year, self._since.month)[1])
            #Request to month 1
            self.queryExec(table, self._since, month_last_day)
            #Request to month 2 with diferent table name
            table = "origin_{0}_{1}".format(self._until.year, str(self._until.month).zfill(2))
            month_first_day=month_last_day+timedelta(days=1)
            self.queryExec(table, month_first_day, self._until)
            #Return self._list which have all the rows will results from hive
        if(len(self._list)>0):
            return self.parseOutput(sorted(self._list, key=lambda line: line[0]))
        else:
            return

    def queryExec(self, table, start, end):
        mycmd = "{0} -e \"SELECT adId, {1}(FROM_UNIXTIME(CAST(LPAD(ts, 10, 0) AS int))) AS ad_day, event AS event, COUNT(1) AS total \
            FROM {2}.{3} WHERE adId IN ({4}) \
            AND LPAD(ts, 10, 0) >= UNIX_TIMESTAMP('{5} 00:00:00') \
            AND LPAD(ts, 10, 0) < UNIX_TIMESTAMP('{6} 00:00:00') \
            GROUP BY adId, {1}(FROM_UNIXTIME(CAST(LPAD(ts, 10, 0) AS int))), event \
            ORDER BY adId, ad_day, adId; \"".format(self._dbms, self._date_fnc, self._db, table, ', '.join(self._adids), start, end + timedelta(days=1))
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
                    self._list.append(a) 
        return

    def parseOutput(self, result):
        #Read each line from the result and create a set of distinct Events and Days      
        print "All results from all adids requested together in one list:"
        for row in result:
            print row
        print " "

        id_set= set()
        event_set = set()
        adid_dict = {}
        #{'event_set': ['Click', 'Close', 'Hover', 'Load', 'State Loaded', 'engagement'], 'adid': '371'}
        adids_dict_list = []
        #[[{'event_set': ['Cinema', 'Click', 'Close', 'Hover', 'Load', 'State Loaded', 'engagement'], 'adid': '183'}], [{'event_set': ['Click', 'Close', 'Hover', 'Load', 'State Loaded', 'engagement'], 'adid': '371'}]]

        current_adid = 0
        for day_info in result:
            #print day_info
            id_set.add(day_info[0])
            if current_adid == 0: 
                #print "#It's the first adid"
                current_adid = day_info[0]
                event_set.add(day_info[2])
            elif current_adid != day_info[0]:
                #print "#It's diferent adid"
                adid_dict["adid"] = current_adid
                adid_dict["event_set"] = sorted(event_set)
                adids_dict_list.append([adid_dict])
                #Now will make current_adid the next adid
                current_adid = day_info[0]
                adid_dict = {}
                event_set = set()
                event_set.add(day_info[2])
            elif current_adid == day_info[0]:
                #print "#Procesing current adid"
                event_set.add(day_info[2])
        adid_dict["adid"] = current_adid
        adid_dict["event_set"] = sorted(event_set)
        adids_dict_list.append([adid_dict])        

        print adids_dict_list

        current_adid = 0
        current_day = 0
        for day_info in result:
            if current_adid == 0:
                #print "#It's the first adid"
                #I need to know the sets for this adid
                sets = self.getSets(adids_dict_list, day_info[0])
                #Build dictornary with columns of distinct events (event_set) this will allow to insert ceros when event is not present in all days   
                #('Click', 0), ('Close', 3), ('Hover', 1), ('Load', 1), ('State Loaded', 0), ('engagement', 0)
                event_counter = self.resetDict(sets["event_set"])
                
                #CSV list of lines clean and will be cleaned for each new adid
                csv_list = []
                #List of counters per day processed
                counters = [] 

                #Assign values
                current_adid = day_info[0]
                current_day = day_info[1]
                event_counter[day_info[2]]=int(day_info[3])

            elif current_adid != day_info[0]:
                #print "#It's diferent adid"
                #Finish processing the current day
                for event in event_counter:
                    counters.append(event_counter[event])
                csv_list.append([current_day, self.rowTotal(event_counter), counters ])

                #Write the file of the current adid
                self.writeFile(current_adid, sets["event_set"], csv_list)  
                
                #CSV list of lines clean and will be cleaned for each new adid
                csv_list = []
                #List of counters per day processed
                counters = [] 

                #Assign values
                current_adid = day_info[0]

                #I need to know the sets for this adid
                sets = self.getSets(adids_dict_list, day_info[0])
                #Build dictornary with columns of distinct events (event_set) this will allow to insert ceros when event is not present in all days   
                #('Click', 0), ('Close', 3), ('Hover', 1), ('Load', 1), ('State Loaded', 0), ('engagement', 0)
                event_counter = self.resetDict(sets["event_set"])

                #Assign values
                current_day = day_info[1]
                event_counter[day_info[2]]=int(day_info[3])                
            
            elif current_day != day_info[1]:
                #print "#It's diferent day"
                #Finish processing the current day
                for event in event_counter:
                    counters.append(event_counter[event])
                csv_list.append([current_day, self.rowTotal(event_counter), counters ])

                #CSV list of lines clean
                counters = [] 

                #Build dictornary with columns of distinct events (event_set) this will allow to insert ceros when event is not present in all days   
                #('Click', 0), ('Close', 3), ('Hover', 1), ('Load', 1), ('State Loaded', 0), ('engagement', 0)
                event_counter = self.resetDict(sets["event_set"])
                
                #Assign values
                current_day = day_info[1]
                event_counter[day_info[2]]=int(day_info[3])

            elif current_adid == day_info[0]:
                #print "#Procesing current adid"
                #I'll register the counter
                event_counter[day_info[2]]=int(day_info[3])

        #print "#Im done will process last day"
        for event in event_counter:
            counters.append(event_counter[event])
        csv_list.append([current_day, self.rowTotal(event_counter), counters ])
        #Data necesary to write CSV file: adid, event headers (sets["event_set"]), and the rows with days and counters (csv_list)
        self.writeFile(current_adid, sets["event_set"], csv_list)       
        return 

    def writeFile(self, adid, event_set, result_list):
        #Distinct values for event and day in the results
        file_name="weekly_report_ad_{0}_{1}_{2}.csv".format(adid, self._since, self._until)
        f = open(file_name, "wt")
        writer = csv.writer(f)
        print " "
        self.addHeader(adid, event_set, writer)
        for result_line in result_list:
            writer.writerows([ [result_line[0]] + [result_line[1]] + result_line[2] ])
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
    #Usage: python generate_weekly_report.py --adid 183,371 --day 2015-09-07 --dbms hive --db origin_analytics
    #Weekly report for ad 183 since 2015-08-31 until 2015-09-06
    try:
        opts, args = getopt.getopt(argv,"s:d:",["adids=","day=","dbms=","db="])
    except getopt.GetoptError:
        print 'generate_adid_report.py --adids <number,number...> --day <%Y-%m-%d> --dbms <hive|mysql> --db <database_name>'
        sys.exit(2)

    for opt, arg in opts:
        if opt in ('-a', '--adids'):
            adids = arg.split(",")
        if opt in ('-s', '--day'):
            #Based on the date provided will calculate the range dates for the week before
            until = (datetime.strptime(arg, '%Y-%m-%d') - timedelta(days=1)).date()
            since = (datetime.strptime(arg, '%Y-%m-%d') - timedelta(days=7)).date()
        if opt in ('-d', '--dbms'):
            dbms = arg
        if opt in ('-b', '--db'):
            db = arg              
    
    try:
        email = EmailManager(adids, str(since)+" - "+str(until))
        rpt = RptManager(adids, since, until, dbms, db) 
        rpt.processAdid()
        
        if len(rpt._list)>0:  
            email.send_alert(rpt._file_names)
        else: 
            email.set_body("No data found for the week {0} - {1}".format(since, until))
            email.send_alert()
        #Remove file list created in this process
        rpt.deleteFiles(rpt._file_names)
    except: # catch *all* exceptions
        body = traceback.format_exc()
        email.set_body(body)        
        email.send_alert()
        rpt.deleteFiles(rpt._file_names)
        if RptManager.debug == 1: print body
    sys.exit(0) 

if __name__ == "__main__":
   main(sys.argv[1:])
