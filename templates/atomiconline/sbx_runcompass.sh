#! /bin/bash 

cd /app/shared/wordpress/current/tools/compass;

for i in `ls *.rb`; 
do compass compile -e development -c $i; 

done
