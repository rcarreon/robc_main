import mysql.connector, base64, sys 
from mysql.connector.errors import Error
from pyspark import SparkContext, SparkConf
from pyspark.sql import SQLContext
from datetime import timedelta, date
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

def fileExists(_path):
  _result = False
  
  p = subprocess.Popen(['hdfs', 'dfs', '-find', _path], stdout=subprocess.PIPE)

  for _stdout in p.stdout:
    if (_stdout.find('No such file or directory', 0) < 0):
      _result = True

  return _result


def main(argv):

  conf = SparkConf().setAppName("Pixel ETL")
  conf.set("spark.app.id", uuid.uuid4())
  sc = SparkContext(conf=conf)
  sqlContext = SQLContext(sc)

  environment = 'prd'
  hdfs = 'zootpprd'
  start_date = date(2016,05,18)
  end_date = date.today()

  user = 'spark'
  database = 'analytics'
  cnn_string = {}
  cnn_string['dev'] = {'server':'sql1v-bd.og.dev.lax.gnmedia.net', 'password':'QnJxU3A3YXduT0Uw'}
  cnn_string['stg'] = {'server':'sql1v-bd.og.stg.lax.gnmedia.net', 'password':'bHFTOG5QOVBqb0ZN'}
  cnn_string['prd'] = {'server':'VIP-SQLRW-BD.OG.PRD.LAX.GNMEDIA.NET', 'password':'YlR0cEQwaUdzUU85'}
  
  qa = QueryAnalytics(user, base64.b64decode(cnn_string[environment]['password']), cnn_string[environment]['server'], database)

  query = "TRUNCATE TABLE aggregates_by_date_ver2_tmp"
  qa.execute_query(query)

  for single_date in daterange(start_date, end_date):
    file = "hdfs://{0}/spark/origin/processed/{1}/{2}/{3}/beacon_data.{4}".format(hdfs, environment, single_date.year, single_date.strftime("%m"), single_date.strftime("%d"))
    print "Processing file {0} ....".format(file)
    if (fileExists(file)):
      try:
        select_origin = sqlContext.read.json("hdfs://{0}/spark/origin/processed/{1}/{2}/{3}/beacon_data.{4}".format(hdfs, environment, single_date.year, single_date.strftime("%m"), single_date.strftime("%d")))
        select_origin.cache()
      except Exception as ex:
        print str(ex)
    
      select_origin.registerTempTable("pixel_ver2")
      analytics = sqlContext.sql("SELECT IF(adId IS NULL, 0, adId) as adid, UNIX_TIMESTAMP(TO_DATE(FROM_UNIXTIME(ts))) as created_at, " \
                                 "       IF(event IS NULL, '', event) as event, IF(attr IS NULL, '', attr) as attribute, " \
                                 "       IF(attrLabel IS NULL, '', attrLabel) as attribute_label, " \
                                 "       IF(SUM(isClick) IS NULL, 0, SUM(isClick)) as clicks, " \
                                 "       IF(SUM(isInteraction) IS NULL, 0, SUM(isInteraction)) as interactions, " \
                                 "       IF(SUM(isEngagement) IS NULL, 0, SUM(isEngagement)) as engagements, " \
                                 "       IF(SUM(timespent) IS NULL, 0, SUM(timespent)) as timespent " \
                                 "FROM pixel_ver2 " \
                                 "WHERE version = 2 " \
                                 "GROUP BY TO_DATE(FROM_UNIXTIME(ts)), adId, event, attr, attrLabel ")

      mysql_url="jdbc:mysql://{0}:3306/analytics?user={1}&password={2}".format(cnn_string[environment]['server'], user, base64.b64decode(cnn_string[environment]['password']))
      analytics.write.jdbc(url=mysql_url, table="analytics.aggregates_by_date_ver2_tmp", mode="append")

  query = "CALL og_sp_insert_pixel_data()"
  qa.execute_query(query)

if __name__ == "__main__":
   main(sys.argv[1:])
