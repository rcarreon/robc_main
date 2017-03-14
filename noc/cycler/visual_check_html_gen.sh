#!/bin/sh
#
# Script that generates html file containing inventory list of sites from production with High monitor priority for the visual check
#

# Directory where the files with the list of sites will be created. E. Osorio
vis_check_dir=/var/lib/visual_check_html_gen

# ENV variable to set rtserver
export RTSERVER="http://inventory.gnmedia.net"

# Variable that will hold sites list
SITES=`/usr/local/bin/rt ls -s -t asset "Type = 'Site'  AND Status != 'retired'  AND Status = 'production'  AND 'CF.{MonitorPriority}' != 'Off'" | sed -e 's/.*://g'`


# Under this section we can hard code patterns to exclude sites from the visual check
# Patterns are separated by | and were double checked to see if no other site was excluded from the list
# ^ are to identify first word on line

EX="^analytics|^external|^trigger|origin.evolvemediacorp.com|assets|microsites.gorillanation|geo.g|^widget|^campaigns"

# Removes excluded sites from list
SITES=`echo $SITES | sed -e 's/ /\n/g' | grep -v -E $EX`


# Divides number of sites in two variables
ROWS=`echo $SITES | sed -e 's/ /\n/g' | grep -c .`
num1=$((ROWS/2))
num2=$((ROWS-num1))

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
HTML_MID=`echo "$SITES" | sed -e 's|^|urls.push("http://|g' -e 's|$|")|g'`
HTML_MID1=`echo "$SITES" | sed -e 's|^|urls.push("http://|g' -e 's|$|")|g' | sed -n '1, '$num2'p'`
HTML_MID2=`echo "$SITES" | sed -e 's|^|urls.push("http://|g' -e 's|$|")|g' | tail -$num1`

# Variable that holds the bottom html code
HTML_BOT="
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
if [ ! -d $vis_check_dir ]; then
  mkdir -p $vis_check_dir
fi

echo "$HTML_TOP" "$HTML_MID" "$HTML_BOT" > $vis_check_dir/sitemonTotal.html
echo "$HTML_TOP" "$HTML_MID1" "$HTML_BOT" > $vis_check_dir/sitemonPartA.html
echo "$HTML_TOP" "$HTML_MID2" "$HTML_BOT" > $vis_check_dir/sitemonPartB.html

