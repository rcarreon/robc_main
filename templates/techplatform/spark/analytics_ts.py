import mysql.connector, base64, time, sys, string, re, traceback
from datetime import date, timedelta
from mysql.connector.errors import Error
from pyspark import SparkContext, SparkConf
from pyspark.sql import SQLContext

class QueryAnalytics():
  
  def __init__(self, user, password, hostname, database):
    self.connection_string = {
        "user"     : user,
        "password" : password,
        "host": hostname,
        "database": database
    } 

  def execute_query(self, query):
    cnx = mysql.connector.connect(**self.connection_string)
    cur = cnx.cursor()
    for result in cur.execute(query, multi = True):
      pass
    cnx.commit()
    cur.close()
    cnx.close()

def main(argv):

  conf = SparkConf().setAppName("OG DEV analytics_ts.py")
  sc = SparkContext(conf=conf)
  sqlContext = SQLContext(sc)

  user = 'spark'
  password = base64.b64decode("QnJxU3A3YXduT0Uw")
  hostname = 'sql1v-bd.og.dev.lax.gnmedia.net'
  database = 'analytics'
  
  #Standalone HDFS
  #hdfs = 'app1v-hadoop-bd.tp.prd.lax.gnmedia.net' 
  #Cluster HDFS
  hdfs = 'zootpprd'

  #Test
  #origin = sqlContext.read.json("file:///app/data/hadoop/test.txt")
  
  #In this job we're processing data from yesterday only and we're putting in mysql ts and ts converted(Received_Date)
  yesterday_month = (date.today() - timedelta(1)).strftime('%m')
  yesterday_day = (date.today() - timedelta(1)).strftime('%d')
  select_origin = sqlContext.read.json("hdfs://{0}/flume/origin/prd/2016/{1}/{2}".format(hdfs,yesterday_month,yesterday_day))
  select_origin.cache()

  select_origin.registerTempTable("origin_tmp")
  analytics = sqlContext.sql("SELECT \
   IF(adId IS NULL,0,adId) as AdId, \
   IF(product IS NULL,' ',product) as Product, \
   IF(label IS NULL,' ',label) as Label, \
   IF(event IS NULL,' ',event) as Event, \
   IF(attribute IS NULL,' ',attribute) as Attribute, \
   IF(version IS NULL,' ',version) as Version, \
   IF(TO_DATE(FROM_UNIXTIME(CAST(LPAD(ts, 10, 0) AS int))) IS NULL,'0000-00-00',TO_DATE(FROM_UNIXTIME(CAST(LPAD(ts, 10, 0) AS int)))) AS Received_Date, \
   IF(ts IS NULL,' ',ts) as ts, \
   IF(tss IS NULL OR tss = 0, '0000-00-00',TO_DATE(FROM_UNIXTIME(tss))) AS Received_Date2, \
   IF(ts IS NULL,' ',tss) as tss \
     FROM origin_tmp")

  #Lets print the results
  #results = analytics.map(lambda a: str(a.adId) +" "+str(a.label) +" "+str(a.event) +" "+str(a.value) +" "+str(a.total) +" "+ str(a.ad_day))
  #for result in results.collect():
  #  print(result)

  qa = QueryAnalytics(user, password, hostname, database)

  query = "DROP TABLE IF EXISTS analytics_ts_tmp; \
    CREATE TABLE analytics_ts_tmp ( \
    `AdId` int(10) NOT NULL, \
    `Product` varchar(100) NOT NULL, \
    `Label` varchar(500) NOT NULL, \
    `Event` varchar(100) NOT NULL, \
    `Attribute` TEXT, \
    `Version` TEXT, \
    `Received_Date` date, \
    `ts` TEXT, \
    `Received_Date2` date, \
    `tss` TEXT, \
    KEY `idx_AdId_Dt_Event` (`AdId`,`Received_Date`,`Event`), \
    KEY `Received_Date` (`Received_Date`), \
    KEY `Received_Date2` (`Received_Date2`) \
  ) ENGINE=InnoDB DEFAULT CHARSET=utf8"
  qa.execute_query(query)

  #JDBC 
  mysql_url="jdbc:mysql://{0}:3306/analytics?user={1}&password={2}".format(hostname, user, password)
  analytics.write.jdbc(url=mysql_url, table="analytics.analytics_ts_tmp", mode="append")

  query = "RENAME TABLE analytics_ts TO analytics_ts_bkp; \
           RENAME TABLE analytics_ts_tmp TO analytics_ts; \
           RENAME TABLE analytics_ts_bkp TO analytics_ts_tmp;"
  qa.execute_query(query)

if __name__ == "__main__":
   main(sys.argv[1:])
