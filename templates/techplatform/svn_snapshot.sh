#!/bin/bash

repoList=("/ops/repo/svn/" "/ops/repo/svnsites/" "/ops/repo/svn-archive/")
backupRoot="/mnt/nfs1_tp_lax_prd_svn_backup/"

# gwebevent is a quick hack to insert events into ganglia
gwebEventId=$(/usr/local/bin/gwebevent -g tp.gweb.gnmedia.net -a add -s "Starting svn hotcopy" -t now -p host_regex -f app1v-svn.tp.prd.lax.gnmedia.net)
lockfile -r 0 $backupRoot/duplicity/svn_bkp.lock || exit 1

echo "starting backup"
logger -t svn_backup "starting svn backups"

for repo in "${repoList[@]}"; do
        dstRepo=${backupRoot}repo/$(basename ${repo})
        # Test the dstRepo, if it doesn't exist, create it
        # hotcopy requires that the root exists before the copy begins. It will create the repo dir itself.
        test -d $dstRepo || mkdir $dstRepo
        output=$(find $repo -maxdepth 1 -type d ! -wholename "$repo")
        while read -r line; do
            # bar = /mnt/aarwine-test/svnbackups/{svn|svnsites|svn-archive}/{AtomicCMS|hfboards.com|sysadmins|...}
            bar="${dstRepo}/$(basename $line)"
            # If the backup destination exists, back it up.
            test -d ${bar} && mv ${bar} ${bar}.$$.bak
            if svnadmin hotcopy $line $bar; then
                # success, no need to keep that backup
                rm -rf ${bar}.$$.bak
            else
                # fail, lets restore the backup
                echo "$line failed to backup, restoring the last backup"
                logger -t svn_backup "$line failed to backup"
                rm -rf "${bar}"
                mv "${bar}.$$.bak" "${bar}"
            fi
        done <<< "$output"
done
/usr/local/bin/gwebevent -g tp.gweb.gnmedia.net -a edit -i $gwebEventId -e now > /dev/null
rm -f $backupRoot/duplicity/svn_bkp.lock
echo "complete"
logger -t svn_backup "svn backups complete"
