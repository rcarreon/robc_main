#!/bin/bash 
THE_PATH="/home/rcarreon/sandbox/parallel"
echo -e "Gathering all the hosts from ansible list...\n"
        scp noc.gnmedia.net:/etc/ansible/vm_inventory  /home/rcarreon/sandbox/parallel/hosts_pre > /dev/null 2>&1
	echo -e "Striping up hosts_pre...\n"	
	## Getting all hosts
	`cat hosts_pre |sed '/^\[/d;/^$/d;/^peak/d'| sort -u  > all_hosts`
	#declare -A ALL_HOST=($HOST)
	#all prd host
	`cat hosts_pre |sed '/^\[/d;/^$/d;/^peak/d'| grep prd |sort -u  > all_prd_hosts`
	#all stg hosts
	`cat hosts_pre |sed '/^\[/d;/^$/d;/^peak/d'| grep stg |sort -u  > all_stg_hosts`
	#all dev hosts
	`cat hosts_pre |sed '/^\[/d;/^$/d;/^peak/d'| grep dev |sort -u  > all_stg_hosts`
	#all uids hosts 
	`cat hosts_pre |sed '/^\[/d;/^$/d;/^peak/d'| grep dev |grep -i uid|sort -u  > all_uid_hosts`
	## Getting  all verticals
	`cat hosts_pre |sed '/^\[/d;/^$/d;/^peak/d'| sed 's/\./\ /g'| awk '{print $2}'| sort -u> all_verticals`
	## get all BU 
	`cat hosts_pre |sed '/^\[/d;/^$/d;/^peak/d'| sed 's/\./\ /g'| grep -v uid| cut -d - -f 2|awk '{if ($1 != 56 && $1 != 55){print $1}}'| sort -u > all_bu`
	#declare -A ALL_BU=($BU)
#exit 1
if [[ $@ < 2 ]] ;then 
	echo -e "usage i.e paral_script.sh -v all -t app -e prd -b  tb date\n"
	echo -e "Verticals availables: all,af,ao,ap,ci,evolve,og,sbv,si,tp,\n"
	echo -e "Types of servers: all,app,els,eng,kes,mem,ngx,pxy,rds,spx,sql,uid,\n"
	echo -e "Environments: all,prd,stg,dev\n"
	echo -e "BUnits all,"
	exit 1
fi 
if [[ ! $2 ]];then 
	echo  -e "missing vertical"
	exit 1
fi
## all hosts ###
## If there  is only 2 args  mostly for all  option##
if [[ $2 ]];then 
	if [[ $2 == "all" ]];then 
		pssh -h /home/rcarreon/sandbox/parallel/all_hosts  -P ${@:3}
	fi
fi
### all ao hosts ### 
if [[ $4 ]];then 
	if [[ $2 == "ao" && $4 == "all" ]];then
		pssh -h $THE_PATH/${2}_${4}_hosts  -P ${@:5} | egrep -v 'FAIL|SUCCESS' | awk '{if ($0){print "\033[0;32m" $1 "\033[0m"}{$1="";print "\033[0;31m" $0 "\033[0m"}}'
	fi
### all ao app hosts ###
	if [[ $2 == "ao" && $4 == "app" ]];then 
		pssh -h /home/rcarreon/sandbox/parallel/${2}_${4}_hosts -P ${@:5} | egrep -v 'FAIL|SUCCESS' | awk '{if ($0){print "\033[0;32m" $1 "\033[0m"}{$1="";print "\033[0;31m" $0 "\033[0m"}}'
	fi 
fi
### all ao app prd hosts ###
if [[ $6 ]];then 
	if [[ $2 == "ao" && $4 == "app" && $6 == "prd"  ]];then
		pssh -h $THE_PATH/${2}_${4}_${6}_hosts  -P ${!#} | egrep -v 'FAIL|SUCCESS' | awk '{if ($0){print "\033[0;32m" $1 "\033[0m"}{$1="";print "\033[0;31m" $0 "\033[0m"}}'
	fi
fi 
### NOW AO BU ###

