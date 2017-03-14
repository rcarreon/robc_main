#!/usr/bin/php
<?php
    date_default_timezone_set('America/Los_Angeles');
    ini_set('memory_limit','350M');

    class ServerSettings {
        protected static $sql_warehouse = array ('host' => 'VIP-SQLRW-DW.CI.%s.LAX',
                                                 'dbname' => 'warehouse',
                                                 'user' => 'etl_ci_load',
                                                 'password' => 'T0Z2REh5SXg='
                                                );

        protected static $sql_tewn = array ('host' => 'VIP-SQLRO-CI.CI.%s.LAX',
                                            'dbname' => 'tewn',
                                            'user' => 'etl_ci_extract',
                                            'password' => 'NGNNNkxWQ1g='
                                            );

        public $hostname = "";

        public static function get_server_settings ($environment, $cluster)
        {
            if ($cluster === 'warehouse')
                $result = self::$sql_warehouse;
            elseif ($cluster === 'audit')
                $result = self::$sql_audit;
            else
                $result = self::$sql_tewn;

            if ($environment === 'DEV')
                $result['host'] = sprintf('sql1v-56-%s.ci.dev.lax.gnmedia.net', $cluster === 'warehouse'? 'dw':'ci');
            else
                $result['host'] = sprintf($result['host'], $environment);

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
                throw new Exception(sprintf("Failed to connect to MySQL: (%s) %s\n", $this->mysql->connect_errno, $this->mysql->connect_error));

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
                        throw new Exception(sprintf("Load data into warehouse failed:<br/><br/>\"%s\"<br/>(%s):%s<br/>%s<br/>", $query, $this->mysql->connect_errno, $this->mysql->connect_error, $e->getMessage()));
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
            $this->message = sprintf("<html><body style=\"font-size: 12px;font-family: Arial;\">%s</body></html>", $message);
        }

        public function send_email(){
            mail(implode(",", $this->to), $this->subject, $this->message, implode("\r\n", $this->headers));
        }
    }

    /*  Main Process */
    $warehouse_server = new DBManager();
    $tewn_server = new DBManager();
    $email = new EmailManager();
    $sql_statements = array(
                        array(
                            "sp" => "ci_ci_sp_select_widget_analytics_created",
                            "query" => "INSERT INTO widget_analytics_metrics (created, daily_created, shown_hub, shown_website_id, hub, website_id, basic_created, contextual_created, similar_created)
                                        VALUES(%s, %s, %s, %s, %s, %s, %s, %s, %s)
                                        ON DUPLICATE KEY UPDATE basic_created = VALUES(basic_created), similar_created = VALUES(similar_created), contextual_created = VALUES(contextual_created)"
                             ),
                        array(
                            "sp" => "ci_ci_sp_select_widget_analytics_status",
                            "query" => "INSERT INTO widget_analytics_metrics (created, daily_created, shown_hub, shown_website_id, hub, website_id, basic_enable, contextual_enable, similar_enable, basic_disable, contextual_disable, similar_disable)
                                        VALUES(%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
                                        ON DUPLICATE KEY UPDATE basic_enable = VALUES(basic_enable), basic_disable = VALUES(basic_disable), similar_enable = VALUES(similar_enable),
                                                                similar_disable = VALUES(similar_disable), contextual_enable = VALUES(contextual_enable),  contextual_disable = VALUES(contextual_disable)"
                             ),
                        array(
                            "sp" => "ci_ci_sp_select_landing_page_analytics_created",
                            "query" => "INSERT INTO landing_page_analytics_metrics (created, daily_created, shown_hub, hub, website_id, basic_created, contextual_created, similar_created)
                                        VALUES(%s, %s, %s, %s, %s, %s, %s, %s)
                                        ON DUPLICATE KEY UPDATE basic_created = VALUES(basic_created), similar_created = VALUES(similar_created), contextual_created = VALUES(contextual_created)"
                             ),
                        array(
                            "sp" => "ci_ci_sp_select_landing_page_analytics_status",
                            "query" => "INSERT INTO landing_page_analytics_metrics (created, daily_created, shown_hub, hub, website_id, basic_enable, contextual_enable, similar_enable, basic_disable, contextual_disable, similar_disable)
                                        VALUES(%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
                                        ON DUPLICATE KEY UPDATE basic_enable = VALUES(basic_enable), basic_disable = VALUES(basic_disable), similar_enable = VALUES(similar_enable),
                                                                similar_disable = VALUES(similar_disable), contextual_enable = VALUES(contextual_enable),  contextual_disable = VALUES(contextual_disable)"
                             )
                           );

    $shortops = "e:t:h::";
    $longopts = array("environment:", "time:", "help::");
    $options = getopt($shortops, $longopts);

    if (!isset($options['e']) && !isset($options['environment']))
        die("You must specify environment to run this ETL\n");

    $environment = isset($options['e'])? $options['e']: $options['environment'];
    $subject_error = sprintf('%s:CI-ERROR [ETL Analytic Metrics]', strtoupper($environment));
    $email->set_subject($subject_error);

    try{
        $warehouse_server->connect(ServerSettings::get_server_settings(strtoupper($environment), 'warehouse'));
    }
    catch  (Exception $e){
        $msg = sprintf("Could not open connection to data warehouse<br/>%s<br/><br/>Server Connected => %s<br/>", $e->getMessage(), $warehouse_server->hostname);
        $email->set_message($msg);
        $email->send_email();
        die();
    }

    try{
        $tewn_server->connect(ServerSettings::get_server_settings(strtoupper($environment), 'tewn'));
        $host = $tewn_server->export_data("SELECT VARIABLE_VALUE AS server FROM INFORMATION_SCHEMA.SESSION_VARIABLES WHERE VARIABLE_NAME = 'HOSTNAME'");
        $tewn_server->hostname = $host[0]["server"];
    }
    catch  (Exception $e){
        $msg = sprintf("Could not open connection to tewn database<br/>%s<br/><br/>Server Connected => %s<br/>", $e->getMessage(), $warehouse_server->hostname);
        $email->set_message($msg);
        $email->send_email();
        die();
    }

    $data = array();
    try{
        if (isset($options['t']) || isset($options['time']))
            $date2process = array(isset($options['t'])? $options['t']: $options['time']);
        else
            $date2process = array(date('Y-m-d H:00:00', strtotime('-1 hour')), date('Y-m-d H:00:00'));

        $load_time = array("tewn_start" => 0, 
                           "tewn_end" => 0,
                           "warehouse_end" => 0 );

        foreach ($date2process as $process_date) {
            foreach ($sql_statements as $stmt) {
                $load_time["tewn_start"] = microtime(true);
                $query = sprintf("CALL %s('%s')", $stmt["sp"], $process_date);
                $data = $tewn_server->export_data($query);
                $load_time["tewn_end"] = microtime(true);
                $warehouse_server->load_data($stmt["query"], $data);
                $load_time["warehouse_end"] = microtime(true);
                unset($data);
            }
            $query = sprintf("CALL dw_ci_sp_insert_daily_analytics('%s')", $process_date);
            $warehouse_server->_execute($query);
        }

    }
    catch  (Exception $e){
        $msg = sprintf("ETL:<br/>Could not load analytic metrics in data warehouse<br/>%s<br/><br/>Tewn Host Connected => %s<br/>Execution Load on tewn cluster => %s seconds<br/> Execution Load on warehouse %s seconds",$e->getMessage(), $tewn_server->hostname, ($load_time["tewn_end"] - $load_time["tewn_start"]), ($load_time["warehouse_end"] - $load_time["tewn_end"]));
        $email->set_message($msg);
        $email->send_email();
        $warehouse_server->close_connection();
        $tewn_server->close_connection();
        die();
    }

    $warehouse_server->close_connection();
    $tewn_server->close_connection();

?>