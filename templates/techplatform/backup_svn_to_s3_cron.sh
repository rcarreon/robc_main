#!/bin/bash

##### Create a lockfile to prevent concurrency
    lockfile -r 0 /mnt/nfs1_tp_lax_svn_ops_backup/duplicity/svn_bkp.lock || exit 1


##### If today is Sunday, rotate the log file
    [[ $(date '+%d') == "01" ]] && mv /mnt/nfs1_tp_lax_svn_ops_backup/duplicity/svn_backup.log /mnt/nfs1_tp_lax_svn_ops_backup/duplicity/svn_backup_2.log
    

##### Create a header for today's run in the logfile
    NOW=$(date +"%m-%d-%Y %r")
    echo "################################################################" >> /mnt/nfs1_tp_lax_svn_ops_backup/duplicity/svn_backup.log
    echo "##### Starting backup at $NOW " >> /mnt/nfs1_tp_lax_svn_ops_backup/duplicity/svn_backup.log 
    echo "################################################################" >> /mnt/nfs1_tp_lax_svn_ops_backup/duplicity/svn_backup.log


##### Set the credentials
    export AWS_ACCESS_KEY_ID="<%= tps3_aws_access_key_id %>"
    export AWS_SECRET_ACCESS_KEY="<%= tps3_aws_secret_access_key %>"
    export PASSPHRASE="<%= nsyncrootgpgkeyphrase %>"
    GPG_KEY="<%= nsyncrootgpgencryptkey %>"


##### Set the source of your backup
    SOURCE=/mnt/nfs1_tp_lax_svn_ops_backup/repo


##### Set the remote destination of your backup
    DEST=s3+http://Backup_gnmedia/svn.gnmedia.net


##### Run the backup
    duplicity \
        --archive-dir=/mnt/nfs1_tp_lax_svn_ops_backup/duplicity \
        --tempdir=/mnt/nfs1_tp_lax_svn_ops_backup/duplicity/temp \
        --name=svn \
        --volsize=4000 \
        --full-if-older-than=14D \
        --log-file=/mnt/nfs1_tp_lax_svn_ops_backup/duplicity/svn_backup.log \
        --encrypt-key=${GPG_KEY} \
        --sign-key=${GPG_KEY} \
            ${SOURCE} ${DEST}


##### Remove old backups
    NOW=$(date +"%m-%d-%Y %r")
    echo "##### Deleting old backups at $NOW " >> /mnt/nfs1_tp_lax_svn_ops_backup/duplicity/svn_backup.log 
    duplicity remove-all-but-n-full 2 \
        --archive-dir=/mnt/nfs1_tp_lax_svn_ops_backup/duplicity \
        --tempdir=/mnt/nfs1_tp_lax_svn_ops_backup/duplicity/temp \
        --name=svn \
        --force \
        --log-file=/mnt/nfs1_tp_lax_svn_ops_backup/duplicity/svn_backup.log \
            ${DEST}


##### Run the cleanup
    NOW=$(date +"%m-%d-%Y %r")
    echo "##### Starting cleanup at $NOW " >> /mnt/nfs1_tp_lax_svn_ops_backup/duplicity/svn_backup.log 
    duplicity cleanup \
        --archive-dir=/mnt/nfs1_tp_lax_svn_ops_backup/duplicity \
        --tempdir=/mnt/nfs1_tp_lax_svn_ops_backup/duplicity/temp \
        --name=svn \
        --extra-clean \
        --force \
        --log-file=/mnt/nfs1_tp_lax_svn_ops_backup/duplicity/svn_backup.log \
            ${DEST}


##### Verify the backup 
#    NOW=$(date +"%m-%d-%Y %r")
#    echo "##### Verifying backup at $NOW " >> /mnt/nfs1_tp_lax_svn_ops_backup/duplicity/svn_backup.log
#    duplicity verify \
#        --archive-dir=/mnt/nfs1_tp_lax_svn_ops_backup/duplicity \
#        --tempdir=/mnt/nfs1_tp_lax_svn_ops_backup/duplicity/temp \
#        --name=svn \
#        --log-file=/mnt/nfs1_tp_lax_svn_ops_backup/duplicity/svn_backup.log \
#        --encrypt-key=${GPG_KEY} \
#        --sign-key=${GPG_KEY} \
#            ${DEST} ${SOURCE}


##### Reset the ENV variables. Don't need them sitting around
    export AWS_ACCESS_KEY_ID=
    export AWS_SECRET_ACCESS_KEY=
    export PASSPHRASE=


##### Remove the lockfile
    rm -f /mnt/nfs1_tp_lax_svn_ops_backup/duplicity/svn_bkp.lock


##### All Done
    NOW=$(date +"%m-%d-%Y %r")
    echo "##### Backup finished at $NOW " >> /mnt/nfs1_tp_lax_svn_ops_backup/duplicity/svn_backup.log 
