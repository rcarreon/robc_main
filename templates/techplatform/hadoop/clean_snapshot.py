#!/usr/bin/python
import sys, subprocess
from datetime import datetime, timedelta
from email.mime.text import MIMEText
import smtplib
from pprint import pprint

HADOOP_CLUSTER = 'zootpprd'
SNAPSHOT_PATH = "hdfs://{0}/.snapshot".format(HADOOP_CLUSTER)
RETENTION = 4

email = {
  'to': 'DBA<dba@evolvemediallc.com>',
  'from': 'Hadoop Snapshot<hadoop@app2v-hadoop-bd.tp.prd.lax.gnmedia.net>',
  'subject': 'Hadoop Snapshot Retention Process',
  'text': 'Following snapshots has been removed from {0} cluster, with {1} retention days: \n{2}'
}

def snapshotList():
  snapFiles = list()
  p = subprocess.Popen(['hdfs', 'dfs', '-find', SNAPSHOT_PATH, '-name', 'hdfs_*'], stdout=subprocess.PIPE)

  for entry in p.stdout:
    if not('DEBUG' in entry):
      snapFiles.append(entry.rstrip())
  return snapFiles

def validateSnapshot(_snapname):
  _shouldDelete = False
  _date = datetime.strptime(_snapname[len(_snapname) - 1].split('-')[0], '%Y%m%d%H%M%S')

  if (_date < (datetime.today() - timedelta(days=RETENTION))):
    _shouldDelete = True

  return _shouldDelete

def sendEmail(_extra):
  email['text'] = email['text'].format(HADOOP_CLUSTER, RETENTION, _extra)
  msg = MIMEText(email['text'])
  msg['Subject'] = email['subject']
  msg['From'] = email['from']
  msg['To'] = email['to']
  s = smtplib.SMTP('localhost')
  s.sendmail(email['from'], email['to'], msg.as_string())
  s.quit()

def main(argv):

  fileList = snapshotList()
  command_line = ["hdfs", "dfs", "-deleteSnapshot", "/", ""]
  snapDeleted = list()

  for _file in fileList:
    temp_dict = _file.split('/')
    snapname = temp_dict[len(temp_dict) - 1]
    if validateSnapshot(snapname.split('_')):
      command_line[4] = snapname
      p = subprocess.Popen(command_line, stdout=subprocess.PIPE)
      snapDeleted.append(snapname)

  if (len(snapDeleted) > 0):
    extraBody = ''
    for snap in snapDeleted:
      extraBody = "{0}\t* {1}\n".format(extraBody, snap)
    sendEmail(extraBody)

if __name__ == "__main__":
  main(sys.argv[1:])
