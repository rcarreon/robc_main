#!/usr/bin/php
<?php
  date_default_timezone_set('America/Los_Angeles');
  ini_set('memory_limit','256M');

  class ServerSettings {
      
      protected static $analytics = array("dev" => array ('host' => 'sql1v-bd.og.dev.lax.gnmedia.net',
                                                          'dbname' => 'analytics',
                                                          'user' => 'etl_load',
                                                          'password' => 'c1Q4T1dzWXdTNg=='
                                                          ),
                                          "stg" => array ('host' => 'sql1v-bd.og.stg.lax.gnmedia.net',
                                                          'dbname' => 'analytics',
                                                          'user' => 'etl_load',
                                                          'password' => 'YTRBa0l6Q3pmYQ=='
                                                          ),
                                          "prd" => array ('host' => 'VIP-SQLRW-BD.OG.PRD.LAX',
                                                          'dbname' => 'analytics',
                                                          'user' => 'etl_load',
                                                          'password' => 'N3VldFlPdHkzNg=='
                                                          )
                                         ); 
      protected static $origin = array("dev" => array ('host' => 'sql1v-origin.og.dev.lax.gnmedia.net',
                                                       'dbname' => 'origin',
                                                       'user' => 'etl_extract',
                                                       'password' => 'MFJlQnNFQ2MxNg=='
                                                       ),
                                       "stg" => array ('host' => 'sql1v-origin.og.stg.lax.gnmedia.net',
                                                       'dbname' => 'origin',
                                                       'user' => 'etl_extract',
                                                       'password' => 'QmFSTmtXNmVIZA=='
                                                      ),
                                       "prd" => array ('host' => 'VIP-SQLRO-ORIGIN.OG.PRD.LAX',
                                                       'dbname' => 'origin',
                                                       'user' => 'etl_extract',
                                                       'password' => 'MGFoczZla1RPUw=='
                                                      )
                                      ); 
      
      public static function get_server_settings ($environment, $cluster)
      {
          if ($cluster === 'analytics')
              $result = self::$analytics[$environment];
          else
              $result = self::$origin[$environment];

          return $result;
      }

  }

  class DBManager {
      protected $mysql;
      protected $driver;

      public function connect($server_settings){
          $this->mysql = new mysqli($server_settings['host'], $server_settings['user'], base64_decode($server_settings['password']), $server_settings['dbname']);

          if ($this->mysql->connect_errno)
              throw new Exception(sprintf("Failed to connect to MySQL: (%s) %s\n", $this->mysql->connect_errno, $this->mysql->connect_error));

          $this->driver = new mysqli_driver();
          $this->driver->report_mode = MYSQLI_REPORT_ERROR | MYSQLI_REPORT_STRICT;
      }

      public function load_data($query_template, $data_set){
          foreach ($data_set AS $key => $data)
          {
              foreach ($data as $key => $value)
                $data[$key] = mysqli_real_escape_string($this->mysql, $value);
              
              $query = vsprintf($query_template, $data);
              try {
                  $this->mysql->query($query);
              }
              catch (Exception $e) {
                  if ($this->mysql->errno === 2006 || $this->mysql->errno === 2013)
                      $this->mysql = mysqli_connect($this->server_settings['host'], $this->server_settings['user'], base64_decode($this->server_settings['password']), $this->server_settings['dbname']);
                  else 
                      throw new Exception(sprintf("Load data into analytics database failed:<br/><br/>\"%s\"<br/>(%s):%s<br/>%s<br/>", $query, $this->mysql->connect_errno, $this->mysql->connect_error, $e->getMessage()));
              }
          }
      }

      public function _execute($query){
          try {
              $this->mysql->query($query);
          }
          catch (Exception $e) {
              throw new Exception(sprintf("ETL %s execution failed:\n\n\"%s\"\n(%s):%s\n%s\n", $sp, $query, $this->mysql->connect_errno, $this->mysql->connect_error, $e->getMessage()));
          }
      }

      public function export_data($query){
          $data = array();

          if(!$this->mysql->connect_errno) {

              try {
                  $this->mysql->real_query($query);
              }
              catch (Exception $e) {
                  if ($this->mysql->errno === 2006 || $this->mysql->errno === 2013)
                      $this->mysql = mysqli_connect($this->server_settings['host'], $this->server_settings['user'], base64_decode($this->server_settings['password']), $this->server_settings['dbname']);
                  else {
                      $msg = sprintf("Query Execution failed:<br/>\"%s\"<br/>(%s):%s<br/>%s<br/>",  $query, $this->mysql->connect_errno, $this->mysql->connect_error, $e->getMessage());
                      throw new Exception($msg);
                  }                    
              }

              $res = $this->mysql->use_result();

              if ($res !== false) {

                  for ($tmp = array(), $i = 0; $tmp = $res->fetch_array(MYSQLI_ASSOC);$i++)
                      $data[] = $tmp;

                  $res->free();

                  while($this->mysql->more_results())
                  {
                      $this->mysql->next_result();
                      if($res = $this->mysql->store_result())
                          $res->free();
                  }
              }
          }

          return $data;
      }

      public function close_connection(){
        if (!$this->mysql->close())
          throw new Exception(sprintf("Failed to close connection to MySQL: (%s) %s\n", $this->mysql->connect_errno, $this->mysql->connect_error));
      }

  }

  class EmailManager {
      protected $to =  array('DBA<dba@evolvemediallc.com>');
      protected $subject = '';
      protected $message = '';
      protected $headers = array('From: MySQL ETL<mysql@app1v-dbops.tp.prd.lax.gnmedia.net>',
                                 'MIME-Version: 1.0',
                                 'Content-type: text/html; charset=utf-8',
                                 'Reply-To: no-reply@app1v-dbops.tp.prd.lax.gnmedia.net'
                                 );

      public function set_subject($subject){
          $this->subject = $subject;
      }

      public function set_message($message) {
          $this->message = $message;
      }

      public function send_email(){
          mail(implode(",", $this->to), $this->subject, $this->message, implode("\r\n", $this->headers));
      }
  }

  class Tools {

    public static function process_rowset($rowset) {
      $columns = array("category", "brand");
      $result = array();

      foreach ($rowset as $key => $row)
        if (in_array($key, $columns))
          $result = array_merge($result, array($key => (isset($row["name"])? $row["name"] : "")));
      
      return $result;            
    }
  }

  /*  Main Process */
  $origin = new DBManager();
  $analytics = new DBManager();
  $email = new EmailManager();
  
  $shortops = "e:h::";
  $longopts = array("environment:", "help::");
  $options = getopt($shortops, $longopts);

  if (!isset($options['e']) && !isset($options['environment']))
      die("You must specify environment to run this ETL\n");

  $environment = isset($options['e'])? $options['e']: $options['environment'];
  $subject_error = sprintf('%s:OG-ERROR [ETL Origin to Analytics]', strtoupper($environment));
  $email->set_subject($subject_error);

  try{
      $origin->connect(ServerSettings::get_server_settings(strtolower($environment), 'origin'));
  }
  catch  (Exception $e){
      $msg = sprintf("Could not open connection to origin \n%s\n", $e->getMessage());
      $email->set_message($msg);
      $email->send_email();
      die();
  }

  try{
      $analytics->connect(ServerSettings::get_server_settings(strtolower($environment), 'analytics'));
  }
  catch  (Exception $e){
      $msg = sprintf("Could not open connection to analytics \n%s\n", $e->getMessage());
      $email->set_message($msg);
      $email->send_email();
      $origin->close_connection();
      die();
  }

  try{
      $data_set = $origin->export_data("SELECT ad_id, json FROM adjson WHERE adjson.updated_at >= DATE_SUB(CURRENT_TIMESTAMP, INTERVAL 70 MINUTE)");
  }
  catch  (Exception $e){
      $msg = sprintf("ETL:\n\nCould not get ad data from origin\n%s\n",$e->getMessage());
      $email->set_message($msg);
      $email->send_email();
      $origin->close_connection();
      $analytics->close_connection();
      die();
  }

  $rowset = array();
  foreach ($data_set as $row) {
    $rowset[] = array_merge(array("ad_id" => $row["ad_id"]), Tools::process_rowset(json_decode($row["json"], true)));
  }
  unset($data_set);

  $load_query = "INSERT INTO ad_description(ad_id, brand, category) 
                 VALUES(%s, '%s', '%s')
                     ON DUPLICATE KEY UPDATE 
                          brand = VALUES(brand),
                          category = VALUES(category)";
  
  try{
      $analytics->load_data($load_query, $rowset);
  }
  catch  (Exception $e){
      $msg = sprintf("ETL:\n\nCould not import data into analytics database\n%s\n",$e->getMessage());
      $email->set_message($msg);
      $email->send_email();
      $origin->close_connection();
      $analytics->close_connection();
      die();
  }

  $sql_export = "SELECT ad.id, ad.company_id, title, product.name FROM ad JOIN product ON product.id = product_id ORDER BY ad.id";
  try{
      $data_set = $origin->export_data($sql_export);
  }
  catch  (Exception $e){
      $msg = sprintf("ETL:\n\nCould not get ad data from origin\n%s\n",$e->getMessage());
      $email->set_message($msg);
      $email->send_email();
      $origin->close_connection();
      $analytics->close_connection();
      die();
  }

  $load_query = "INSERT INTO ad(ad_id, company_id, title, product) 
                 VALUES(%s, '%s', '%s', '%s')
                     ON DUPLICATE KEY UPDATE 
                          company_id = VALUES(company_id),
                          title = VALUES(title),
                          product = VALUES(product)";
  
  try{
      $analytics->load_data($load_query, $data_set);
  }
  catch  (Exception $e){
      $msg = sprintf("ETL:\n\nCould not import data into analytics database\n%s\n",$e->getMessage());
      $email->set_message($msg);
      $email->send_email();
      $origin->close_connection();
      $analytics->close_connection();
      die();
  }

  $sql_export = "SELECT id, name, created_at FROM companies";
  try{
      $data_set = $origin->export_data($sql_export);
  }
  catch  (Exception $e){
      $msg = sprintf("ETL:\n\nCould not get companies data from origin\n%s\n",$e->getMessage());
      $email->set_message($msg);
      $email->send_email();
      $origin->close_connection();
      $analytics->close_connection();
      die();
  }

  $load_query = "INSERT INTO companies(id, name, created_at) 
                 VALUES(%s, '%s', '%s')
                     ON DUPLICATE KEY UPDATE 
                          name = VALUES(name),
                          created_at = VALUES(created_at)";
  
  try{
      $analytics->load_data($load_query, $data_set);
  }
  catch  (Exception $e){
      $msg = sprintf("ETL:\n\nCould not import data into analytics database\n%s\n",$e->getMessage());
      $email->set_message($msg);
      $email->send_email();
      $origin->close_connection();
      $analytics->close_connection();
      die();
  }

  $origin->close_connection();
  $analytics->close_connection();

?>
