<html>
<head>
<title>Ganglia Graph</title>
<script src="http://code.jquery.com/jquery-1.9.1.js"></script>
  <script src="http://code.jquery.com/ui/1.10.3/jquery-ui.js"></script>
  <script>
  $(function() {
    $( "#start-date-datepicker" ).datepicker();
    $( "#end-date-datepicker" ).datepicker();
  });
  </script>
</head>
<body>

<?php
//function gangliaGraph($url, $from, $until){

//Definig variables
//Every variable with a capitalized "G" at the end means a variable 
//with format ready to use with ganglia (gweb) get method

include("include/functions.inc");
include("include/vars.inc");
include("include/config.inc");
include("include/mysql-connect.inc");

if (isset($_POST["site"]))
{
  $site = $_POST["site"];
  $qhost = $_POST["qhost"];
  $option = $_POST["option"];
  
  if ($option=="reports"&&(isset($_POST["until"])))
  {
    $from = $_POST["from"];
    $until = $_POST["until"];
    gangliaGraph($site, $qhost, $option, $from, $until);
  }
  else
  {
    $from =$_POST["range"]; 
    gangliaGraph($site, $qhost, $option, $from, NULL);    //$from = range
  }

  
//Site, no explanation requieres
//qhosts, quesrying hosts from "vpv", "dtb" or vtr"

}
else
{
  ?>
  <form method="POST" action="#">
  <input type="text" name="site">
  Vip Visual "vpv"
  <input type="radio" name="qhost" value="vpv" checked="true">
  Vip Trace "vtr"
  <input type="radio" name="qhost" value="vtr">
  Database "dtb"
  <input type="radio" name="qhost" value="dtb">
  <input type="submit" value="Submit">
  <input type="reset" value="reset">
  <br>
  Option:<br>
  Analizer
  <input type="radio" name="option" value="analyzer" checked="true">
  Range <select name="range">
    <option value="1hr">1 hr</option>
    <option value="2hr">2 hr</option>
    <option value="4hr" selected="selected">4 hr</option>
    <option value="day">Day</option>
    <option value="week">Week</option>
    <option value="month">Month</option>
    <option value="year">Year</option>
  </select><br>
  Reports
  <input type="radio" name="option" value="reports">
  Start Date: 
  <input type="text" id="start-date-datepicker" name="from">
  End Date: 
  <input type="text" id="end-date-datepicker" name="until">
  </form>
  <br><br><br><br><br><br><br><br><br>
  <a href="indexGanglia.php" target="_blank">NOC Reports Home using Ganglia</a><br>
  <a href="siteGanglia.php" target="_blank">NOC Reports VisualGrafito using Ganglia</a>
  <?php     
}







//grafito($site,null,"analyzer",$time,"vtr",

?>

<!--
<br><br><br><br><br>


One 
<img src=http://ao.gweb.gnmedia.net/graph.php?z=xlarge&mreg[]=^load_one$&hl=app1v-atp.ao.prd.lax.gnmedia.net|prdAtp,app2v-atp.ao.prd.lax.gnmedia.net|prdAtp,app3v-atp.ao.prd.lax.gnmedia.net|prdAtp&aggregate=1 width='600' height='300'></img>
<br>

Five 
<img src=http://ao.gweb.gnmedia.net/graph.php?mreg[]=^load_five$&hl=app1v-atp.ao.prd.lax.gnmedia.net|prdAtp,app2v-atp.ao.prd.lax.gnmedia.net|prdAtp,app3v-atp.ao.prd.lax.gnmedia.net|prdAtp&aggregate=1></img>
<br>

Fifteen 
<img src=http://ao.gweb.gnmedia.net/graph.php?mreg[]=^load_fifteen$&hl=app1v-atp.ao.prd.lax.gnmedia.net|prdAtp,app2v-atp.ao.prd.lax.gnmedia.net|prdAtp,app3v-atp.ao.prd.lax.gnmedia.net|prdAtp&aggregate=1></img>
<br>
-->


