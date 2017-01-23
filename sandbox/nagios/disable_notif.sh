#!/bin/bash 
USER=rcarreon
PASS=rOBERTALEX1
#set -x
echo -e "Disable/Enable Services in Nagios Gnmedia\n"
echo -e "Want to disable or enable services ? d[isable]/e[nable]/s[service] specific one"
read dis
###Disabling notifications for all services in the hosts and the notification for the host itself ###
if [[ $dis == "d" ]]
then 
	echo -e "These are the servers that are going to be black out from nagios \n"
	for z in $(cat disable_host_og)
	do 
		echo "$z"
		echo -e "\n"
	done 
	printf  "Are you sure ? y/n \n"
	read sure 
		if [[ $sure == y ]]
		then 
			echo -e "Disbling services for hosts..\n"
			for x in $(cat disable_host_og) 
			do
				 curl --silent  --user $USER:$PASS  -k -d "cmd_mod=2&cmd_typ=29&host=$x&btnSubmit=Commit" "https://nagios.prd.gnmedia.net/nagios/cgi-bin//cmd.cgi";
				 out=$?
				 if [[ $out == 0 ]]
				 then 
					echo -e "Notifications for host $x were disable\n"
				 else 
					echo -e "could contact nagios\n"
				fi 
			done
			echo -e "Disabling hosts ...\n"
			for n in $(cat disable_host_og)
                        do
                                curl --silent --user $USER:$PASS  -k -d "cmd_mod=2&cmd_typ=25&host=$n&btnSubmit=Commit" "https://nagios.prd.gnmedia.net/nagios/cgi-bin//cmd.cgi";
                                out=$?
                                if [[ $out == 0 ]]
                                then
                                        echo -e "Notifications for host $n  were enable\n"
                                else
                                        echo -e "could contact nagios\n"
                                fi

                        done

		 
		elif [[ $sure == "n" ]]
		then 
			echo -e "Exiting\n"
			exit 1
		else 
			echo -e "Option not valid\n"
		fi 
fi
###Enabling notifications for all services in the hosts and the notification for the host itself ###
if [[ $dis == "e" ]]
then
        echo -e "These are the servers that are going to be enable in nagios \n"
        for z in $(cat disable_host_og)
        do
                echo  "$z"
		echo -e "\n"
        done
        printf  "Are you sure ? y/n \n"
        read sure2
                if [[ $sure2 == "y" ]]
                then
			echo -e "Enabling services...\n"
                        for w in $(cat disable_host_og)
                        do
                        	curl --silent --user $USER:$PASS  -k -d "cmd_mod=2&cmd_typ=28&host=$w&btnSubmit=Commit" "https://nagios.prd.gnmedia.net/nagios/cgi-bin//cmd.cgi";
				out=$?
                                if [[ $out == 0 ]]
                                then
                                        echo -e "Notifications for host $w were enable\n"
                                else
                                        echo -e "could contact nagios\n"
                                fi

                        done
			echo -e "Enabling hosts... \n"
			for f in $(cat disable_host_og)
                        do
                                curl --silent --user $USER:$PASS  -k -d "cmd_mod=2&cmd_typ=24&host=$f&btnSubmit=Commit" "https://nagios.prd.gnmedia.net/nagios/cgi-bin//cmd.cgi";
                                out=$?
                                if [[ $out == 0 ]]
                                then
                                        echo -e "Notifications for host $f were enable\n"
                                else
                                        echo -e "could contact nagios\n"
                                fi

                        done


                elif [[ $sure2 == "n" ]]
                then
                        echo -e "Exiting\n"
                        exit 1
                else
                        echo -e "Option not valid\n"
                fi
fi
###disabling a service only prod from provided file### 
if [[ $dis == "s" ]]
service=monit
then
        echo -e "These are the servers that are going to have the given service enable\n"
        for z in $(cat disable_service_hosts_og)
        do
                echo  "$z"
                echo -e "\n"
        done
        printf  "Are you sure ? y/n \n"
        read sure2
                if [[ $sure2 == "y" ]]
                then
                        echo -e "Enabling services...\n"
                        for w in $(cat disable_service_hosts_og)
                        do
				curl --user $USER:$PASS  -k -d "cmd_typ=22&cmd_mod=2&host=$w&service=$service&btnSubmit=Commit" "https://nagios.prd.gnmedia.net/nagios/cgi-bin//cmd.cgi";
                                out=$?
                                if [[ $out == 0 ]]
                                then
                                        echo -e "Service $service for host $w was enable\n"
                                else
                                        echo -e "could contact nagios\n"
                                fi

                        done


                elif [[ $sure2 == "n" ]]
                then
                        echo -e "Exiting\n"
                        exit 1
                else
                        echo -e "Option not valid\n"
                fi
fi
#
#curl --user rcarreon -k -d "cmd_typ=22&cmd_mod=2&host=app13v-vb.ao.prd.lax.gnmedia.net&service=monit&btnSubmit=Commit" "https://nagios.prd.gnmedia.net/nagios/cgi-bin//cmd.cgi";

