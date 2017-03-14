#!/bin/sh

# Directory where the files with the list of sites will be created.
vis_check_dir=/var/lib/visual_check_html_gen


# Under this section we can hard code any internal site we want to monitor
INT_SITES="netflow.gnmedia.net:8000/report.jsp?templid=0000&output=chart&unit=minute&nunits=60&device=72.172.76.1&recappl=80%2FTCP&reload=90
vipvisual.gnmedia.net
toolshed.gnmedia.net/toolshed
em.gnmedia.net
intranet
graphite.gnmedia.net
docs.gnmedia.net
caplog.gnmedia.net/prd.php
nagios.prd.gnmedia.net
rt.gorillanation.com 
inventory.gnmedia.net 
www.speedtest.net"

# Variable that holds the top html code
HTML_TOP="                                                       
 <html>                                                          
      <head>                                                     
      <script type=\"text/javascript\">                          
      var urls    = new Array();                                 
      var url=0                                                  
      var batch=1                                                
                                                                 
"

# Variable to hold the sites list plus come code around them     
HTML_MID=`echo "$INT_SITES" | sed -e 's|^|urls.push("http://|g' -e 's|$|")|g'`

# Variable that holds the bottom html code                       
HTML_BOT="                                                       
      var d = new Date();
      if (d.getDay() == 4) {
        urls.push('http://nocfiles.gnmedia.net/reminders/weekly_metrics_reminder.html');
      }
      if (d.getDate() == 1) {
        urls.push('http://nocfiles.gnmedia.net/reminders/monthly_metrics_reminder.html');
      }

      function nextpage() {                                      
                                                                 
         if(url>urls.length-1){
            document.getElementById(\"nextButton\").disabled=true;
         } 
         else{          
         for(i=0;i<3;i++){
            window.open(urls[url], '_blank');
            document.title='Cycler: '+batch
            url=url+1         
            }   
            batch=batch+1
         }                                          
      }                                                          
                                                                 
      </script>                                                  
      </head>                                                    
      <body>                                                     
      <form>                                                     
      <input id=\"nextButton\" type=\"button\" value=\"Next!\" onclick=\"javascript:nextpage()\" />
      </form>                                                    
      </body>                                                    
                                                                 
 </html>"

# Putting it all together 

#Checking if the directory exist
if [ ! -d $vis_check_dir ]; then
  mkdir -p $vis_check_dir
fi                                      
                         
echo "$HTML_TOP" "$HTML_MID" "$HTML_BOT" > $vis_check_dir/sitemonInternal.html
