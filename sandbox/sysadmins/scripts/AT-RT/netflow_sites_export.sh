#!/bin/bash

#curl -s "http://ops6.lax3.gnmedia.net:8000/report.jsp?id=0001&output=table&sample=1hour&stime=1263888000000&etime=1266480000000&outif=72.172.76.1%2F64&resolve=all&format=csv&start=1&nrecords=-1&order=2_Traffic"|grep % | sed s/\"//g|cut -d, -f1,3|egrep -v "<1%|Filtered Utilisation|Total Traffic"
curl -s "http://ops6.lax3.gnmedia.net:8000/report.jsp?id=0001&output=table&sample=1hour&stime=1263888000000&etime=1266480000000&outif=72.172.76.1%2F64&resolve=all&format=csv&start=1&nrecords=-1&order=2_Traffic"|grep % | tr -d www | sed s/\"//g|cut -d, -f1,3|egrep -v "Filtered Utilisation|Total Traffic"
