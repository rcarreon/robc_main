#!/usr/bin/python
import sys, getopt
import commands
import mysql.connector
import string
import smtplib
from base64 import b64decode
from email.mime.text import MIMEText

db = {
  'user': 'dbops',
  'password': 'ZXZvbHZlZ2VuaXVzOTg3',

}
email = {
  'to': 'dba@evolvemediallc.com',
  'from': 'mysql@app1v-dbops.tp.prd.lax.gnmedia.net',
  'subject': '[db-checksum]',
  'text': '',
}
master = {
  'host': '',
  'databases': '',
  'ignoretables': '',
  'chunktime': '0.05',
  'maxload': 'Threads_running=40',
  'progress': 'percentage,100',
  'retries': '5'
}
slave = []

def usage():
    print 'Usage: '+sys.argv[0]+' -h <host> [-d <database> -i <ignoretable> -t <chunktime> -l <maxload> -p <progress> -r <retries>]'
    sys.exit(2)

def searchDiff():
    try:
        query = "SELECT db, tbl, SUM(this_cnt) AS total_rows, COUNT(*) AS chunks FROM pt_data.checksums WHERE (master_cnt <> this_cnt OR master_crc <> this_crc OR ISNULL(master_crc) <> ISNULL(this_crc)) "
        if (master['databases'] != ''):
            query = query + " AND db IN('" + master['databases'] + "')"
        query = query + " GROUP BY db, tbl"
        for item in sorted(slave):
            if (item != master['host']):
                email['text'] = email['text'] + "\n\n" + string.upper(item)
                cnx = mysql.connector.connect(host=item, user=db['user'], password=b64decode(db['password']))
                cur = cnx.cursor()
                cur.execute(query)
                for (database, table, rows, chunks) in cur:
                    email['text'] = email['text'] + "\n\tdb: " + database + "\ttbl: " + table + "\tchunks: " + str(chunks) + "\ttotal_rows: " + str(rows)
                cnx.commit()
                cur.close()
                cnx.close()
                cnx.disconnect()
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

def checksum():
    try:
        pid = '/var/run/db-checksum/'+master['host']+'-checksum.pid'
        command = "/usr/bin/pt-table-checksum --host=" + master['host'] + " --noversion-check --user=" + db['user'] + " --password=" + b64decode(db['password']) + " --retries=" + master['retries'] + " --nocheck-binlog-format --check-interval=1 --check-plan --check-replication-filters --check-slave-tables --chunk-size-limit=1 --chunk-time=" + master['chunktime'] + " --create-replicate-table --empty-replicate-table --max-lag='1s' --max-load=" + master['maxload'] + " --progress=" + master['progress'] + " --replicate='pt_data.checksums' --pid='" + pid + "'"
        if (master['databases'] != ''):
            command = command + " --databases=" + master['databases']
        if (master['ignoretables'] != ''):
            command = command + " --ignore-tables=" + master['ignoretables']
        if (master['progress'] != ''):
            command = command + " --progress=" + master['progress']
        output = commands.getstatusoutput(command)
        email['text'] = email['text'] + output[1]
        getSlave()
        return True
    except:
        return False

def exists():
    try:
        existhost = commands.getstatusoutput("host " + master['host'])
        email['text'] = email['text'] + "\nMaster: " + string.upper(existhost[1]) + "\n"
        if (existhost[0] == 0):
           return True
        else:
           print str("Can not connect to hostname")
           email['subject'] = email['subject'] + "-[ERROR]"
           return False
    except:
        return False

def sendEmail():
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
    if exists():
        slave.append(master['host'])
        if checksum():
            searchDiff()
    else:
        print sys.stderr
    sendEmail()
    sys.exit()

def validOpt(options):
    for opt, arg in options:
        if opt in ("-H", "--help"):
            usage()
        elif opt in ("-h", "--host"):
            master['host'] = arg
            data = string.split(string.upper(master['host']), ".")
            email['subject'] = email['subject'] + " " + data[2]
        elif opt in ("-d", "--database"):
            master['databases'] = arg
        elif opt in ("-i", "--ignoretable"):
            master['ignoretables'] = arg
        elif opt in ("-t", "--chunktime"):
            master['chunktime'] = arg
        elif opt in ("-l", "--maxload"):
            master['maxload'] = arg
        elif opt in ("-p", "--progress"):
            master['progress'] = arg
        elif opt in ("-r", "--retries"):
            master['retries'] = arg
    if (master['host'] == ''):
        print "Hostname is requierd"
        usage()
    else:
        return True

def main(argv):
    try:
        opts, args = getopt.getopt(argv, 'Hh:d:i:t:l:p:r:', ['help','host=','database=','ignoretable=','chunktime=','maxload=','progress=','retries='])
        if not opts:
            print 'No options given'
            usage()
        elif validOpt(opts):
            initial()
    except getopt.GetoptError,e:
        print e
        usage()

if __name__ =='__main__':
    main(sys.argv[1:])

