import mysql.connector, base64, time, sys, string, re, traceback
from mysql.connector.errors import Error
from pyspark import SparkContext, SparkConf
from pyspark.sql import SQLContext
#sc = SparkContext()
#sc is an existing SparkContext.

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

  conf = SparkConf().setAppName("OG DEV analytics.py")
  sc = SparkContext(conf=conf)
  sqlContext = SQLContext(sc)

  user = 'spark'
  password = base64.b64decode("QnJxU3A3YXduT0Uw");
  hostname = 'sql1v-bd.og.dev.lax.gnmedia.net'
  database = 'analytics'
  
  #Standalone HDFS
  #hdfs = 'app1v-hadoop-bd.tp.prd.lax.gnmedia.net' 
  #Cluster HDFS
  hdfs = 'zootpprd'

  #Test
  #origin = sqlContext.read.json("file:///app/data/hadoop/test.txt")
  
  #For DEV we we're processing the current day in the current month
  curr_month = time.strftime("%m")
  curr_day = time.strftime("%d") 
  select_origin = sqlContext.read.json("hdfs://{0}/flume/origin/prd/2016/{1}/{2}".format(hdfs,curr_month,curr_day))
  select_origin.cache()
  #select_origin.printSchema()
  #select_origin.show()
  #select_origin.count()
  #select_origin = origin.select(origin['adId'], origin['label'], origin['event'], origin['attribute'], origin['value'], origin['version'], origin['ts'])

  select_origin.registerTempTable("origin_tmp")
  analytics = sqlContext.sql("SELECT \
   IF(adId IS NULL,0,adId) as AdId, \
   IF(product IS NULL,' ',product) as Product, \
   IF(label IS NULL,' ',label) as Label, \
   IF(event IS NULL,' ',event) as Event, \
   IF(attribute IS NULL,' ',attribute) as Attribute, \
   COUNT(1) as Attribute_Count, \
   SUM(value) as Value_Sum, \
   IF(version IS NULL,' ',version) as Version, \
   IF(tss IS NULL OR tss = 0, TO_DATE(FROM_UNIXTIME(CAST(LPAD(ts, 10, 0) AS int))),TO_DATE(FROM_UNIXTIME(tss))) AS Received_Date \
     FROM origin_tmp WHERE version>=0.7 \
     GROUP BY adId, product, label, event, attribute, version, IF(tss IS NULL OR tss = 0, TO_DATE(FROM_UNIXTIME(CAST(LPAD(ts, 10, 0) AS int))),TO_DATE(FROM_UNIXTIME(tss))) \
     ORDER BY AdId, Product, Label, Event, Attribute, Version, Received_Date")

  #Lets print the results
  #results = analytics.map(lambda a: str(a.adId) +" "+str(a.label) +" "+str(a.event) +" "+str(a.value) +" "+str(a.total) +" "+ str(a.ad_day))
  #for result in results.collect():
  #  print(result)

  qa = QueryAnalytics(user, password, hostname, database)

  query = "DROP TABLE IF EXISTS aggregates_by_date_tmp; \
    CREATE TABLE aggregates_by_date_tmp ( \
    `AdId` int(10) NOT NULL, \
    `Product` varchar(100) NOT NULL, \
    `Label` varchar(500) NOT NULL, \
    `Event` varchar(100) NOT NULL, \
    `Attribute` TEXT, \
    `Attribute_Count` int(10) NOT NULL, \
    `Value_Sum` int(10) DEFAULT NULL, \
    `Version` float NOT NULL, \
    `Received_Date` date NOT NULL, \
    KEY `idx_AdId_Dt_Event` (`AdId`,`Received_Date`,`Event`), \
    KEY `Received_Date` (`Received_Date`) \
  ) ENGINE=InnoDB DEFAULT CHARSET=utf8"
  qa.execute_query(query)

  #JDBC 
  mysql_url="jdbc:mysql://{0}:3306/analytics?user={1}&password={2}".format(hostname, user, password)
  analytics.write.jdbc(url=mysql_url, table="analytics.aggregates_by_date_tmp", mode="append")

  query = "RENAME TABLE aggregates_by_date TO aggregates_by_date_bkp; \
           RENAME TABLE aggregates_by_date_tmp TO aggregates_by_date; \
           RENAME TABLE aggregates_by_date_bkp TO aggregates_by_date_tmp;"
  qa.execute_query(query)

if __name__ == "__main__":
   main(sys.argv[1:])
