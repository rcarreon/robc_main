#!/usr/bin/php
<?php
    date_default_timezone_set('America/Los_Angeles');
    ini_set('memory_limit','256M');
    require_once('etl_css.php');

    class ServerSettings {
        protected static $sql_audit = array ('host' => 'VIP-SQLRW-AUDIT.CI.%s.LAX',
                                             'dbname' => 'audit',
                                             'user' => 'etl_ci_extract',
                                             'password' => 'NGNNNkxWQ1g='
                                            );

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

        public function load_data($query_template, $data_set){
            foreach ($data_set AS $key => $data)
            {
                $query = vsprintf($query_template, $data);
                try {
                    $this->mysql->query($query);
                }
                catch (Exception $e) {
                    throw new Exception(sprintf("Load data into warehouse failed:<br/><br/>\"%s\"<br/>(%s):%s<br/>%s<br/>", $query, $this->mysql->connect_errno, $this->mysql->connect_error, $e->getMessage()));
                }
            }
        }

        public function load_data_with_rs($query_template, $data_set){
            $report_data = array();

            foreach ($data_set AS $key => $data)
            {
                $query = vsprintf($query_template, $data);

                if(!$this->mysql->connect_errno) {

                    try {
                        $this->mysql->real_query($query);
                    }
                    catch (Exception $e) {
                        $msg = sprintf("Query Execution failed:<br/>\"%s\"<br/>(%s):%s<br/>%s<br/>",  $query, $this->mysql->connect_errno, $this->mysql->connect_error, $e->getMessage());
                        throw new Exception($msg);
                    }

                    $res = $this->mysql->use_result();

                    if ($res) {
                        for ($tmp = array(); $tmp = $res->fetch_array(MYSQLI_ASSOC);)
                            $report_data[] = $tmp;
                        $res->free();
                    }

                    while($this->mysql->more_results())
                    {
                        $this->mysql->next_result();
                        if($res = $this->mysql->store_result())
                            $res->free();
                    }
                }
            }

            return $report_data;
        }


        public function export_data($query){
            $data = array();

            if(!$this->mysql->connect_errno) {

                try {
                    $this->mysql->real_query($query);
                }
                catch (Exception $e) {
                    $msg = sprintf("Query Execution failed:<br/>\"%s\"<br/>(%s):%s<br/>%s<br/>",  $query, $this->mysql->connect_errno, $this->mysql->connect_error, $e->getMessage());
                    throw new Exception($msg);
                }

                $res = $this->mysql->use_result();

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

            return $data;
        }

        public function has_active_campaigns() {
            $query = "SELECT COUNT(0) AS Actives FROM cpc_campaign WHERE (status = 0 OR status = 4) AND third_party = '' AND updated > DATE_SUB(CURRENT_DATE,INTERVAL 1 DAY)";
            $result = true;
            
            if(!$this->mysql->connect_errno) {

                try {
                    $this->mysql->real_query($query);
                }
                catch (Exception $e) {
                    $msg = sprintf("Query Execution failed:<br/>\"%s\"<br/>(%s):%s<br/>%s<br/>",  $query, $this->mysql->connect_errno, $this->mysql->connect_error, $e->getMessage());
                    throw new Exception($msg);
                }

                $res = $this->mysql->use_result();

                for ($tmp = array(), $i = 0; $tmp = $res->fetch_array(MYSQLI_ASSOC);$i++)
                    $result = ($tmp["Actives"] > 0 ? true : false);

                $res->free();

                while($this->mysql->more_results())
                {
                    $this->mysql->next_result();
                    if($res = $this->mysql->store_result())
                        $res->free();
                }
            }
            
            return $result;            
        }

        public function close_connection(){
            if (!$this->mysql->close())
                throw new Exception(sprintf("Failed to close connection to MySQL: (%s) %s<br/>", $this->mysql->connect_errno, $this->mysql->connect_error));
        }

    }

    class EmailManager {

        protected $to =  array('DBA<dba@evolvemediallc.com>', 'Tech Team Crowd Ignite <TechTeamCrowdIgnite@evolvemediallc.com>');
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

        public function get_html_table_body($data_set, $metric) {
            $more_than_ten = false;
            $body = sprintf("<div class=\"CSSTableGenerator\" >
                             <table>
                                <tr>
                                    <td>%s</td><td>Campaign</td><td>Website Id</td><td>Page Id</td><td>Created On</td><td>ETL Impressions</td><td>ETL Clicks</td><td>ETL Spent</td><td>Kestrel Impressions</td><td>Kestrel Clicks</td><td>Kestrel Spent</td>
                                </tr>", ucfirst($metric));
            $format_row = "<tr>
                               <td>%s</td><td>%s</td><td>%s</td><td>%s</td><td>%s</td><td>%s</td><td>%s</td><td>%s</td><td>%s</td><td>%s</td><td>%s</td>
                           </tr>\n";
            foreach ($data_set AS $key => $data)
                if  ($key < 10)
                    $body .= vsprintf($format_row, $data);
                else{
                    $body = sprintf("<p class=\"content\">Printing first 10 diffs ... </p>%s</table>\n</div><p class=\"padd\"></p>\n", $body);
                    $more_than_ten = true;
                    break;
                }
            if (!$more_than_ten)
                $body = sprintf("<p class=\"content\">Printing all diffs ... </p>%s</table>\n</div><p class=\"padd\"></p>\n", $body);

            return $body;
        }

    }

    /*  Main Process */
    $audit_server = new DBManager();
    $warehouse_server = new DBManager();
    $tewn_server = new DBManager();
    $email = new EmailManager();
    $email_info = new EmailManager();

    $shortops = "e:h::";
    $longopts = array("environment:", "help::");
    $options = getopt($shortops, $longopts);

    if (!isset($options['e']) && !isset($options['environment']))
        die("You must specify environment to run this ETL\n");

    $environment = isset($options['e'])? $options['e']: $options['environment'];
    $subject_error = sprintf('%s:CI-ERROR [ETL CPC Landing Page]', strtoupper($environment));
    $email->set_subject($subject_error);

    try{
        $tewn_server->connect(ServerSettings::get_server_settings(strtoupper($environment), 'tewn'));
    }
    catch  (Exception $e){
        $msg = sprintf("<p>Could not open connection to audit cluster<br/>%s<br/></p>", $e->getMessage());
        $email->set_message(sprintf("<html><head><style>%s</style></head><body>%s</body></html>", $css, $msg));
        $email->send_email();
        die();
    }

    $should_run = $tewn_server->has_active_campaigns();
    $tewn_server->close_connection();

    if ($should_run) {
        try{
            $audit_server->connect(ServerSettings::get_server_settings(strtoupper($environment), 'audit'));
        }
        catch  (Exception $e){
            $msg = sprintf("<p>Could not open connection to audit cluster<br/>%s<br/></p>", $e->getMessage());
            $email->set_message(sprintf("<html><head><style>%s</style></head><body>%s</body></html>", $css, $msg));
            $email->send_email();
            die();
        }
    
        try{
            $warehouse_server->connect(ServerSettings::get_server_settings(strtoupper($environment), 'warehouse'));
        }
        catch  (Exception $e){
            $msg = sprintf("<p>Could not open connection to data warehouse<br/>%s<br/></p>", $e->getMessage());
            $email->set_message(sprintf("<html><head><style>%s</style></head><body>%s</body></html>", $css, $msg));
            $email->send_email();
            die();
        }
    
        /* Clean some memory */
        unset($options);
        $email_body = "";
        $subject_info = "";
    
        foreach (array("device", "country") as $metric){
            /* Lets export and load cpc*/
            $query = sprintf("CALL audit_ci_sp_select_cpc_stats('%s', '%s')", date('Y-m-d',strtotime("-1 days")), $metric);
            $insert_query = "CALL dw_ci_sp_insert_cpc_landing_page_stats('$metric', '%s', %u, %u, %u, %u, %u, %u, %f, %f)";
    
            try{
                $data = $audit_server->export_data($query);
            }
            catch  (Exception $e){
                $msg = sprintf("<p>%s ETL:<br/><br/>Could not export data from audit cluster<br/>%s<br/></p>", ucfirst($metric), $e->getMessage());
                $email->set_message(sprintf("<html><head><style>%s</style></head><body>%s</body></html>", $css, $msg));
                $email->send_email();
                $audit_server->close_connection();
                $warehouse_server->close_connection();
                die();
            }
    
            try{
                $result = 0;
                if ($data)
                    $result = $warehouse_server->load_data_with_rs($insert_query, $data);
    
                $email_body .= sprintf("<p>%s Rows exported from %s metric with %s differences</p>", count($data), ucfirst($metric), count($result));
    
                if ($result)
                    $email_body .= sprintf("%s", $email_info->get_html_table_body($result, $metric));
    
                if ((strpos($subject_info, "WARNING") === FALSE))
                    $subject_info = sprintf('%s:CI-%s [ETL CPC Landing Page]', strtoupper($environment), (($result)?"WARNING":"INFO"));
    
                unset($result);
            }
            catch  (Exception $e){
                $msg = sprintf("<p>%s ETL:<br/><br/>Could not load data into data warehouse<br/>%s<br/></p>", ucfirst($metric), $e->getMessage());
                $email->set_message(sprintf("<html><head><style>%s</style></head><body>%s</body></html>", $css, $msg));
                $email->send_email();
                $audit_server->close_connection();
                $warehouse_server->close_connection();
                die();
            }
    
            unset($data);
    
        }
    
        $email_info->set_message(sprintf("<html><head><style>%s</style></head><body>%s</body></html>", $css, $email_body));
        $email_info->set_subject($subject_info);
        $email_info->send_email();
        $audit_server->close_connection();
        $warehouse_server->close_connection();
    }
    
?>