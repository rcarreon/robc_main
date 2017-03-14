import mysql.connector, base64, sys 
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

  conf = SparkConf().setAppName("BCN OG STG analytics")
  sc = SparkContext(conf=conf)
  sqlContext = SQLContext(sc)

  user = 'spark'
  password = base64.b64decode("bHFTOG5QOVBqb0ZN");
  hostname = 'sql1v-bd.og.stg.lax.gnmedia.net'
  database = 'analytics'
  
  hdfs = 'zootpprd'

  #For STG we're processing data from STG 2016
  select_origin = sqlContext.read.json("hdfs://{0}/spark/origin/processed/dev/2016/*/*".format(hdfs))
  select_origin.cache()

  select_origin.registerTempTable("origin_tmp")
  analytics = sqlContext.sql("SELECT \
   IF(adId IS NULL,0,adId) as AdId, \
   IF(product IS NULL,' ',product) as Product, \
   IF(label IS NULL,' ',label) as Label, \
   IF(event IS NULL,' ',event) as Event, \
   IF(attribute IS NULL,' ',attribute) as Attribute, \
   COUNT(1) as Attribute_Count, \
   SUM(value) as Value_Sum, \
   IF(version IS NULL, 0.0,version) as Version, \
   TO_DATE(FROM_UNIXTIME(ts)) AS Received_Date \
     FROM origin_tmp \
     GROUP BY adId, product, label, event, attribute, version, TO_DATE(FROM_UNIXTIME(ts)) \
     ORDER BY AdId, Product, Label, Event, Attribute, Version, Received_Date")

  qa = QueryAnalytics(user, password, hostname, database)

  query = "DROP TABLE IF EXISTS bcn_aggregates_by_date_tmp; \
    CREATE TABLE bcn_aggregates_by_date_tmp ( \
    `AdId` int(10) NOT NULL, \
    `Product` varchar(100) NOT NULL, \
    `Label` varchar(500) NOT NULL, \
    `Event` varchar(100) NOT NULL, \
    `Attribute` TEXT, \
    `Attribute_Count` int(10) NOT NULL, \
    `Value_Sum` int(10) DEFAULT NULL, \
    `Version` Decimal(4, 1) NOT NULL, \
    `Received_Date` date, \
    KEY `idx_AdId_Dt_Event` (`AdId`,`Received_Date`,`Event`), \
    KEY `Received_Date` (`Received_Date`) \
  ) ENGINE=InnoDB DEFAULT CHARSET=utf8"
  qa.execute_query(query)

  #JDBC 
  mysql_url="jdbc:mysql://{0}:3306/analytics?user={1}&password={2}".format(hostname, user, password)
  analytics.write.jdbc(url=mysql_url, table="analytics.bcn_aggregates_by_date_tmp", mode="append")

  query = "RENAME TABLE bcn_aggregates_by_date TO bcn_aggregates_by_date_bkp; \
           RENAME TABLE bcn_aggregates_by_date_tmp TO bcn_aggregates_by_date; \
           RENAME TABLE bcn_aggregates_by_date_bkp TO bcn_aggregates_by_date_tmp;"
  qa.execute_query(query)

if __name__ == "__main__":
   main(sys.argv[1:])
