<?php

function queryInventory($format = "s", $hostname = "inventory.gnmedia.net", $username = "root", $password = "password"){
// set the actual request format. The result will be something like this:
// http://inventory.gnmedia.net/REST/1.0/search/asset?user=root&pass=password&query=Type+%3D+%22Site%22%0A++AND+Status+%21%3D+%22retired%22%0A++AND+Status+%3D+%22production%22%0A++AND+%22CF.%7BMonitorPriority%7D%22+%3D+%22High%22&format=s
  $resource = 'asset';
  // Query to get the assets
  $query = <<<EOF
Type = "Site"
  AND Status != "retired"
  AND Status = "production"
  AND "CF.{MonitorPriority}" = "High"
EOF;
  $request = sprintf('http://%s/REST/1.0/search/%s?', $hostname, $resource);
  $request.= http_build_query(array(
    'user' => $username,
    'pass' => $password,
    'query' => $query,
    'format' => $format,
  ));

  //echo $request."<br><br>"; //uncomment this line to see the actual query

  $ch = curl_init();
  curl_setopt($ch, CURLOPT_URL, $request);
  curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
  curl_setopt($ch, CURLOPT_TIMEOUT, '4');
  $content = trim(curl_exec($ch));
  curl_close($ch); 

  //remove the lines for the RT API Status
  $content = preg_replace('/^RT\/.+\n\n/m', '', $content);

//  echo $content;  // uncomment this to see the actual values
  
  // Depends of our type of query, parse, clean and work with the big string 
  // returned by RT and make it an array
  if ($format == "l")
    $content = parseFormatL($content);
  else
    $content = parseFormatS($content);

//  print_r($content);  // uncomment this line to see the actual array in non-formatted form
  return $content;
}

// queryInventory("l"); // this is an example on how to call the function

// Function to parse the format "s" that is just ID and Name returned by RT
function parseFormatS($content){
  $resources = array();
  $lines = explode("\n", $content);
  foreach ($lines as $line) {
    list($id, $name) = explode(': ', $line);
    if (isset($id)) {
      $resources[$id] = $name;
    }
    //echo $id." ".$resources[$id]."<br>";
  }
  //print_r($resources);
  return $resources;
}

// Function to parse the format "l" that is all the fields for an ID including 
// all the Custom Fields. This function will give you ONLY the ID, Name and CF.{NotificationGroups}
// in an array form
function parseFormatL($content){
  $fieldsRegex = <<<EOF
/^
(
  id|
  Name|
  CF\.{NotificationGroups}
)
:
\s
(.*)
$/x
EOF;
  $resources =  array();
  foreach (explode("\n\n--\n\n", $content) as $block) {
    $resource = array();
    foreach (explode("\n", $block) as $field) {
      $matches = array();

     $field =  preg_replace('/^id:\ asset\//', 'id: ', $field);

      if (preg_match($fieldsRegex, $field, $matches)) {

        if ($matches[1] == 'CF.{NotificationGroups}'){
          $resource[$matches[1]] = explode(',', $matches[2]);
        }
        else {
          $resource[$matches[1]] = $matches[2];
        }
      }
    }
    array_push($resources, $resource);
  }
//    print_r($resources);
    return $resources;
} 

?>
