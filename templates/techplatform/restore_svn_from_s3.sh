#!/bin/bash

##### Create a lockfile to prevent concurrency
    lockfile -r 0 /mnt/nfs1_tp_lax_svn_ops_backup/duplicity/svn_bkp.lock || exit 1


##### Set the credentials
    export AWS_ACCESS_KEY_ID="<%= tps3_aws_access_key_id %>"
    export AWS_SECRET_ACCESS_KEY="<%= tps3_aws_secret_access_key %>"
    export PASSPHRASE="<%= nsyncrootgpgkeyphrase %>"
    GPG_KEY="<%= nsyncrootgpgencryptkey %>"


##### Set the source of your backup
    SOURCE=/mnt/nfs1_tp_lax_svn_ops_backup/restore


##### Set the remote destination of your backup
    DEST=s3+http://Backup_gnmedia/svn.gnmedia.net


##### Run the backup
    duplicity restore \
        --archive-dir=/mnt/nfs1_tp_lax_svn_ops_backup/duplicity \
        --tempdir=/mnt/nfs1_tp_lax_svn_ops_backup/duplicity/temp \
        --name=svn \
        --log-file=/mnt/nfs1_tp_lax_svn_ops_backup/duplicity/svn_backup.log \
        --encrypt-key=${GPG_KEY} \
        --sign-key=${GPG_KEY} \
            ${DEST} ${SOURCE} 


##### Reset the ENV variables. Don't need them sitting around
    export AWS_ACCESS_KEY_ID=
    export AWS_SECRET_ACCESS_KEY=
    export PASSPHRASE=


##### Remove the lockfile
    rm -f /mnt/nfs1_tp_lax_svn_ops_backup/duplicity/svn_bkp.lock
