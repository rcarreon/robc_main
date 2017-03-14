#!/bin/bash
# Rey Estrada
# Evolve Media LLC
# NOC Team
# Jun 2015
# Business Utilization Report / Helper script

# actualDir=`pwd` 
#actualDir=`pwd`
# Saving the report in this hardcoded folder
mkdir /root/metalsUsageReports > /dev/null 2>&1
actualDir="/root/metalsUsageReports"
nameDate=`date '+%d-%b-%Y'`
dirName="reportData-${nameDate}"
mkdir ${actualDir}/${dirName} > /dev/null 2>&1
dir="${actualDir}/${dirName}/"

# Metal => Peak ID relation
# This is the table you actually want to edit if you need to add or remove a metal machine
declare -A hypervisors=(
    [metal-1.lax.gnmedia.net]=PEAK1255
    [metal-2.lax.gnmedia.net]=PEAK1580
    [metal-3.lax.gnmedia.net]=PEAK1576
    [metal-4.lax.gnmedia.net]=PEAK1579
    [metal-5.lax.gnmedia.net]=PEAK1259
    [metal-6.lax.gnmedia.net]=PEAK1683
    [metal-7.lax.gnmedia.net]=PEAK1540
    [metal-8.lax.gnmedia.net]=PEAK1544
    [metal-9.lax.gnmedia.net]=PEAK1535
    [metal-10.lax.gnmedia.net]=PEAK0818
    [metal-11.lax.gnmedia.net]=PEAK0921
    [metal-12.lax.gnmedia.net]=PEAK1577
    [metal-13.lax.gnmedia.net]=PEAK1258
    [metal-14.lax.gnmedia.net]=PEAK1019
    [metal-15.lax.gnmedia.net]=PEAK1685
    [metal-16.lax.gnmedia.net]=PEAK1538
    [metal-17.lax.gnmedia.net]=PEAK1682
    [metal-18.lax.gnmedia.net]=PEAK1681
    [metal-19.lax.gnmedia.net]=PEAK0916
    [metal-20.lax.gnmedia.net]=PEAK1537
    [metal-21.lax.gnmedia.net]=PEAK0933
    [metal-22.lax.gnmedia.net]=PEAK0935
    [metal-23.lax.gnmedia.net]=PEAK1187
    [metal-24.lax.gnmedia.net]=PEAK1251
    [metal-25.lax.gnmedia.net]=PEAK1252
    [metal-26.lax.gnmedia.net]=PEAK1253
    [metal-27.lax.gnmedia.net]=PEAK1679
    [metal-28.lax.gnmedia.net]=PEAK0590
    [metal-29.lax.gnmedia.net]=PEAK0653
    [metal-30.lax.gnmedia.net]=PEAK0661
    [metal-31.lax.gnmedia.net]=PEAK0722
    [metal-32.lax.gnmedia.net]=PEAK0786
    [metal-33.lax.gnmedia.net]=PEAK0792
    [metal-34.lax.gnmedia.net]=PEAK0794
    [metal-35.lax.gnmedia.net]=PEAK0793
)

# Since bash's associative arrays don't the keep order of their keys, an ugly hack is in order
declare -a metals=($(echo ${!hypervisors[@]} | tr ' ' '\n' | sort -n -t'-' -k2))

# == Getting Metals Info ==
mmcommand="cat /proc/meminfo | grep MemTotal | awk -v ORS=\"\t\" '{print \$2}'; cat /proc/cpuinfo | grep processor | wc -l | awk -v ORS=\"\t\" '{print \$1}'; echo -ne \$(dmesg | grep -i duplex | grep 10000 | wc -l)"
for metal in ${metals[@]}
do
        mmdata=`ssh -o "StrictHostKeyChecking no" -o "LogLevel=quiet" -l reporter -i /root/reporter_id_rsa $metal $mmcommand < /dev/null 2>&1`
        mmram=`echo "scale=2; $(echo $mmdata | awk '{print $1}') / 1024 / 1024 " | bc`
        mmcpu=`echo $mmdata | awk '{print $2}'`
        mmspeed=`echo $mmdata | awk '{print $3}'`
        if [ $mmspeed = 0 ]; then
          immspeed="(1G)"
        else
          immspeed="(10G)"
        fi
        echo -e "${metal}${immspeed}\t${mmram}\t${mmcpu}\t${hypervisors[$metal]}"
done | tee ${dir}metals.txt

# == Getting Verticals Info ==
#vmcommand=`echo "scale=2; $(cat /proc/meminfo | grep MemTotal | awk '{ print $2 }') / 1024 / 1024 " | bc`
vmcommand="cat /proc/meminfo | grep MemTotal | awk -v ORS=\"\t\" '{print \$2}'; cat /proc/cpuinfo | grep processor | wc -l"
for metal in ${metals[@]}
do
	#echo "Connecting to $metal - "
	metalvmline=`ssh -o "StrictHostKeyChecking no" -l reporter -i /root/reporter_id_rsa "$metal" "sudo virsh list | tail -n +3 | head -n -1" < /dev/null`
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
done | tee ${dir}reportOutput.txt
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
 printf "|%29s|%9s|%7s|%4s|%4s|%7s|%7s|%5s|%5s|\n" "Metal" "Peak ID" "RAM" "CPU" "VMs" "VMs RAM" "VMs CPU" "% RAM" "% CPU" | tee ${dir}MetalsUsageReport.txt

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
  peakid=`echo $line | awk '{print $4}'`

#  echo -ne "$metal\t"
#  echo -ne "Total RAM: $tram\t"
#  echo -ne "Total CPUs: $tcpu\t"
#  echo -ne "VMs: $vms\t"
#  echo -ne "RAM used by VMs: $vmsram\t"
#  echo -ne "CPUs used by VMs: $vmscpu\t"
#  echo -ne "\n"

 printf "|%29s|%9s|%7s|%4s|%4s|%7s|%7s|%5s|%5s|\n" $metalSpeed $peakid $tram $tcpu $vms $vmsram $vmscpu $pram $pcpu;
# printf "\n|%20s|%7s|\n", $metal $tram;

done < ${dir}metals.txt | tee -a ${dir}MetalsUsageReport.txt 

# == send email ==
#{ cat  ${dir}MetalsUsageReport.txt ; echo -e "\n\n\n\n\t\t== Metal/VMs relationship ==\n" ; cat ${dir}reportOutput.txt ; } | mail -s "Metals Usage Report ${nameDate}" -a ${dir}MetalsUsageReport.txt -a ${dir}reportOutput.txt rey.estrada@evolvemediallc.com
{ cat  ${dir}MetalsUsageReport.txt ; echo -e "\n\n\n\n\t\t== Metal/VMs relationship ==\n" ; cat ${dir}reportOutput.txt ; } | mail -s "Metals Usage Report ${nameDate}" -a ${dir}MetalsUsageReport.txt -a ${dir}reportOutput.txt techops@evolvemediallc.com
#cat ${dir}MetalsUsageReport.txt | mail -s "Metals Usage Report ${nameDate}" -a ${dir}MetalsUsageReport.txt noc@evolvemediallc.com
