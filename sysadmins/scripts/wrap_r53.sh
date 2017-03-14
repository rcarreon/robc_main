#!/bin/bash
PUSHDIR="$1/dns/pub/"
TODAY=`date +"%y%m%d"`
if [ -d "$PUSHDIR" ]; then
    for f in $(grep --include \*.hosts -linr $TODAY $PUSHDIR);
    do
	echo "Processing $f"
#	name=${f%\.*}
	/usr/local/bin/push53.pl -v $f
    done

    if [[ $2 == "cleanup" ]]; then
        echo "Deleting $2"
        rm -fr $1
    fi

    echo "All done."
else
    echo "You must specify a zone directory."
fi
