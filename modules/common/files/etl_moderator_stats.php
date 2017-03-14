#!/usr/bin/php
<?php
    date_default_timezone_set('America/Los_Angeles');
    ini_set('memory_limit','256M');

    class ServerSettings {
        protected static $sql_tewn = array ('host' => 'VIP-SQLRW-CI.CI.%s.LAX',
                                            'dbname' => 'tewn',
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

            if ($environment === 'DEV')
                $result['host'] = 'sql1v-56-ci.ci.dev.lax.gnmedia.net';
            else
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

        public function _execute($stored_procs){
            $query_template = "CALL %s('%s')";
            $process_date = date('Y-m-d');
            foreach ($stored_procs AS $sp)
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
    $tewn_server = new DBManager();
    $email = new EmailManager();
    $stored_procs = array(
                          "ci_ci_sp_insert_moderator_stats"
                         );
    
    $shortops = "e:h::";
    $longopts = array("environment:", "help::");
    $options = getopt($shortops, $longopts);

    if (!isset($options['e']) && !isset($options['environment']))
        die("You must specify environment to run this ETL\n");

    $environment = isset($options['e'])? $options['e']: $options['environment'];
    $subject_error = sprintf('%s:CI-ERROR [ETL Moderator Stats]', strtoupper($environment));
    $email->set_subject($subject_error);

    try{
        $tewn_server->connect(ServerSettings::get_server_settings(strtoupper($environment), 'tewn'));
    }
    catch  (Exception $e){
        $msg = sprintf("Could not open connection to oltp cluster\n%s\n", $e->getMessage());
        $email->set_message($msg);
        $email->send_email();
        die();
    }

    try{
        $tewn_server->_execute($stored_procs);
    }
    catch  (Exception $e){
        $msg = sprintf("ETL:\n\nCould not process moderator stats\n%s\n",$e->getMessage());
        $email->set_message($msg);
        $email->send_email();
        $tewn_server->close_connection();
        die();
    }

    $tewn_server->close_connection();

?>
