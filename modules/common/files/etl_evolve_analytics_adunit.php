#!/usr/bin/php
<?php
  date_default_timezone_set('America/Los_Angeles');
  ini_set('memory_limit','350M');

  class ServerSettings {
      protected static $analytics = array("DEV" => array ('host' => 'sql1v-bd.og.dev.lax.gnmedia.net',
                                                          'dbname' => 'analytics',
                                                          'user' => 'etl_load',
                                                          'password' => 'c1Q4T1dzWXdTNg=='
                                                          ),
                                          "STG" => array ('host' => 'sql1v-bd.og.stg.lax.gnmedia.net',
                                                          'dbname' => 'analytics',
                                                          'user' => 'etl_load',
                                                          'password' => 'YTRBa0l6Q3pmYQ=='
                                                          ),
                                          "PRD" => array ('host' => 'VIP-SQLRW-BD.OG.PRD.LAX',
                                                          'dbname' => 'analytics',
                                                          'user' => 'etl_load',
                                                          'password' => 'N3VldFlPdHkzNg=='
                                                          )
                                         ); 
      protected static $origin = array("DEV" => array ('host' => 'sql1v-origin.og.dev.lax.gnmedia.net',
                                                       'dbname' => 'origin',
                                                       'user' => 'etl_extract',
                                                       'password' => 'MFJlQnNFQ2MxNg=='
                                                       ),
                                       "STG" => array ('host' => 'sql1v-origin.og.stg.lax.gnmedia.net',
                                                       'dbname' => 'origin',
                                                       'user' => 'etl_extract',
                                                       'password' => 'QmFSTmtXNmVIZA=='
                                                      ),
                                       "PRD" => array ('host' => 'VIP-SQLRO-ORIGIN.OG.PRD.LAX',
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
      protected $server_settings;

      public function connect($server_settings){
          $this->mysql = new mysqli($server_settings['host'], $server_settings['user'], base64_decode($server_settings['password']), $server_settings['dbname']);
          $this->server_settings = $server_settings;

          if ($this->mysql->connect_errno)
              throw new Exception(sprintf("Failed to connect to MySQL: (%s) %s<br/>", $this->mysql->connect_errno, $this->mysql->connect_error));

          $this->driver = new mysqli_driver();
          $this->driver->report_mode = MYSQLI_REPORT_ERROR | MYSQLI_REPORT_STRICT;
      }

      public function load_data($query_template, $data_set){
          foreach ($data_set AS $key => $data)
          {
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
              throw new Exception(sprintf("ETL execution failed:<br/><br/>\"%s\"<br/>(%s):%s<br/>%s<br/>", $query, $this->mysql->connect_errno, $this->mysql->connect_error, $e->getMessage()));
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
              throw new Exception(sprintf("Failed to close connection to MySQL: (%s) %s<br/>", $this->mysql->connect_errno, $this->mysql->connect_error));
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
          $this->message = sprintf("<html><body style=\"font-size: 12px;font-family: Arial;\">%s</body></html>", $message);
      }

      public function send_email(){
          mail(implode(",", $this->to), $this->subject, $this->message, implode("\r\n", $this->headers));
      }
  }

  /*  Main Process */
  $analytics_server = new DBManager();
  $origin_server = new DBManager();
  $email = new EmailManager();
  $sql_statements = array(
                      array(
                          "sp" => "ea_og_sp_insert_adunit_metrics",
                          "query" => ""
                           )
                         );

  $shortops = "e:t:h::";
  $longopts = array("environment:", "time:", "help::");
  $options = getopt($shortops, $longopts);

  if (!isset($options['e']) && !isset($options['environment']))
      die("You must specify environment to run this ETL\n");

  $environment = isset($options['e'])? $options['e']: $options['environment'];
  $subject_error = sprintf('%s:EA-ERROR [ETL Evolve Analytic AdUnits]', strtoupper($environment));
  $email->set_subject($subject_error);

  try{
      $analytics_server->connect(ServerSettings::get_server_settings(strtoupper($environment), 'analytics'));
  }
  catch  (Exception $e){
      $msg = sprintf("Could not open connection to analytics<br/>%s<br/><br/>Server Connected => %s<br/>", $e->getMessage(), $analytics_server->hostname);
      $email->set_message($msg);
      $email->send_email();
      die();
  }

  $data = array();
  try{
      if (isset($options['t']) || isset($options['time']))
          $date2process = isset($options['t'])? $options['t']: $options['time'];
      else
          $date2process = date('Y-m-d');

      $query = sprintf("CALL %s(%s,%s)", $sql_statements[0]["sp"], strtotime($date2process), strtotime($date2process));
      $analytics_server->_execute($query);

  }
  catch  (Exception $e){
      $msg = sprintf("ETL:<br/>Could not load analytic metrics in analytics database<br/>%s<br/><br/>",$e->getMessage());
      $email->set_message($msg);
      $email->send_email();
      $analytics_server->close_connection();
      die();
  }

  $analytics_server->close_connection();

?>