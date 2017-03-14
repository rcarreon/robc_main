#!/usr/bin/python
import mysql.connector, base64, smtplib, datetime, time, sys, getopt, string, re
from email.mime.text import MIMEText

class MsgError():

    messages = {
        1064 : "Error difficult to detect",
        1481 : "MAXVALUE can only be used in last partition definition",
        1493 : "VALUES LESS THAN value must be strictly increasing for each partition",
        1505 : "Partition management on a not partitioned table is not possible",
        1507 : "Error in list of partitions to DROP",
        1508 : "Cannot remove all partitions, use DROP TABLE instead",
        1509 : "COALESCE PARTITION can only be used on HASH/KEY partitions",
        1510 : "REORGANIZE PARTITION can only be used to reorganize partitions not to change their numbers",
        1511 : "REORGANIZE PARTITION without parameters can only be used on auto-partitioned tables using HASH PARTITIONs",
        1512 : "PARTITION can only be used on RANGE/LIST partitions",
        1513 : "Trying to Add partition(s) with wrong number of subpartitions",
        1514 : "At least one partition must be added",
        1515 : "At least one partition must be coalesced",
        1516 : "More partitions to reorganize than there are partitions",
        1517 : "Duplicate partition name"
    }

    def get_error_message(self, error_code):
        return self.messages[error_code]

class DBLogMonitor():

    def __init__(self, host):
        self.connection_string = {
            "user"     : "ci_partition",
            "password" : base64.b64decode("bmE0UGpZekc="),
            "host"     : host,
            "database" : "logs"
        }

    def get_last_event(self, sp_name):

        log_row = {
            "sp_name" : sp_name,
            "sp_params" : "",
            "execution_time" : "",
            "error_code" : 0
        }
        cnx = mysql.connector.connect(**self.connection_string)
        cur = cnx.cursor()
        query = "SELECT sp_params, execution_time, error_code \
                 FROM logs.partition_logs \
                 WHERE sp_name = '%s' \
                 ORDER BY execution_time DESC LIMIT 1" % sp_name
        cur.execute(query)
        for (params, exectime, code) in cur:
            log_row["sp_params"] = params
            log_row["execution_time"] = exectime
            log_row["error_code"] = code
        cur.close()
        cnx.close()
        cnx.disconnect()

        return log_row

    def check_void_partitions(self):
        cnx = mysql.connector.connect(**self.connection_string)
        result ={
            "partition" : 0,
            "partition_name" : 0,
            "miss" : False
            }
        cur = cnx.cursor()
        query = "SELECT STR_TO_DATE(CONCAT(PARTITION_DESCRIPTION, '0000'), '%Y%m%d%H%i%s') \
                 FROM INFORMATION_SCHEMA.PARTITIONS \
                 WHERE TABLE_NAME = 'widgets_ctp' AND TABLE_SCHEMA = 'tewn' AND PARTITION_NAME != 'pMAX' \
                 ORDER BY PARTITION_DESCRIPTION"
        cur.execute(query)
        current_value = 0
        for (part_desc) in cur:
            if (current_value == 0):
                current_value = part_desc[0]
            else:
                delta = part_desc[0] - current_value
                if (delta.seconds != 3600):
                    partition_value = current_value + datetime.timedelta(seconds=3600)
                    result["partition"] = partition_value.strftime("%Y%m%d%H")
                    result["partition_name"] = current_value.strftime("%Y%m%d%H")
                    result["miss"] = True
                current_value = part_desc[0]
        cur.close()
        cnx.close()
        cnx.disconnect()

        return result

    def table_definition(self):
        cnx = mysql.connector.connect(**self.connection_string)
        result = ""
        cur = cnx.cursor()
        query = "SHOW CREATE TABLE tewn.widgets_ctp"
        cur.execute(query)
        for (table_desc) in cur:
            result = table_desc[1]
        cur.close()
        cnx.close()
        cnx.disconnect()

        return string.replace(result,"`","")

class EmailManager():

    def __init__(self, hostname):
        self._from = "MySQL Monitor<mysql@app1v-dbops.tp.prd.lax.gnmedia.net>"
        self._to = "DBA<dba@evolvemediallc.com>"
        self._subject = ""
        self._body = ""
        self._hostname = hostname

    def set_body(self, row, result, table_definition):
        Body = "Host: %s\n" % (self._hostname)
        msg = MsgError()

        if (result["miss"]):
            Body = "%sError occurred during creation of partition p%s using value %s for tewn.widgets_ctp\n\n" % (Body, result["partition_name"], result["partition"])

        if (row["del"]["error_code"] != 0):
            Body = "%s\nStore procedure called at %s \n<CALL %s(%s)>\nError code: %s, %s\n"\
                    % (Body, datetime.datetime.fromtimestamp(int(row["del"]["execution_time"])).strftime("%b %d, %Y  %H:%M:%S"), row["del"]["sp_name"], row["del"]["sp_params"],  row["del"]["error_code"], msg.get_error_message(row["del"]["error_code"]))

        if (row["add"]["error_code"] != 0):
            Body = "%s\nStore procedure called at %s \n<CALL %s(%s)>\nError code: %s, %s\n"\
                    % (Body, datetime.datetime.fromtimestamp(int(row["add"]["execution_time"])).strftime("%b %d, %Y  %H:%M:%S"), row["add"]["sp_name"], row["add"]["sp_params"],  row["add"]["error_code"], msg.get_error_message(row["add"]["error_code"]))

        Body = "%s\n\n%s" % (Body, table_definition)

        self._body = Body

    def set_errorbody(self, Body):
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

    hostname = ""
    row_info = {
        "add" : {
            "sp_name" : "ci_ci_sp_add_ctp_partition",
            "sp_params" : "",
            "execution_time" : "",
            "error_code" : 0
        },
        "del" : {
            "sp_name" : "ci_ci_sp_remove_ctp_partition",
            "sp_params" : "",
            "execution_time" : "",
            "error_code" : 0
        }
    }

    result ={
        "partition" : 0,
        "partition_name" : 0,
        "miss" : False
    }

    try:
        opts, args = getopt.getopt(argv,"h:",["host="])
    except getopt.GetoptError:
        print 'partition_monitor.py -h <hostname>'
        sys.exit(2)

    for opt, arg in opts:
        if opt == '-h':
            hostname = arg

    res = re.match(".*(prd|stg|dev).*", hostname.lower())
    environment = res.group(1)

    subject = "%s: CI-ERROR [Widgets CTP partition monitor]" % environment.upper()

    dblog = DBLogMonitor(hostname)
    email = EmailManager(hostname)

    try:
        row_info["add"] = dblog.get_last_event("ci_ci_sp_add_ctp_partition")
        row_info["del"] = dblog.get_last_event("ci_ci_sp_remove_ctp_partition")
        result = dblog.check_void_partitions()
        table_definition = dblog.table_definition()
        email.set_body(row_info, result, table_definition)
    except mysql.connector.Error as err:
        Body = "Can't connect to %s" % (hostname)
        if (err.errno == 1130 or err.errno == 1154 or err.errno == 1203 or err.errno == 2003):
            Body = "%s\nError code:%s" % (Body, err.msg)
        email.set_errorbody(Body)

    email.set_subject(subject)
    if (result["miss"] or row_info["add"]["error_code"] != 0 or row_info["del"]["error_code"] != 0):
        email.send_alert()

if __name__ == "__main__":
   main(sys.argv[1:])
