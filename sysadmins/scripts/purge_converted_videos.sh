#!/bin/sh

# Rationale :
# Springboard video system does not remove files after conversion
# that script runs every day and check the list of video converted
# archive and delete them

DATABASE=springboard
TOTAL=0
COUNT=0
LOG=/var/log/purge_converted_videos/purge_`/bin/date +%Y%m%d`.log

# all files ever converted
FILES=$(mysql -D${DATABASE} -e "select '/mnt/nfs/', b.domain, '/incoming/', a.id, a.original_filename from videos a inner join partner_configuration b on a.site_id = b.id where a.status='converted' and a.flag_embedded=0 and a.external=0;" | awk '{n=0; split($5,myarr,"."); for (i in myarr) n++; print $1$2$3$4"."myarr[n] }' | grep -v id.original_filename | grep -v system_default_partner)

# all files still on disk
echo "> Building file list..." > ${LOG}
echo "-" >> ${LOG}

for i in ${FILES}; do
    if [ -e ${i} ] ; then
        SIZE=`du -k $i | awk '{print $1}'`
        let TOTAL=${TOTAL}+${SIZE}
        let COUNT=${COUNT}+1
        echo "> Archiving ${i}" >> ${LOG}
        ssh root@ops2.lax3.gnmedia.net "mkdir -p /home/dtrajkovic`dirname ${i}`" >> ${LOG}
        scp ${i} root@ops2.lax3.gnmedia.net:/home/dtrajkovic`dirname ${i}` >> ${LOG}
        echo "> Deleting ${i}" >> ${LOG}
        rm -f ${i}
    fi
done

echo "-" >> ${LOG}
echo "> Deleted ${COUNT} files" >> ${LOG}
echo "> Reclaimed ${TOTAL} KB" >> ${LOG}

#cat ${LOG} | mailx -s 'Springboard Video:Nightly Purge' springboardplatform@gorillanation.com
# all standard output is captured in ${LOG}, let's use error output for mail (in case of) in cron definition

