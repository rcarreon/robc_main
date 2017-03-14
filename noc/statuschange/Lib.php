<?php

class RT {

//DEV
/*
function __construct() {
        $this->_user = "rt_svc_user";
        $this->_pass = "FN#27?Pq";
        $this->_server = "http://dev.rt.gorillanation.com";
        $this->_rest = "REST/1.0";
}
*/
//PRD                                                                                                                                                                       
                                                                                                                                                                            
function __construct() {                                                                                                                                                    
        $this->_user = "rt_svc_user";                                                                                                                                       
        $this->_pass = "FN#27?Pq";                                                                                                                                          
        $this->_server = "https://rt.gorillanation.com";                                                                                                                    
        $this->_rest = "REST/1.0";                                                                                                                                          
}                                                                                                                                                                           
                                                                                                                                                                            
public function search($query, $ticket) {                                                                                                                                   
        $str = "";
        $authvars="user=".urlencode($this->_user)
                . "&"
                . "pass=".urlencode($this->_pass);

        if (isset($ticket)) {
                $str = "ticket/".$ticket."/show?".$authvars;

        } else {
                $str = "search/ticket?".$authvars."&"."query=".urlencode($query);
                $uspssqry = $query;
        }
        $url = sprintf('%s/%s/%s',
                $this->_server,
                $this->_rest,
                $str);

//	echo $url;

        $cs = curl_init();
        curl_setopt($cs, CURLOPT_SSL_VERIFYPEER, false);
        curl_setopt($cs, CURLOPT_URL, $url);
        curl_setopt($cs, CURLOPT_RETURNTRANSFER, 1);
        curl_setopt($cs, CURLOPT_TIMEOUT, '4');
        $data = trim(curl_exec($cs));
        curl_close($cs);

        $lines = array_slice(explode("\n", $data), 1);

        return $lines;
}

public function FindId($ticket, $history) {
        $authvars="user=".urlencode($this->_user)
                . "&"
                . "pass=".urlencode($this->_pass);
        if (isset($history)) {
                $str = "ticket/".$ticket."/history?format=l&".$authvars;
        } else {
                $str = "ticket/".$ticket."/history?".$authvars;
        }
        $url = sprintf('%s/%s/%s',
                $this->_server,
                $this->_rest,
                $str);

	//echo "<br>".$url."<br>";

        $cs = curl_init();
        curl_setopt($cs, CURLOPT_SSL_VERIFYPEER, false);
        curl_setopt($cs, CURLOPT_URL, "$url");
        curl_setopt($cs, CURLOPT_RETURNTRANSFER, 1);
        curl_setopt($cs, CURLOPT_TIMEOUT, '10');
        $data = trim(curl_exec($cs));
        curl_close($cs);
	
        $lines = array_slice(explode("\n", $data), 1);
	
        if (isset($history)) {
                return $lines;

        } else {

        $history_id = "";

        foreach ($lines as $line) {

        //      $history_id = "";

                if (strpos($line,":")) { 
                        $id = explode(":", $line);
                        $history_id = $id[0];
                        break; 
                }
        }
        return $history_id;

        }

}

public function GetId($ticket,$id,$template) {
        $authvars="user=".urlencode($this->_user)
                . "&"
                . "pass=".urlencode($this->_pass);
        $str = "ticket/".$ticket."/history/id/".$id."?".$authvars;
        $url = sprintf('%s/%s/%s',
                $this->_server,
                $this->_rest,
                $str);

//      echo $url;
/*
$fp = fopen('txt.file','w'); 
fwrite($fp,$url); 
fclose($fp);
*/

        $cs = curl_init();
        curl_setopt($cs, CURLOPT_SSL_VERIFYPEER, false);
        curl_setopt($cs, CURLOPT_URL, $url);
        curl_setopt($cs, CURLOPT_RETURNTRANSFER, 1);
        curl_setopt($cs, CURLOPT_TIMEOUT, '4');
        $data = trim(curl_exec($cs));
        curl_close($cs);

        $lines = array_slice(explode("\n", $data), 1);

        if (isset($template)) {
                return $lines;
        } else {



        $fname = ""; $lname = ""; $date = "";

        foreach ($lines as $line) {
                if (strpos($line,"First Name:")) {
                        $data = explode(": ",$line);
                        $fname = $data[1];
                } elseif (strpos($line,"Last Name:")) {
                        $data = explode(": ",$line);
                        $lname = $data[1];
                } elseif (strpos($line,"Date:")) {
                        $data = explode(": ",$line);
                        $date = $data[1];
                }
        }
        return array($fname, $lname, $date);
        }
}
/*
public function update($tick, $response, $field) {

exec("./rt edit ticket/".$tick." set CF-'SC_".$field."'='".$response."'");

}
*/
public function sc_field($name) {
        $array1 = array(); $i = 0; //array for storing SC fields from "file"
        $array2 = array(); $j = 0; //array for storing user names from "file'
        $array = array(); //array for storing SC field names for respective user
        $file = fopen("file", "r");
        while(!feof($file)){ //read file called "file' where usernames are located and assigned to each SC field
                $line = fgets($file);
                        preg_match_all("^\[(.*)\]^",$line,$fields, PREG_PATTERN_ORDER); //grabs fields name inside square brackets
                        preg_match_all("#\((.*?)\)#", $line, $names, PREG_PATTERN_ORDER); //grabs usernames inside parenthesis
                        $array1[$i] = $fields[1][0]; $i++;
                        $array2[$j] = $names[1][0]; $j++;
        }
        fclose($file);

        $i=0; $j=0;
        foreach ($array2 as $arr) {
                $indname = explode(", ",$arr);
                foreach ($indname as $user) {
                        if (strcasecmp($name, $user) == 0) {
                                $array[$j] = $array1[$i]; $j++;
                        }
                }       
                $i++;
        }       
        return $array;
}
}

?>
