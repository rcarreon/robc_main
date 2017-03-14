#!/bin/bash

# enumerate domU's via xm list
# find each domU's asset id
# find dom0's asset id
# link each domU with its dom0

export PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin

contact="puppetmasters@gorillanation.com"

function add_unusedram {

	domU=$(hostname)
	search_domU=$(rt list -t asset "Name = '$domU'")
	domU_id=$(echo $search_domU | awk -F ":" '{print $1}')

        if [[ $domU_id == 'No matching results.' ]]
        then
            echo "> ERROR: domU [$domU] was not found in AT" | mailx -s "scan_dom0: Asset [$domU] is Missing in AT" $contact
            return 1
        else
	USEDMEM=$(xm list | grep [0-9] |  awk '{sum=sum+$3} END {print sum}') 
	ALLMEM=$(ls -lG /proc/kcore | awk '{printf"%10.0f\n",$4/1048576}')
	UNUSED=$(echo "scale=0; $ALLMEM - $USEDMEM" | bc -l)				

		if [ $UNUSED -gt 100 ]
		then
		 rt edit asset/$domU set CF-XenFreeRam=$UNUSED
		 echo ">INFO: Added $domU CF-XenFreeRam=$UNUSED"
		 return 0
            	fi
        fi
    
}


function runs_on {
    if [ $# -eq 1 ]
    then
        domU=$1
        search_domU=$(rt list -t asset "Name  =  '$domU'")
        search_dom0=$(rt list -t asset "Name  =  '$HOSTNAME'")
        domU_id=$(echo $search_domU | awk -F ":" '{print $1}')
        dom0_id=$(echo $search_dom0 | awk -F ":" '{print $1}')

        if [[ $domU_id == 'No matching results.' ]]
        then
            echo "> ERROR: domU [$domU] running on dom0 [$HOSTNAME] was not found in AT" | mailx -s "scan_dom0: Asset [$domU] is Missing in AT" $contact
            return 1
        else
            update_asset $domU_id $dom0_id
        fi
    else
        echo "> ERROR: runs_on function needs one argument"
	    return 1
    fi
}

function update_asset {
    if [ $# -eq 2 ]
    then
        domU=$1
        dom0=$2

        if [ -f /var/tmp/$domU ]
        then
            echo ">INFO: Asset [$domU] has already been Updated in AT"
	        return 0
	else
            rt edit asset/$domU/links set RunsOn="at://gorillanation.com/asset/$dom0" > /var/tmp/$domU 2>&1
            #echo "> INFO: [rt edit asset/$domU/links set RunsOn=\"at://gorillanation.com/asset/$dom0\"]" | mailx -s "scan_dom0: Asset [$domU] was Updated in AT" $contact
	        return 0
	fi
    else
        echo "> ERROR: update_asset function needs two arguments"
	    return 1
    fi
}

hosts=$(xm list | awk '{print $1}' | tail -n +3 | sed s*_*.*g)

if [ $(id -u) -ne 0 ]
then
    echo "> ERROR: This script must be run as root"
    exit 1
fi

if [ -x /usr/local/bin/rt ]
then
    if [ -x /usr/sbin/xm ]
    then
	add_unusedram
        for i in $hosts
        do
            hostname=$i
            runs_on $hostname
        done
    else
        echo "> ERROR: This script needs the xm binary"
        exit 1
    fi
else
    echo "> ERROR: This script needs the rt binary"
    exit 1
fi
