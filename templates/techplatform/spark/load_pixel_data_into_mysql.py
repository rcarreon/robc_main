import mysql.connector, base64, sys 
from mysql.connector.errors import Error
from pyspark import SparkContext, SparkConf
from pyspark.sql import SQLContext
from datetime import date, timedelta
import subprocess, uuid

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

def daterange(start_date, end_date):
  for n in range(int (((end_date - start_date).days) + 1)):
    yield start_date + timedelta(n)

def main(argv):

  environment = 'prd'
  conf = SparkConf().setAppName("Pixel LOAD DATA INTO {0}".format(environment.upper()))
  conf.set("spark.app.id", uuid.uuid4())
#  conf.setMaster("spark://app1v-spark-bd.og.prd.lax.gnmedia.net:7077,app2v-spark-bd.og.prd.lax.gnmedia.net:7077,app3v-spark-bd.og.prd.lax.gnmedia.net:7077")
  sc = SparkContext(conf=conf)
  sqlContext = SQLContext(sc)

  hdfs = 'zootpprd'
  start_date = date(2016,06,08)
  end_date = date(2016,07,05)

  user = 'spark'
  database = 'analytics'
  cnn_string = {}
  cnn_string['dev'] = {'server':'sql1v-bd.og.dev.lax.gnmedia.net', 'password':'QnJxU3A3YXduT0Uw'}
  cnn_string['stg'] = {'server':'sql1v-bd.og.stg.lax.gnmedia.net', 'password':'bHFTOG5QOVBqb0ZN'}
  cnn_string['prd'] = {'server':'sql1v-bd.og.prd.lax.gnmedia.net', 'password':'YlR0cEQwaUdzUU85'}
  
  qa = QueryAnalytics(user, base64.b64decode(cnn_string[environment]['password']), cnn_string[environment]['server'], database)

  query = "TRUNCATE TABLE pixel_data2; TRUNCATE TABLE pixel_data1;"
  qa.execute_query(query)
  mysql_url="jdbc:mysql://{0}:3306/analytics?user={1}&password={2}".format(cnn_string[environment]['server'], user, base64.b64decode(cnn_string[environment]['password']))

  for process_date in daterange(start_date, end_date):

    try:
      select_origin = sqlContext.read.json("hdfs://{0}/spark/origin/processed/{1}/{2}/{3}/beacon_data.{4}".format(hdfs, environment, process_date.year, process_date.strftime("%m"), process_date.strftime("%d")))
    except Exception as ex:
      print str(ex)

    select_origin.registerTempTable("pixel_data")
    analytics = sqlContext.sql("SELECT IF(adId IS NULL, 0, adId) as adid, " \
                               "       IF(sessionid IS NULL, '', sessionid) as sessionid, " \
                               "       ts as created_at, " \
                               "       IF(event IS NULL, '', event) as event, IF(attr IS NULL, '', attr) as attribute, " \
                               "       IF(attrLabel IS NULL, '', attrLabel) as attribute_label, " \
                               "       IF(isClick IS NULL, 0, isClick) as isclick, " \
                               "       IF(isInteraction IS NULL, 0, isInteraction) as isInteraction, " \
                               "       IF(isEngagement IS NULL, 0, isEngagement) as isEngagement, " \
                               "       IF(timespent IS NULL, 0, timespent) as timespent, version " \
                               "FROM pixel_data " \
                               "WHERE version >= 2 AND adId = 1539")
    analytics.write.jdbc(url=mysql_url, table="analytics.pixel_data2", mode="append")

    analytics = sqlContext.sql("SELECT IF(adId IS NULL, 0, adId) as adid, " \
                               "       IF(sessionid IS NULL, '', sessionid) as sessionid, " \
                               "       ts as received_date, " \
                               "       IF(event IS NULL, '', event) as event, IF(attr IS NULL, '', attr) as attribute, " \
                               "       IF(label IS NULL, '', label) as label, " \
                               "       IF(product IS NULL, '', product) as product, " \
                               "       version " \
                               "FROM pixel_data " \
                               "WHERE version < 2 AND adId = 1539")
    analytics.write.jdbc(url=mysql_url, table="analytics.pixel_data1", mode="append")
  sc.stop()
  
if __name__ == "__main__":
   main(sys.argv[1:])
