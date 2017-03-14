#!/usr/bin/php
<?php
    date_default_timezone_set('America/Los_Angeles');
    ini_set('memory_limit','256M');

    class ServerSettings {
        protected static $sql_warehouse = array ('host' => 'VIP-SQLRW-DW.CI.%s.LAX',
                                                 'dbname' => 'warehouse',
                                                 'user' => 'etl_ci_load',
                                                 'password' => 'T0Z2REh5SXg='
                                                );

        public static function get_server_settings ($environment, $cluster)
        {
            if ($cluster === 'warehouse')
                $result = self::$sql_warehouse;
            elseif ($cluster === 'audit')
                $result = self::$sql_audit;
            else
                $result = self::$sql_tewn;

            $result['host'] = sprintf($result['host'], $environment);

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

        public function _execute($stores, $process_date){
            $query_template = "CALL %s('%s')";
            foreach ($stores AS $sp)
            {
                $query = sprintf($query_template, $sp, $process_date);
                try {
                    $this->mysql->query($query);
                }
                catch (Exception $e) {
                    throw new Exception(sprintf("ETL %s execution failed:\n\n\"%s\"\n(%s):%s\n%s\n", $sp, $query, $this->mysql->connect_errno, $this->mysql->connect_error, $e->getMessage()));
                }
            }
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

    /*  Main Process */
    $warehouse_server = new DBManager();
    $email = new EmailManager();
    $stores = array(
                    "dw_ci_sp_insert_website_metrics_cpc_source",
                    "dw_ci_sp_insert_website_metrics_sa_source",
                    "dw_ci_sp_insert_website_metrics_swa_source",
                    "dw_ci_sp_insert_website_metrics_sw_source",
                    "dw_ci_sp_insert_website_metrics_clp_source",
                    "dw_ci_sp_insert_website_metrics_daily",
                    "dw_ci_sp_insert_website_credits"
                    );
    
    $shortops = "e:h::";
    $longopts = array("environment:", "help::");
    $options = getopt($shortops, $longopts);

    if (!isset($options['e']) && !isset($options['environment']))
        die("You must specify environment to run this ETL\n");

    $environment = isset($options['e'])? $options['e']: $options['environment'];
    $subject_error = sprintf('%s:CI-ERROR [ETL Website Metrics]', strtoupper($environment));
    $email->set_subject($subject_error);

    try{
        $warehouse_server->connect(ServerSettings::get_server_settings(strtoupper($environment), 'warehouse'));
    }
    catch  (Exception $e){
        $msg = sprintf("Could not open connection to data warehouse\n%s\n", $e->getMessage());
        $email->set_message($msg);
        $email->send_email();
        die();
    }

    

    try{
        $process_date = date('Y-m-d H:00:00');
        $warehouse_server->_execute($stores, $process_date);
    }
    catch  (Exception $e){
        $msg = sprintf("ETL:\n\nCould not process website metrics in data warehouse\n%s\n",$e->getMessage());
        $email->set_message($msg);
        $email->send_email();
        $warehouse_server->close_connection();
        die();
    }

    $warehouse_server->close_connection();

?>