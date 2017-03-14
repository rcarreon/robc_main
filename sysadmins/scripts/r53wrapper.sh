#!/bin/bash
PUSHDIR="$1/dns/pub/"
TODAY=`date +"%y%m%d"`
WHORAN=`who -m | awk '{print $1;}'`

if [ -d "$PUSHDIR" ]; then
    if [[ $2 == "full" ]]; then
       for f in $(find $PUSHDIR -name \*.hosts);
        do
	    echo "[$(date)] Processing $f"
	    /usr/local/bin/r53sync -v $f
        done
    else
        for f in $(grep --include \*.hosts -linr $TODAY $PUSHDIR);
        do
	    echo "[$(date)] Processing $f"
	    /usr/local/bin/r53sync -v $f
        done

    fi
    

    echo "[$(date)] Deleting tmpdir $1"
    rm -fr $1
    echo "[$(date)] All done."
else
    echo "You must specify a zone directory."
fi
