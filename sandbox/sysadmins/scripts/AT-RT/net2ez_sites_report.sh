#!/bin/sh

assets_export=/tmp/.atrtexport.tmp
netflow_export=/tmp/.netflowexport.tmp

perl at_sites_export.pl > $assets_export
sh netflow_sites_export.sh > $netflow_export

assets=($(cat $assets_export))

for asset in ${assets[@]}
do
	grep \"$asset\" $netflow_export > /dev/null
		if [ $? == 0 ]
		then
			echo "$(grep \"$asset\" $netflow_export)"
		else
			echo "$asset,UNKNOWN"
		fi

done
