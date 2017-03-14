<?php
function grafito($site,$until,$option,$time,$source,$host_array){
  global $graphite_url, $salt, $mysql_link_r;
  $oldline = "";
  $app_flag=true;
  $ngx_flag=true;
  $eng_flag=true;
  $sql_flag=true;

  //SETTING VARS FROM, UNTIL, TIME, DPENDING ON CALLING THIS METHOD FROM MAIN PAGE OR VISUAL GRAFITO
  if($option=="reports"){
    //6HOURS
    $from = $until-28800;  //FROM 8 HOURS BEFORE ISSUE TIME
    $until = $until+7200;  //UNTIL 2 HOURS AFTER ISSUE TIME
    //$from=$until-43200;
  }
  if($option=="analyzer"){
    $until=date('U');
    $until=$until+3600;  //UNTIL 1HOUR AFTER ISSUE TIME
    $from=$until-$time;
  }
  /*
  //GET HOST LIST FROM LOCAL DATABASE
  if($source=="dtb"){
      //if ($mysql_link_r == -1)
       //die("Cannot connect to the database");
      $sql="Select id from rpt_sites where name like '".$site."';";
      //echo $sql;
      $con=database_query($sql,$mysql_link_r) or die(mysql_error());;
      $row=database_fetch_row($con);
      $id_website= $row[0];
      $sql="Select name from rpt_hosts where id in ( Select hosts_id from rpt_sitehost where sites_id ='".$id_website."');";
      //echo $sql."</br>";
      $con2=database_query($sql,$mysql_link_r) or die(mysql_error());
      $i=0;
      $host_array=null;
      while($row2 = database_fetch_array($con2)){
          $host_array[$i]=$row2[0];
          $i++;
        }
  }*/


  //echo "count: ".count($host_array)."</br>";
  if((count($host_array))>=1){
    for($i = 0; $i < count($host_array); $i++) {

      //echo "Run ".$i."</br>";      echo "host_array ".$host_array[$i]."</br>\n";
      $line = preg_replace("/\.(?! )/i", "_", $host_array[$i]);      //echo "line ".$line."</br>\n";
      $newline = preg_replace("/[0-9](?! )/i", "?", $line);   //echo "newline ".$newline."</br>\n";echo "for break ".$flag."</br>\n";
 
       //IF APPLICATION SERVER, "app"
        if(strstr($newline,'app')) {       //   echo "1er if break ".$flag."</br>\n";
          //echo "Run in APP ".$i."</br>";      echo "host_array ".$host_array[$i]."</br>\n";
          
          if($newline != $oldline&&$app_flag) {   //         echo "2do if break ".$flag."</br>\n";  

          $oldline=$newline;
          $stringtr=`echo $oldline | tr [?] [*]`;   //         echo "stringtr ".$stringtr."Armando query </br>\n";
          echo "<strong><center>APP SERVERS: $stringtr</center></strong>";
          
          $app_flag=false;
          $values=check($host_array,'app');
          //print_r($values);
          $bool_strip=$values['bool_strip'];
          $str1=$values['str1'];
          $str2=$values['str2'];

          if($bool_strip) {           //echo $bool_strip;
           $oldline2 = str_replace("??",$str2,$oldline);         //  echo $oldline2."</br>\n";
           $oldline = str_replace("??",$str1,$oldline);
           
           }          // echo $oldline."</br>\n";
                 
                graphite('System Load',$oldline,$from,$until,'load.load.','shortterm','midterm','longterm');
              if($bool_strip){
                graphite('System Load',$oldline2,$from,$until,'load.load.','shortterm','midterm','longterm');}
                graphite('Apache',$oldline,$from,$until,'apache.apache80.apache_','connections.value','bytes.value','requests.value');
              if($bool_strip){
                graphite('Apache',$oldline2,$from,$until,'apache.apache80.apache_','connections.value','bytes.value','requests.value');

                }
                graphite('Memory',$oldline,$from,$until,'memory.memory.','used.value','cached.value','free.value');     
              if($bool_strip){
                graphite('Memory',$oldline2,$from,$until,'memory.memory.','used.value','cached.value','free.value');

                }
                graphite('Interface Octets',$oldline,$from,$until,'interface.eth0.if_','octets.tx','octets.rx',null);
              if($bool_strip){
                graphite('Interface Octets',$oldline2,$from,$until,'interface.eth0.if_','octets.tx','octets.rx',null);

                }
                graphite('Interface Errors',$oldline,$from,$until,'interface.eth0.if_','errors.tx','errors.rx',null);
              if($bool_strip){
                graphite('Interface Errors',$oldline2,$from,$until,'interface.eth0.if_','errors.tx','errors.rx',null);
 
                }
      }

      }

       //IF APPLICATION SERVER, "ngx"
      if(strstr($newline,'ngx')) {       //   echo "1er if break ".$flag."</br>\n";
      //echo "Run in NGX".$i."</br>";      echo "host_array ".$host_array[$i]."</br>\n";

      //echo $newline." ".$oldline." ".$flag;
          if($newline != $oldline&&$ngx_flag) {   //         echo "2do if break ".$flag."</br>\n"; 
            $ngx_flag=false; 
            $oldline=$newline;
            $stringtr=`echo $oldline | tr [?] [*]`;   //         echo "stringtr ".$stringtr."Armando query </br>\n";
          echo "<strong><center>NGX SERVERS: $stringtr</center></strong>";

          $values=check($host_array,'ngx');
          //print_r($values);
          $bool_strip=$values['bool_strip'];
          $str1=$values['str1'];
          $str2=$values['str2'];

          if($bool_strip){           //echo $bool_strip;
           $oldline2 = str_replace("??",$str2,$oldline);         //  echo $oldline2."</br>\n";
           $oldline = str_replace("??",$str1,$oldline);          // echo $oldline."</br>\n";
          }

            graphite('System Load',$oldline,$from,$until,'load.load.','shortterm','midterm','longterm');
        if($bool_strip)          {
          graphite('System Load',$oldline2,$from,$until,'load.load.','shortterm','midterm','longterm');

        }
            graphite('Memory',$oldline,$from,$until,'memory.memory.','used.value','cached.value','free.value');     
        if($bool_strip)          {
          graphite('Memory',$oldline2,$from,$until,'memory.memory.','used.value','cached.value','free.value');

        }
            graphite('Interface Octets',$oldline,$from,$until,'interface.eth0.if_','octets.tx','octets.rx',null);
        if($bool_strip)          {
          graphite('Interface Octets',$oldline2,$from,$until,'interface.eth0.if_','octets.tx','octets.rx',null);

        }
            graphite('Interface Errors',$oldline,$from,$until,'interface.eth0.if_','errors.tx','errors.rx',null);
        if($bool_strip)          {
          graphite('Interface Errors',$oldline2,$from,$until,'interface.eth0.if_','errors.tx','errors.rx',null);

        }
        }

        }

        //IF APPLICATION SERVER, "eng"
        if((strstr($newline,'eng'))){
          //echo "Run in ENG ".$i."</br>";      echo "host_array ".$host_array[$i]."</br>\n";

          $eng_flag=false;
          $values=check($host_array,'eng');
          //print_r($values);
          $bool_strip=$values['bool_strip'];
          $str1=$values['str1'];
          $str2=$values['str2'];
          
                if ($newline != $oldline) {
                  $oldline=$newline;

                  $stringtr=`echo $oldline | tr [?] [*]`;
                  echo "</br><strong><center>ENG SERVERS: $stringtr</center></strong>";

                  graphite('System Load',$oldline,$from,$until,'load.load.','shortterm','midterm','longterm');
                  //graphite('Nginx',$oldline,$from,$until,'nginx.nginx_','connections.active.value','requests.value',null);
                  graphite('Memory',$oldline,$from,$until,'memory.memory.','used.value','cached.value','free.value');
                  graphite('Interface Octets',$oldline,$from,$until,'interface.eth0.if_','octets.tx','octets.rx',null);
                  graphite('Interface Errors',$oldline,$from,$until,'interface.eth0.if_','errors.tx','errors.rx',null);
                }
        }


        //IF PROXY SERVER, "pxy"
        if (strstr($newline,'pxy')) {
          //echo "Run in PXY ".$i."</br>";      echo "host_array ".$host_array[$i]."</br>\n";
                 if ($newline != $oldline) {
                        $oldline=$newline;

	                   $stringtr=`echo $oldline | tr [?] [*]`;
	                   echo "</br><strong><center>VARNISH SERVERS: $stringtr</center></strong>";
	                   graphite('Hits',$oldline,$from,$until,'varnish.default-','connections.connections.received.value','cache.cache_result.miss.value',null);
                }
        }

        //IF SQL SERVER, "sql"
        if (strstr($newline,'sql')) {
          //echo "Run in SQL ".$i."</br>";      echo "host_array ".$host_array[$i]."</br>\n";

          $sql_flag=false;
          $values=check($host_array,'sql');
          //print_r($values);
          $bool_strip=$values['bool_strip'];
          $str1=$values['str1'];
          $str2=$values['str2'];

          if ($newline != $oldline) {
            $oldline=$newline;
            $stringtr=`echo $oldline | tr [?] [*]`;
            echo "</br><strong><center>SQL SERVERS: $stringtr</center></strong>";
            graphite('System Load',$oldline,$from,$until,'load.load.','shortterm','midterm','longterm');
            graphite('SQL Commands',$oldline,$from,$until,'mysql.default.mysql_commands.','insert.value','select.value','update.value');
            graphite('SQL Threads',$oldline,$from,$until,'mysql.default.threads.','connected.value','running.value','cached.value');
            graphite('SQL Processes Ps State',$oldline,$from,$until,'processes.ps_state.','running.value','sleeping.value','zombies.value');
          }
        }

//Aqui lo borraria

    }
  }
  else{
    if($site!=null){
      //echo "</br><strong>WARNING:No records found for this site</br>";
      //echo "Please check documentation <A HREF=\"http://docs.gnmedia.net/wiki/NOC_Guide#Third_party_sites\"TARGET=\"_new\">Third party sites</A></strong>";
    }
  }
}
?>

