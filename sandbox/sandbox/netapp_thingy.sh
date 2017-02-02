while read -r line 
do
   
    #echo "$name"
	echo "$line" >> netapp_results
	`/usr/bin/ssh admin@netapp1.gnmedia.net $line >> netapp_results`
done < $1
