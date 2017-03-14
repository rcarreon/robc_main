#! /bin/bash

curled=$(curl -ls vipvisual.gnmedia.net/extractServer?value=$1 | tail -1 | sed 's/<[^>]*>//g;s/ //g;s/com/com\n/g;s/net/net\n/g')

FILE=`cat curled`
until=`date '+%H:%M_%Y%m%d' | sed 's/:/%3A/g'`
from=`date --date='12 hours ago'  '+%H:%M_%Y%m%d' | sed 's/:/%3A/g'`
pref="http://graphite.gnmedia.net/render/?width=1003&height=495&_salt=1328377644.834&target"
size="width='600' height='300'></img></a>"
aconn="apache.apache80.apache_"
aload="load.load"
memva="memory.memory"
inter="interface.eth0.if_"
#rm -f /var/www/html/reports/me
#touch /var/www/html/reports/me
echo "<html><head><title>GraFito</title></head><body bgcolor='silver'>" >> /var/www/html/reports/me
echo "$curled" | \
while read line                                                                                                      
do                                                                                                                    
        if  [[ "$line" == *app* ]]                                                                                    
        then                                                                                                              
                newline=`echo $line | sed 's/[0-9]/*/g;s/[.]/_/g'`                                                        
                if [[ "$newline" != "$oldline" ]]                                                                         
                then                                                                                                      
                        oldline="$newline"                                                                                
                                                                                                                          
                        echo '<center>App Servers: '$oldline'</center>' >> /var/www/html/reports/me                                             
                                                                                                                          
                        echo '<br><b>System Load</b><br><a href="'$pref'='$oldline'.'$aload'.shortterm&from='$from'&until='$until'"><img src="'$pref'='$oldline'.'$aload'.shortterm&from='$from'&until='$until'" '$size' &nbsp <a href="'$pref'='$oldline'.'$aload'.midterm&from='$from'&until='$until'"><img src="'$pref'='$oldline'.'$aload'.midterm&from='$from'&until='$until'" '$size' &nbsp <a href="'$pref'='$oldline'.'$aload'.longterm&from='$from'&until='$until'"><img src="'$pref'='$oldline'.'$aload'.longterm&from='$from'&until='$until'" '$size' ' >> /var/www/html/reports/me                                                          
                                                                                                                          
                        echo '<br><b>Memory</b><br><a href="'$pref'='$oldline'.'$memva'.used.value&from='$from'&until='$until'"><img src="'$pref'='$oldline'.'$memva'.used.value&from='$from'&until='$until'" '$size' &nbsp <a href="'$pref'='$oldline'.'$memva'.cached.value&from='$from'&until='$until'"><img src="'$pref'='$oldline'.'$memva'.cached.value&from='$from'&until='$until'" '$size' &nbsp <a href="'$pref'='$oldline'.'memva'.free.value&from='$from'&until='$until'"><img src="'$pref'='$oldline'.'$memva'.free.value&from='$from'&until='$until'" '$size' ' >> /var/www/html/reports/me                                                
                                                                                                                          
                        echo '<br><b>Interface Octets</b><br><a href="'$pref'='$oldline'.'$inter'octets.tx&from='$from'&until='$until'"><img src="'$pref'='$oldline'.'$inter'octets.tx&from='$from'&until='$until'" '$size' &nbsp <a href="'$pref'='$oldline'.'$inter'octets.rx&from='$from'&until='$until'"><img src="'$pref'='$oldline'.'$inter'octets.rx&from='$from'&until='$until'" '$size'<br>' >> /var/www/html/reports/me                                                                                             
                                                                                                                          
                        echo '<br><b>Interface Errors</b><br><a href="'$pref'='$oldline'.'$inter'errors.tx&from='$from'&until='$until'"><img src="'$pref'='$oldline'.'$inter'errors.tx&from='$from'&until='$until'" '$size' &nbsp <a href="'$pref'='$oldline'.'$inter'errors.rx&from='$from'&until='$until'"><img src="'$pref'='$oldline'.'$inter'errors.rx&from='$from'&until='$until'" '$size'<br>' >> /var/www/html/reports/me                                                                                             
                                                                                                                          
                        echo  '<br><b>Apache</b><br><a href="'$pref'='$oldline'.'$aconn'connections.value&from='$from'&until='$until'"><img src="'$pref'='$oldline'.'$aconn'connections.value&from='$from'&until='$until'" '$size' &nbsp <a href="'$pref'='$oldline'.'$aconn'bytes.value&from='$from'&until='$until'"><img src="'$pref'='$oldline'.'$aconn'bytes.value&from='$from'&until='$until'" '$size' &nbsp <a href="'$pref'='$oldline'.'$aconn'requests.value&from='$from'&until='$until'"><img src="'$pref'='$oldline'.'$aconn'requests.value&from='$from'&until='$until'" '$size' <br>' >> /var/www/html/reports/me                            
                                                                                                                          
                                                                                                                          
                fi                                                                                                        
#               if [[ "$line" == *sql* ]]; then firefox http://toolshed.gnmedia.net/toolshed/sqlps/$line; sleep 0.5; fi   
        fi                                                                                                                
done                                                                                                                      

echo "</body></html>" >> /var/www/html/reports/me

cat /var/www/html/reports/me
cat /dev/null > /var/www/html/reports/me
