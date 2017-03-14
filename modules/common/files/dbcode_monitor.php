<?php
    class DBManager {
        protected $mysql;
        protected $driver;

        public function connect($server_settings){
            $this->mysql = mysqli_init();
            $this->mysql->options(MYSQLI_INIT_COMMAND, 'SET group_concat_max_len = 8388608;');
            $this->mysql->real_connect($server_settings['host'], $server_settings['user'], base64_decode($server_settings['password']), $server_settings['dbname']);

            if ($this->mysql->connect_errno)
                throw new Exception(sprintf("Failed to connect to MySQL: (%s) %s\n", $this->mysql->connect_errno, $this->mysql->connect_error));

            $this->driver = new mysqli_driver();
            $this->driver->report_mode = MYSQLI_REPORT_ERROR | MYSQLI_REPORT_STRICT;
        }


        public function execute($query){
            $data = array();

            if(!$this->mysql->connect_errno) {

                try {
                    $this->mysql->real_query($query);
                }
                catch (Exception $e) {
                    $msg = sprintf("Query Execution failed:\n\"%s\"\n(%s):%s\n%s\n",  $query, $this->mysql->connect_errno, $this->mysql->connect_error, $e->getMessage());
                    throw new Exception($msg);
                }

                if ($res = $this->mysql->use_result()) {
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

        public function get_slaves()
        {

            $data = array();
            $query = "SHOW SLAVE HOSTS";

            if(!$this->mysql->connect_errno) {

                try {
                    $this->mysql->real_query($query);
                }
                catch (Exception $e) {
                    $msg = sprintf("Query Execution failed:\n\"%s\"\n(%s):%s\n%s\n",  $query, $this->mysql->connect_errno, $this->mysql->connect_error, $e->getMessage());
                    throw new Exception($msg);
                }

                $res = $this->mysql->use_result();

                for ($tmp = array(), $i = 0; $tmp = $res->fetch_array(MYSQLI_ASSOC);$i++)
                    $data[] = $tmp["Host"];

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
        public function close_connection(){
            if (!$this->mysql->close())
                throw new Exception(sprintf("Failed to close connection to MySQL: (%s) %s\n", $this->mysql->connect_errno, $this->mysql->connect_error));
        }

    }

    class EmailManager {
        protected $to =  array('DBA<dba@evolvemediallc.com>');
        protected $subject = '';
        protected $message = '';
        protected $headers = array('From: MySQL Monitor<mysql@app1v-dbops.tp.prd.lax.gnmedia.net>',
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


    class Utilities {

        public static function getRecursiveSlaves($dbhost, $sql_access, $alreadySlaves = array()) {
            $slaves = array();
            $tempSlaves = $dbhost->get_slaves();
            foreach ($tempSlaves as $slave) {
                if (isset($alreadySlaves[$slave]))
                    continue;
                $slaves[$slave] = true;
                $tempSlave = new DBManager();
                $sql_access["host"] = $slave;
                $tempSlave->connect($sql_access);
                $slaveTempSlaves = self::getRecursiveSlaves($tempSlave, $sql_access, array_merge($slaves, $alreadySlaves));
                if (!empty($slaveTempSlaves) && is_array($slaveTempSlaves)) 
                    foreach ($slaveTempSlaves as $slaveTemp) 
                        $slaves[$slaveTemp] = true;
                $tempSlave->close_connection();
            }
            return array_keys($slaves);
        }

        public static function getStoreCallStatement($store_name, $log) {
            $statement_template = "CALL %s(%s);";
            $parameters = explode("|", $log["params"]);
            $param_result = array();
            foreach($parameters as $parameter) {
                $param_value = explode("=", $parameter);
                $param_result[] = sprintf("'%s'", trim($param_value[1]));
            }
            
            return sprintf($statement_template, $store_name, implode(",", $param_result));
        }

        public static function getErrorBody($error_log) {
            $error_template = "<li> 
                                   <pre><strong>%s</strong><br/>executed at %s, got mysql with errno: %s (%s)</pre>
                               </li>";
            $error_body = "";
            $logs = json_decode(str_replace("\n", "", $error_log["json_body"]), true);
            foreach ($logs as $log)
                $error_body .= sprintf($error_template, self::getStoreCallStatement($error_log["store_name"], $log), $log["executed_at"], $log["error_code"], $log["error_log"]);

            $error_body = sprintf("<ul class=\"code\">
                                      %s
                                   </ul><br/>",$error_body);
            return $error_body;
        }
    }

    Class MainProcess {

        public static function main($host, $minutes_interval = 15) {

            $db_server = new DBManager();
            $email = new EmailManager();
            $sql_access = array (
                                 'host' => $host,
                                 'dbname' => 'db_system',
                                 'user' => 'dbops',
                                 'password' => 'ZXZvbHZlZ2VuaXVzOTg3'
                                );    

            $hostname = explode(".", $sql_access['host']);
            $vertical = $hostname[1];
            $environment = $hostname[2];

            $subject = sprintf('%s:%s-ERROR [DB Code Error Monitor]', strtoupper($environment), strtoupper($vertical));
            $email->set_subject($subject);

            try{
                $db_server->connect($sql_access);
                $cluster_hosts = Utilities::getRecursiveSlaves($db_server, $sql_access);
                asort($cluster_hosts);
                if (empty($cluster_hosts))
                    $cluster_hosts[] = $host;
            }
            catch (Exception $e){
                $msg = sprintf("Could not open connection to %s host<br/>%s<br/>", $sql_access['host'], $e->getMessage());
                $email->set_message($msg);
                $email->send_email();
                $db_server->close_connection();
                die();
            }
            $db_server->close_connection();

            $error_log = array();
            foreach($cluster_hosts as $host) {

                $sql_access["host"] = $host;
                try{
                    $db_server->connect($sql_access);

                    $query = sprintf("SELECT store_name, DATE_SUB(CURRENT_TIMESTAMP, INTERVAL %s MINUTE) AS 'initial_date', CURRENT_TIMESTAMP AS 'end_date',
                                             CAST(CONCAT('[', GROUP_CONCAT(CONCAT('{\"params\":\"', store_params, '\", \"error_code\":\"', error_code, '\",\"executed_at\":\"', FROM_UNIXTIME(executed_at),'\", \"error_log\":\"',  error_log, '\"}') ORDER BY executed_at), ']') AS CHAR CHARACTER SET utf8) AS json_body  
                                      FROM db_system.sp_execution_log
                                      WHERE executed_at > UNIX_TIMESTAMP(DATE_SUB(CURRENT_TIMESTAMP, INTERVAL %s MINUTE)) AND error_code > 0 AND hostname = '%s'
                                      GROUP BY store_name", $minutes_interval, $minutes_interval, $host);
                    $error_log[$host] = $db_server->execute($query);
                }
                catch  (Exception $e){
                    $msg = sprintf("<span class=\"error\">Could not open connection to %s host<br/>%s<br/></span>", $sql_access['host'], $e->getMessage());
                    $email->set_message($msg);
                    $email->send_email();
                    $db_server->close_connection();
                    die();
                }
                $db_server->close_connection();
            }

            $email_body = "";
            $date_range = "";
            foreach ($error_log as $host => $logs) {
                $temp_body = "";
                foreach ($logs as $log) {
                    if (empty($date_range))
                        $date_range = sprintf("date range between %s and %s", $log["initial_date"], $log["end_date"]);
                    $body_result = Utilities::getErrorBody($log);
                    $temp_body = sprintf("%s",$body_result);
                }
                if (!empty($temp_body))
                    $email_body .= sprintf("<span class=\"server\">Host %s:</span> has logged some store procedure errors: %s", $host, $temp_body);
            }

            if (!empty($email_body)) {
                $email_body .= sprintf("<footer class=\"footer\">Data Source: db_sysytem.sp_execution_log table with %s</footer>", $date_range);
                $email->set_message(sprintf("<html>
                                                <head></head>
                                                <body style=\"font-size: 12px;\">
                                                    <style>
                                                        .code   {border-top:2px solid #DDD;}
                                                        .server {color: #084B8A; font-size: 14px; solid}
                                                        .footer {border-top:2px solid #DDD;  color: #444444; font-size: 11px; solid}
                                                    </style>
                                                %s
                                                </body>
                                            </html>", $email_body));
                $email->send_email();
            }
        }

    }