<?php
/* ***Here are some tips for the url needed for ganglia ***

graph.php & get_context.php

These are working forms:
http://ao.gweb.gnmedia.net/graph.php?mreg[]=^load_one$&hreg[]=app[1-3]v-atp.ao.prd.lax.gnmedia.net&aggregate=1


http://ao.gweb.gnmedia.net/graph.php?mreg[]=^load_one$&hl=app1v-atp.ao.prd.lax.gnmedia.net|prdAtp,app2v-atp.ao.prd.lax.gnmedia.net|prdAtp,app3v-atp.ao.prd.lax.gnmedia.net|prdAtp&aggregate=1





parameters:
#hostname h = hostname of the server
  #host-regex: hreg[] = 
#cluster: c = prdAtp, prdSqlAtp  //Atp could be taken from the hostname
title=title_of_the_graph
#size: z = xlarge, 
#range: r = 1hr, hour, 2hr, 4hr, day, week, month, year
#range-custom **
  #starting-time cs =  
  #ending-time ce =  
#metric-name: m = load_one, load_five, load_fifteen
#metric-title ti = Title of the graphic
#report-name g = load_report, cpu_report, mem_report, network_report, nfslatency_report, 
#host-list hl = host|cluster,host|cluster  ||| example 

s=sort
cr=controlroom
mc=metriccols
sh=showhosts
p=physical
t=tree
jr=jobrange
js=jobstart


####################################
####################################

site.php >> grafito (grafito.php) >> graphite (include/functions.inc)

site.php
grafito($site,NULL,"analyzer",$time,$source,$host_array);

grafito.php
function grafito($site,$until,$option,$time,$source,$host_array)

include/functions.inc
function graphite($title,$oldline,$from,$until,$spec1,$spec2,$spec3,$spec4)


report.php:  include("grafito.php");
report.php:      grafito($site,$down_lasttest,"reports",NULL,$source,$host_array);
site.php:  include("grafito.php");
site.php:    grafito($site,NULL,"analyzer",$time,$source,$host_array);


function gangliaGraph ($site, $qhost, $option, $from, $until)


####################################
####################################

GET CLUSTER FROM GANGLIA
http://ao.gweb.gnmedia.net/search.php?q=app1v-mal.ao.prd.lax.gnmedia.net



####################################
####################################













compare_hosts



*cs=custom_search_time_range_from  just guessing
*ce=custom_search_time_range_to  just guessing




***more or less the URL is in this format***

http://$vertical.gweb.gnmedia.net/?c=$cluster&&".$ENV{QUERY_STRING}."\">$cluster
http://$vertical.gweb.gnmedia.net/?c=$cluster&h=$host&".$ENV{QUERY_STRING}."\">$host
http://ao.gweb.gnmedia.net/?c=prdMal&h=app1v-mal.ao.prd.lax.gnmedia.net&


$vertical.gweb.gnmedia.net/graph.php?

VV=vertical


verticals
ao.gweb.gnmedia.net 
ap.gweb.gnmedia.net 
ci.gweb.gnmedia.net 
sbv.gweb.gnmedia.net 
si.gweb.gnmedia.net 
tp.gweb.gnmedia.net





examples
app host: app1v-jm.ao.prd.lax.gnmedia.net
sql host: sql1v-jm.ao.prd.lax.gnmedia.net




brainstrom:

1 hours
2 hours
4 hours
8 hours
12 hours
1 day
2 days
4 days
1 week
2 weeks
1 month
2 months
4 months
6 months
1 year





   ***   ***   ***   ***   ***   ***   ***   ***   ***   ***
===================================
===================================
 not really useful information




gweb.gnmedia.net

[15:34:05] <pacobernal> [15:11:56] <Ali Argyle> http://gweb.gnmedia.net/
[15:12:27] <Ali Argyle> http://gweb.gnmedia.net/index.cgi?h=app.*v-mal.ao.*
[15:12:46] <Ali Argyle> http://ao.gweb.gnmedia.net/?c=prdMal&h=app1v-mal.ao.prd.lax.gnmedia.net&
[15:13:58] <Ali Argyle> http://gweb.gnmedia.net/index.cgi?h=app1v-mal.ao.prd.lax.gnmedia.net&

===================================
===================================






custom&cs=11%2F3%2F2013+6%3A41&ce=11%2F3%2F2013+19%3A45&c=prdWp&h=app1v-wp.ao.prd.lax.gnmedia.net
http://ao.gweb.gnmedia.net/graph.php?r=custom&cs=11%2F3%2F2013+6%3A41&ce=11%2F3%2F2013+19%3A45&c=prdWp&h=app1v-wp.ao.prd.lax.gnmedia.net&m=load_one&s=by+name&mc=2&g=load_report&c=prdWp
http://ao.gweb.gnmedia.net/graph.php?r=custom&cs=11%2F3%2F2013+6%3A41&ce=11%2F3%2F2013+19%3A45&c=prdWp&h=reg%5B%5D=app%5B1-8%5Dv-wp.ao.prd.lax&m=load_one&s=by+name&mc=2&g=load_report&c=prdWp

http://ao.gweb.gnmedia.net/graph.php?title=interrupts&mreg[]=%5Einterrupts%24$&hreg[]=app[1-8]v-wp.ao.prd.lax&r=custom&cs=11%2F3%2F2013%206%3A41&ce=11%2F3%2F2013%2019%3A45&aggregate=1&hl=app1v-wp.ao.prd.lax.gnmedia.net|prdWp,app2v-wp.ao.prd.lax.gnmedia.net|prdWp,app3v-wp.ao.prd.lax.gnmedia.net|prdWp,app4v-wp.ao.prd.lax.gnmedia.net|prdWp,app5v-wp.ao.prd.lax.gnmedia.net|prdWp,app6v-wp.ao.prd.lax.gnmedia.net|prdWp,app7v-wp.ao.prd.lax.gnmedia.net|prdWp,app8v-wp.ao.prd.lax.gnmedia.net|prdWp

http://ao.gweb.gnmedia.net/graph_all_periods.php?title=load_one&mreg[]=%5Eload_one%24&hreg[]=app[1-8]v-wp.ao.prd.lax&aggregate=1&hl=app1v-wp.ao.prd.lax.gnmedia.net|prdWp,app2v-wp.ao.prd.lax.gnmedia.net|prdWp,app3v-wp.ao.prd.lax.gnmedia.net|prdWp,app4v-wp.ao.prd.lax.gnmedia.net|prdWp,app5v-wp.ao.prd.lax.gnmedia.net|prdWp,app6v-wp.ao.prd.lax.gnmedia.net|prdWp,app7v-wp.ao.prd.lax.gnmedia.net|prdWp,app8v-wp.ao.prd.lax.gnmedia.net|prdWp



regular expresion host like this example: app[1-8]v-wp.ao.prd.lax
but, in url the same is: app%5B1-8%5Dv-wp.ao.prd.lax

http://ao.gweb.gnmedia.net/?r=custom&cs=11%2F3%2F2013+6%3A41&ce=11%2F3%2F2013+19%3A45&c=prdWp&h=app1v-wp.ao.prd.lax.gnmedia.net&tab=m&vn=&mc=2&z=medium&metric_group=ALLGROUPS
http://ao.gweb.gnmedia.net/graph.php?r=hour&z=xlarge&h=app1v-wp.ao.prd.lax.gnmedia.net&m=load_one&s=by+name&mc=2&g=load_report&c=prdWp


http://ao.gweb.gnmedia.net/graph_all_periods.php?title=load_one&mreg[]=%5Eload_one%24&hreg[]=app[1-8]v-wp.ao.prd.lax&aggregate=1&h


just guessing here :)
http://ao.gweb.gnmedia.net/?r=custom&cs=11%2F3%2F2013+6%3A41&ce=11%2F3%2F2013+19%3A45&title=load_one&mreg[]=%5Eload_one%24&hreg[]=app[1-8]v-wp.ao.prd.lax&aggregate=1&h

http://ao.gweb.gnmedia.net/graph.php?r=hour&z=large&title=load_one&mreg[]=%5Eload_one%24&hreg[]=app%5B1-8%5Dv-wp.ao.prd.lax&aggregate=1&h=




here we have a graphic as we need it (or a kind of)  // this is for load
http://ao.gweb.gnmedia.net/graph.php?r=custom&cs=11%2F3%2F2013+6%3A41&ce=11%2F3%2F2013+19%3A45&title=load_one&mreg[]=%5Eload_one%24&hreg[]=app%5B1-8%5Dv-wp.ao.prd.lax&aggregate=1&h=




http://ao.gweb.gnmedia.net/graph.php?r=custom&cs=11%2F3%2F2013+6%3A41&ce=11%2F3%2F2013+19%3A45&title=load_one&mreg[]=%5Eload_one%24&hreg[]=app%5B1-8%5Dv-wp.ao.prd.lax&aggregate=1&h=



therefore:
?r=<<time+server>>
regex host ex.: app%5B1-8%5Dv-wp.ao.prd.lax



===================================
===================================



APP
load 1			load_one
load 5			load_five
load 15			load_fifteen
apache connections	
apache bytes		
apache requests		
memory used		
memory cached		mem_cached
memory free		mem_free
*swap free		swap_free
interface octects tx	bytes_out
interface octects rx	bytes_in
*interface errors tx	errs_out
*interface errors rx	errs_in

SQL
load 1			load_one
load 5			load_five
load 15			load_fifteen
sql commmands insert	
sql commands select	
sql command update	
sql threads connected	
sql threads running	
sql threads cached	

ADD VALUE time TO gangliaGraph function

   ***   ***   ***   ***   ***   ***   ***   ***   ***   *** */


?>
</body>
</html>





