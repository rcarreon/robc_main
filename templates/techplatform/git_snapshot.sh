#!/bin/bash 
exec &>> /mnt/nfs1_tp_lax_prd_git_backup/duplicity/git_backup.log

##### Create a lockfile to prevent updating files that already being uploaded
    lockfile -r 0 /mnt/nfs1_tp_lax_prd_git_backup/duplicity/git_bkp.lock || exit 1


##### Create a header for today's run in the logfile
    NOW=$(date +"%m-%d-%Y %r")
    echo "################################################################"
    echo "##### Starting Repo Cloning at $NOW " 
    echo "################################################################" 


##### Git clone all repos into archive
    # clear the destination
    echo "##### Clearing Archive Directory" 
        rm -rf /mnt/nfs1_tp_lax_prd_git_backup/archive/*
    echo "##### Archiving Repositories" 
        mv /mnt/nfs1_tp_lax_prd_git_backup/git/repositories/* /mnt/nfs1_tp_lax_prd_git_backup/archive/
    # Get list of repos and clone them
    echo "##### Cloning Repositories" 
        cd /mnt/nfs1_tp_lax_prd_git_backup/git/repositories/
        for i in /app/shared/git/repositories/* ; do
            if [ -d "$i" ]; then
            repo=$(basename "$i")
            sudo -u deploy git clone --mirror git@git.gnmedia.net:$repo /mnt/nfs1_tp_lax_prd_git_backup/git/repositories/$repo
        fi
    done

#### Remove the lockfile
    rm -f /mnt/nfs1_tp_lax_prd_git_backup/duplicity/git_bkp.lock


##### All Done!
    NOW=$(date +"%m-%d-%Y %r")
    echo "##### Repo Cloning finished at $NOW " 
