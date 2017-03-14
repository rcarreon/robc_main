#!/bin/bash
# Rey Estrada
# Evolve Media LLC
# NOC Team
# Jun 2015
# Business Utilization Report / Helper script

actualDir=`pwd`
nameDate=`date '+%d-%b-%Y'`
dirName="reportData-${nameDate}"
mkdir ${actualDir}/${dirName} > /dev/null 2>&1
dir="${actualDir}/${dirName}/"

read -d '' metals << EOL
metal-1.lax.gnmedia.net
metal-2.lax.gnmedia.net
metal-3.lax.gnmedia.net
metal-4.lax.gnmedia.net
metal-5.lax.gnmedia.net
metal-6.lax.gnmedia.net
metal-7.lax.gnmedia.net
metal-8.lax.gnmedia.net
metal-9.lax.gnmedia.net
metal-10.lax.gnmedia.net
metal-11.lax.gnmedia.net
metal-12.lax.gnmedia.net
metal-13.lax.gnmedia.net
metal-14.lax.gnmedia.net
metal-15.lax.gnmedia.net
metal-16.lax.gnmedia.net
metal-17.lax.gnmedia.net
metal-18.lax.gnmedia.net
metal-19.lax.gnmedia.net
metal-20.lax.gnmedia.net
metal-21.lax.gnmedia.net
metal-22.lax.gnmedia.net
metal-23.lax.gnmedia.net
metal-24.lax.gnmedia.net
metal-25.lax.gnmedia.net
metal-26.lax.gnmedia.net
metal-27.lax.gnmedia.net
metal-28.lax.gnmedia.net
metal-29.lax.gnmedia.net
metal-30.lax.gnmedia.net
metal-31.lax.gnmedia.net
metal-32.lax.gnmedia.net
metal-33.lax.gnmedia.net
metal-34.lax.gnmedia.net
metal-35.lax.gnmedia.net
EOL

# == Getting Metals Info ==
mmcommand="cat /proc/meminfo | grep MemTotal | awk -v ORS=\"\t\" '{print \$2}'; cat /proc/cpuinfo | grep processor | wc -l | awk -v ORS=\"\t\" '{print \$1}'; echo -ne \$(dmesg | grep -i duplex | grep 10000 | wc -l)"
while read -r metal
do
        mmdata=`ssh -o "StrictHostKeyChecking no" -o "LogLevel=quiet" $metal $mmcommand < /dev/null 2>&1`
        mmram=`echo "scale=2; $(echo $mmdata | awk '{print $1}') / 1024 / 1024 " | bc`
        mmcpu=`echo $mmdata | awk '{print $2}'`
        mmspeed=`echo $mmdata | awk '{print $3}'`
        if [ $mmspeed = 0 ]; then
          immspeed="(1G)"
        else
          immspeed="(10G)"
        fi
        echo -e "${metal}${immspeed}\t${mmram}\t${mmcpu}"
done <<< "$metals" | tee ${dir}metals.txt

# == Getting Verticals Info ==
#vmcommand=`echo "scale=2; $(cat /proc/meminfo | grep MemTotal | awk '{ print $2 }') / 1024 / 1024 " | bc`
vmcommand="cat /proc/meminfo | grep MemTotal | awk -v ORS=\"\t\" '{print \$2}'; cat /proc/cpuinfo | grep processor | wc -l"
while read -r metal
do
	#echo "Connecting to $metal - "
	metalvmline=`ssh -o "StrictHostKeyChecking no" "$metal" "sudo virsh list | tail -n +3 | head -n -1" < /dev/null`
	metalvmline=`echo "$metalvmline" | awk '{print $1" "$2}'`
	#echo "$metalvmline"
	
	while read -r vmline
	do
		vm=`echo "$vmline" | awk '{print $2}'`
		vertical=`echo "$vmline" | awk '{print $2}' | awk -F"." '{print $2}'`
		vmdata=`sudo ssh -o "StrictHostKeyChecking no" -o "LogLevel=quiet" $vm $vmcommand < /dev/null 2>&1`
		vmram=`echo "scale=2; $(echo $vmdata | awk '{print $1}') / 1024 / 1024 " | bc`
		vmcpu=`echo $vmdata | awk '{print $2}'`
		echo -e "$metal\t$vmline\t$vertical\t$vmram\t$vmcpu"
	done <<< "$metalvmline"
