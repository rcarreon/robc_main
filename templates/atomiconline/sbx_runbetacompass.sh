#! /bin/bash 

cd /app/shared/wordpress_beta/current/tools/compass;

for i in `ls *.rb`; 
do compass compile -e development -c $i; 

done

