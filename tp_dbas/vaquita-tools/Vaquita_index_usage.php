<?php

   class ParseQueries
   {
      protected $db;
      protected $total_rows = 0;
      protected $indexes = array();
      protected $setting = array();
      
      private function open_connection($host, $dbname)
      {
         try
         {
            $dsn = sprintf('mysql:host=%s;dbname=%s;', $host, $dbname);
            $this->db = new PDO($dsn, 'dba', 'gorillamaster789');
         }
         catch(PDOException $ex)
         {
            echo sprintf("Couldn't open db connection by %s: %s \n", $ex->getCode(), $ex->getMessage());
         }  
      }
   
      public function __construct($settings)
      {
         $this->setting = $settings;
         
         $this->open_connection($settings['host'], $settings['dbname']);
         
         if (!isset($this->db))
            die("Couldn't open connection with database server \n");
      }

      public function get_update_explain($query)
      {
         $regexp = "/^(update)(.+)(set)\s+(.+)\s*/i";
         $result = "";
         $matches = array();
         $matches2 = array();
         
         preg_match($regexp, $query, $matches);
         
         if(!empty($matches[2]))
         {
            if(strpos($matches[4], "where") > 0)
            {
               $regexp = "/(.*)where?(.*)/i";
               preg_match($regexp, $matches[4], $matches2);
               $result = sprintf("select %s from %s where %s ", trim($matches2[1]), trim($matches[2]), trim($matches2[2]));
            }
            else if(strpos($matches[4], "order by") !== false)
            {
               $regexp = "/(.*)order by?(.*)/i";
               preg_match($regexp, $matches[4], $matches2);
               $result = sprintf("select %s from %s order by %s ", trim($matches2[1]), trim($matches[2]), trim($matches2[2]));
            }
            else if(strpos($matches[4], "limit") !== false)
            {
               $regexp = "/(.*)limit?(.*)/i";
               preg_match($regexp, $matches[4], $matches2);
               $result = sprintf("select %s from %s limit %s ", trim($matches2[1]), trim($matches[2]), trim($matches2[2]));
            }
            else
               $result = sprintf("select %s from %s ", trim($matches[4]), trim($matches[2]));
         }
         
         return $result;
         
      }
      
      private function get_index_statistics($dbname, $tablename, $indexname)
      {
         $sql = sprintf("SELECT GROUP_CONCAT(CARDINALITY ORDER BY SEQ_IN_INDEX SEPARATOR ', ') AS Cardinality, 
                                GROUP_CONCAT(COLUMN_NAME ORDER BY SEQ_IN_INDEX SEPARATOR ', ') AS Columns  
                         FROM INFORMATION_SCHEMA.STATISTICS 
                         WHERE TABLE_NAME = '%s' AND TABLE_SCHEMA = '%s' AND
                               INDEX_NAME = '%s';", 
                        $tablename, $dbname, $indexname);
         $stmt2 = $this->db->prepare($sql);
         $result = array("Usage" => 0, "Cardinality" => "", "Columns" => "");
         try
         {
            if ($stmt2->execute())
               while ($row = $stmt2->fetch(PDO::FETCH_ASSOC))
                  $result = array("Usage" => 0,
                                  "Cardinality" => $row["Cardinality"],
                                  "Columns" => $row["Columns"]);
            else
               echo sprintf("Statement %s\n\terror code %s => %s \n", $sql, $stmt2->errorCode(), implode(' ', $stmt2->errorInfo()));
            $stmt2->closeCursor();
         }
         catch(PDOException $ex)
         {
            echo sprintf("Couldn't read index statistics from table %s\n\t%s: %s\n", $tablename, $ex->getCode(), $ex->getMessage());
         }  

         $sql = sprintf("SELECT TABLE_ROWS FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = '%s' AND TABLE_SCHEMA = '%s'",
                        $tablename, $dbname);
         $stmt2 = $this->db->prepare($sql);
         $stmt2->execute();
         $row = $stmt2->fetch(PDO::FETCH_ASSOC);
         $this->total_rows = $row["TABLE_ROWS"];
         $stmt2->closeCursor();
         
         return $result;
      }
      
      public function get_indexes_from_table()
      {
         $sql = sprintf("SELECT INDEX_NAME
                         FROM INFORMATION_SCHEMA.STATISTICS 
                         WHERE TABLE_NAME = '%s' AND TABLE_SCHEMA = '%s'
                         GROUP BY INDEX_NAME", 
                         $this->setting['tablename'], $this->setting['dbname']);
         $stmt = $this->db->prepare($sql);
         $result_set = array("FullScan" => array("Usage" => 0, "Cardinality" => 0, "Columns" => ""));
         try
         {
            if ($stmt->execute())
               while ($row = $stmt->fetch(PDO::FETCH_ASSOC))
               {
                  $usage = $this->get_index_statistics($this->setting['dbname'], 
                                                       $this->setting['tablename'], 
                                                       $row['INDEX_NAME']);
                  $result_set = array_merge($result_set, 
                                            array($row['INDEX_NAME'] => $usage));
               }
            else
               echo sprintf("Statement %s\n\terror code %s => %s \n", $sql, $stmt->errorCode(), implode(' ', $stmt->errorInfo()));
            $stmt->closeCursor();
         }
         catch(PDOException $ex)
         {
            echo sprintf("Couldn't read indexes from table %s\n\t%s: %s\n", $table_name, $ex->getCode(), $ex->getMessage());
         }  
         $this->indexes = $result_set;
         
         return true;
      }
      
      public function parse_file()
      {
         $files = explode(",", $this->setting['filename']);
         $result_set = array();
         
         foreach($files as $file)
         {
            echo sprintf("\t\tParsing file %s ... \n", $file);
            $shell_command = sprintf("grep -v '#' %s | grep -iv 'show create table'", $file);
            $data = explode('\G', shell_exec($shell_command));
            echo sprintf("\t\t\t%0d queries extracted from file %s \n", count($data), $file);
            
            foreach ($data as $row)
               if (strpos($row, 'EXPLAIN') == false && 
                   strpos($row, 'checksums') === false && 
                   strpos($row, 'chunk boundary') === false)
                  $result_set[] = trim(str_replace('`', '', $row));
         }
         
         return preg_grep("/^(select)/i", $result_set);
      }
   
      private function get_table_alias($data, $tablename)
      {
         $matches = array();
         $regexp = sprintf('~(from|join)\s(%s)\s(as)?\s*([a-z]+)\s~', $tablename);
         $result = array();
         $result[] = $tablename;
         foreach($data as $query)
         {
            $query = strtolower($query);
            preg_match($regexp, $query, $matches);
            if (count($matches))
               if (trim($matches[(count($matches) -1 )]) !== "where")
               {
                  $alias = trim($matches[(count($matches) -1 )]);
                  if (array_search($alias, $result) === false && isset($alias))
                     $result[] = $alias;
               }
         }
         return $result;
      }
      
      private function check_disk_usage($row)
      {
         $result = array("Temporary" => false, "Filesort" => false);
         
         if (!empty($row["Extra"]))
         {
            if (strpos($row["Extra"], "temporary") !== false)
               $result["Temporary"] = true;
            
            if (strpos($row["Extra"], "filesort") !== false)
               $result["Filesort"] = true;
         }
         return $result;
      }

      private function check_join_buffer($row)
      {
         $result = array("BufferJoin" => false);
         
         if (!empty($row["Extra"]) && strpos($row["Extra"], "Using join buffer") !== false)
            $result["BufferJoin"] = true;

         return $result;
      }
      
      private function compare_column($array1, $array2)
      {
         
         if ($array1["Usage"] == $array2["Usage"])
            return 0;
         
         return ($array1["Usage"] < $array2["Usage"]) ? -1 : 1;
      }

      private function get_remove_indexes_sql()
      {
         $result = array();
         
         foreach($this->indexes as $index => $stats)
         {
            if($stats["Usage"] === 0 && $index !== "FullScan")
               $result[] = sprintf("   DROP INDEX %s", $index);
         }
         $return_value = "";
         
         if (!empty($result))
            $return_value = sprintf("ALTER TABLE %s.%s \n%s;", $this->setting["dbname"], 
                                    $this->setting["tablename"], implode(",\n", $result));
         return $return_value;
      }
      
      
      public function check_indexes($data)
      {
         $tablename = $this->setting["tablename"];
         $output_file = "";
         $filename = '';

         if (isset($this->setting["index"])) 
            $filename = sprintf("%s_%s_index_usage.sql", $tablename, $this->setting["index"]);
         else
            $filename = sprintf("%s_index_usage.sql", $tablename);

         if (isset($this->setting["output"]))
            $output_file = sprintf("%s/%s", $this->setting["output"], $filename);
         else
            $output_file = $filename;
         
         if (file_exists($output_file))
            unlink($output_file);
            
         $tablename = strtolower($tablename);
         $table_alias = $this->get_table_alias($data, $tablename);
         
         $handler = fopen($output_file, "w");
         $buffer_line = sprintf("Query summary for %s table \n\n", $tablename);
         fwrite($handler, $buffer_line);
         $result = array();
         $query_no = 1;
         $queries = count($data);
         $counter = 0;
         foreach($data as $query)
         {
            $query = strtolower($query);
            $sql = sprintf("EXPLAIN %s \n", $query);
            $stmt = $this->db->prepare($sql);
            $counter++;
            echo sprintf("\t\tProcessing query %0d of %0d ... \n", $counter, $queries);
            
            if ($stmt->execute())
            {
               while ($row = $stmt->fetch(PDO::FETCH_ASSOC))
               {
                  if (array_search(strtolower($row['table']), $table_alias) !== false)
                  {
                     $diskUsage = $this->check_disk_usage($row);
                     $joinbufferUsage = $this->check_join_buffer($row);
                     
                     $result_set = array("query_no" => $query_no,
                                         "query" => $query,
                                         "index_used" => $row['key'],
                                         "rows" => $row['rows']);
                     $query_no++;
                     if (isset($row['key']))
                     {

                        $keys = explode(",", $row['key']);
                              
                        foreach($keys as $key)
                           if (isset($this->indexes[$key]))
                              $this->indexes[$key]["Usage"] += 1;
                     }
                     else
                        $this->indexes["FullScan"]["Usage"] += 1;
                     
                     $buffer_line = sprintf("\n\n# Query # %0d: \n# EXPLAIN PARTITIONS \n%s;\n\n# Index used => %s ( %s rows / %s%% used) \n", 
                                             $result_set['query_no'], $result_set['query'], 
                                             empty($result_set['index_used'])? "Full Table Scan" : $result_set['index_used'], 
                                             number_format($result_set['rows'], 0), number_format(($result_set['rows'] / $this->total_rows) * 100, 2));
                                  
                     if (isset($this->setting["index"]))
                        if ($this->setting["index"] == $result_set['index_used'])
                        {
                           fwrite($handler, $buffer_line);
                           if ($diskUsage["Temporary"] || $diskUsage["Filesort"])
                           {
                              $buffer_line = sprintf("\n# WARNING!!!! This query has activity disk and potencialy is giving more cpu activity\n");
                              fwrite($handler, $buffer_line);
                           }
                        }
                        else
                           continue;
                     elseif (isset($this->setting["exclude"]))
                        if ($this->setting["exclude"] == $result_set['index_used'])
                           continue;
                        else
                        {
                           fwrite($handler, $buffer_line);
                           if ($diskUsage["Temporary"] || $diskUsage["Filesort"])
                           {
                              $buffer_line = sprintf("\n# WARNING!!!! This query has activity disk and potencialy is giving more cpu activity\n");
                              fwrite($handler, $buffer_line);
                           }
                        }
                     elseif (isset($this->setting["join_buffer"]))
                        if ($joinbufferUsage["BufferJoin"])
                        {
                           fwrite($handler, $buffer_line);
                           if ($diskUsage["Temporary"] || $diskUsage["Filesort"])
                           {
                              $buffer_line = sprintf("\n# WARNING!!!! This query has activity disk and potencialy is giving more cpu activity\n");
                              fwrite($handler, $buffer_line);
                           }
                        }
                        else 
                           continue;
                     else
                     {
                        fwrite($handler, $buffer_line);
                        if ($diskUsage["Temporary"] || $diskUsage["Filesort"])
                        {
                           $buffer_line = sprintf("\n# WARNING!!!! This query has activity disk and potencialy is giving more cpu activity\n");
                           fwrite($handler, $buffer_line);
                        }
                     }                  
                  }
               }
            }
            $stmt->closeCursor();
         }
         $line_length = 230;
         $buffer_line = sprintf("\n\n\n\n#  %s\n", str_repeat("-", $line_length));
         fwrite($handler, $buffer_line);
         $buffer_line = sprintf("# |%s Index %s|%s Usage %s|%s Cardinality %s|%s Columns %s|\n", str_repeat(" ",25), str_repeat(" ",25),
                                str_repeat(" ",8), str_repeat(" ",8), str_repeat(" ",25), str_repeat(" ",25), str_repeat(" ",37),
                                str_repeat(" ",37));
         fwrite($handler, $buffer_line);
         $buffer_line = sprintf("#  %s\n", str_repeat("-", $line_length));
         fwrite($handler, $buffer_line);
         
//         usort($this->indexes, array($this, "compare_column"));
         
         foreach($this->indexes as $index => $stats)
         {
            $buffer_line = sprintf("# | %s %s|%s %s |%s %s | %s %s|\n", $index, str_repeat(" ", (55 - strlen($index))),
                                   str_repeat(" ", (21 - strlen($stats["Usage"]))), $stats["Usage"], 
                                   str_repeat(" ", (61 - strlen($stats["Cardinality"]))), $stats["Cardinality"],
                                   $stats["Columns"], str_repeat(" ", (81 - strlen($stats["Columns"]))));
            fwrite($handler, $buffer_line);
         }
         $buffer_line = sprintf("#  %s\n\n", str_repeat("-", $line_length));
         fwrite($handler, $buffer_line);
         $buffer_line = $this->get_remove_indexes_sql();
         fwrite($handler, $buffer_line);
         fclose($handler);
      }
   }
   
   class OptionsManager
   {
      protected $shortOpts  = "h:d:t:f:?::o:i:e:j::";
      protected $longOpts = array("host:", "dbname:", "tablename:", "filename:", "help::", "output:", "index:", "exclude:", "join_buffer::");

      private function print_Usage()
      {
         $usageLine = "
   Welcome to Vaquita Index Usage, this tool provides you an idea how each query runs on your schema,
   and provides which index is used by each query and a summary for all the indexes.
   
   This script requires an output file from pt-query-digest which extract all the queries used on specific table.
   
   -h, --host        Database Host to run explain queries
   -d, --dbname      Database Name which contains table to evaluate
   -t, --tablename   Table Name to check index usage
   -f, --filename    File name which contains pt-query-digest result, should include full path
   -o, --output      Path for output file
   -i, --index       Specific Index to get evaluate
   -e, --exclude     Index Name you want to exclude be written in the output file
   -j, --join_buffer This flag, would get only the queries using join buffer instead of index
   -?, --help        Show this screen

   Output: returns a file named <tablename>_index_usage.sql located in the same path from this script
   
         ";
         
         echo sprintf("\n%s\n", $usageLine);
      }
      
      private function validate_options($options)
      {
         $result = array();

         foreach($options as $key => $option)
         {

            switch($key)
            {
               case "f":
               case "filename":
                  if (gettype($option) == "string")
                     $result = array_merge($result, array("filename" => $option));
                  break;
               case "h":
               case "host":
                  if (gettype($option) == "string")
                     $result = array_merge($result, array("host" => $option));
                  break;
               case "d":
               case "dbname":
                  if (gettype($option) == "string")
                     $result = array_merge($result, array("dbname" => $option));
                  break;
               case "t":
               case "tablename":
                  if (gettype($option) == "string")
                     $result = array_merge($result, array("tablename" => $option));
                  break;
               case "o":
               case "output":
                  if (gettype($option) == "string")
                     $result = array_merge($result, array("output" => $option));
                  break;
               case "i":
               case "index":
                  if (gettype($option) == "string")
                     $result = array_merge($result, array("index" => $option));
                  break;
               case "e":
               case "exclude":
                  if (gettype($option) == "string")
                     $result = array_merge($result, array("exclude" => $option));
                  break;
               case "j":
               case "join_buffer":
                  $result = array_merge($result, array("join_buffer" => true));
                  break;
               case "?":
               case "help":
                  $this->print_Usage();
                  die();
            }
         }

         return $result;
         
      }
      
      public function get_options()
      {
         $options = getopt($this->shortOpts, $this->longOpts);
         
         $result = $this->validate_options($options);
         
         if (!isset($result["host"]) || !isset($result["tablename"]) ||
             !isset($result["dbname"]) || !isset($result["filename"])) 
         {
            $this->print_Usage();
            var_dump($options);
            die();
         }
         
         return $result;
      }
      

      
   }
   
   $options = new OptionsManager();
   $setting = $options->get_options();
   echo sprintf("Initializing class to parse queries... \n");
   $parse = new ParseQueries($setting);
   echo sprintf("\tGetting indexes from table %s... \n", $setting["tablename"]);
   $parse->get_indexes_from_table();
   echo sprintf("\tInitializing process to check each index... \n");
   $parse->check_indexes($parse->parse_file());

?>