done <<< "$metals" | tee ${dir}reportOutput.txt
# metal | id | vm | vertical | ram | cores
#cat reportOutput.txt | sort -k4 | column -t
#verticals=`cat reportOutput.txt | awk '{print $4}' | sort | uniq | sort | grep -v ^$`


# Start Analisys


verticals=`cat ${dir}reportOutput.txt | awk '{print $4}' | sort | uniq | sort | grep -v ^$`

while read -r vertical
do
        while read -r line
        do
                lineVertical=`echo "$line" | awk '{print $4}'`
                if [[ "$vertical" == "$lineVertical" ]]; then
                        echo "$line"
                fi
        done < ${dir}reportOutput.txt > ${dir}${vertical}.txt
done <<< "$verticals"

echo "" > ${dir}reportTotals.txt

while read -r vertical
do
        fileVertical=`echo "${dir}${vertical}.txt"`
        echo -ne "${vertical} vms "
        cat $fileVertical | wc -l
        echo -ne "${vertical} ram "
        cat $fileVertical | awk '{ ram += $5 } END { print ram }'
        echo -ne "${vertical} cpus "
        cat $fileVertical | awk '{ cpus+= $6 } END { print cpus }'
        echo
done <<< "$verticals" | tee -a ${dir}reportTotals.txt

for NUM in `seq 1 1 1`
do
        fileMetals=`echo "${dir}metals.txt"`
        echo -ne "metals ms "
        cat $fileMetals | wc -l
        echo -ne "metals ram "
        cat $fileMetals | awk '{ ram += $2 } END { print ram }'
        echo -ne "metals cpus "
        cat $fileMetals | awk '{ cpus += $3 } END { print cpus }'
        echo
done | tee -a ${dir}reportTotals.txt



# == Beginning the actual report - MetalsUsageReport.txt ==
# |Metal|RAM|CPU| VMs|VMs RAM|VMs CPU|% RAM|% CPU|

 # == Titles ==
 printf "|%29s|%7s|%4s|%4s|%7s|%7s|%5s|%5s|\n" "Metal" "RAM" "CPU" "VMs" "VMs RAM" "VMs CPU" "% RAM" "% CPU" | tee ${dir}MetalsUsageReport.txt

while read line
do
  metal=`echo $line | awk -F'(' '{print $1}'`
  metalSpeed=`echo $line | awk '{print $1}'`
  tram=`echo $line | awk '{print $2}'`
  tcpu=`echo $line | awk '{print $3}'`
  vms=`cat ${dir}reportOutput.txt | grep $metal | wc -l`
  vmsram=`cat ${dir}reportOutput.txt | grep $metal | awk '{ ram += $5 } END { print ram }'`
  vmscpu=`cat ${dir}reportOutput.txt | grep $metal | awk '{ cpu += $6 } END { print cpu }'`
  pram=`echo "scale=0; $vmsram*100/$tram" | bc -l`
  pcpu=`echo "scale=0; $vmscpu*100/$tcpu" | bc -l`


#  echo -ne "$metal\t"
#  echo -ne "Total RAM: $tram\t"
#  echo -ne "Total CPUs: $tcpu\t"
#  echo -ne "VMs: $vms\t"
#  echo -ne "RAM used by VMs: $vmsram\t"
#  echo -ne "CPUs used by VMs: $vmscpu\t"
#  echo -ne "\n"

 printf "|%29s|%7s|%4s|%4s|%7s|%7s|%5s|%5s|\n" $metalSpeed $tram $tcpu $vms $vmsram $vmscpu $pram $pcpu;
# printf "\n|%20s|%7s|\n", $metal $tram;

done < ${dir}metals.txt | tee -a ${dir}MetalsUsageReport.txt 

# == send email ==
# cat ${dir}MetalsUsageReport.txt | mail -s "Metals Usage Report ${nameDate}" rey.estrada@evolvemediallc.com
cat ${dir}MetalsUsageReport.txt | mail -s "Metals Usage Report ${nameDate}" -a ${dir}MetalsUsageReport.txt noc@evolvemediallc.com


