#!/bin/bash
 
# $Id: deploy_ci.sh 1974 2014-09-01 20:59:17Z rvicchiullo $
 
#set -e
#set -x
 
USER="deploy"
SVN_PREFIX="https://svn.gnmedia.net"
#PROJECT="tewn"
DATE=$(date +%Y%m%d);
CONTACTS="techteamcrowdignite@evolvemediallc.com"
TMPFILE=$(mktemp);
CURRENTREV=
DOCROOT=
HTDOCS=
SUBJECT=
 
# gweb event vars
SUMMARY=
GWEB_CLUSTER_REGEX=
 
if [[ $(id -u) -ne 0 ]]; then
  echo "You must use sudo to run this script.";
  exit 1;
fi
 
 
 
### FUNCTIONS
usage() {
cat << _eof
Usage: sudo ${0} -t <type> -r <revision> -e <environment>
 
OPTIONS:
   -t      Type of deploy: either widget or app
   -r      Revision to deploy.  If not specified
           HEAD will be used.
   -e      Environment.  Valid options:
           dev, stg, prd.
   -b      rollback to the previous release
_eof
exit 1;
}
 
# email/gweb functions
buildmsg() {
 
  if [[ ${CURRENTREV} -gt ${REVISION} ]]; then
    MSG="$(date +%Y%m%d%H%M) [${PROJECT}]: ${DTYPE} r${REVISION} rollback by ${SUDO_USER} from r${CURRENTREV}";
    SUBJECT="[${PROJECT}] ${ENVIRONMENT} ${DTYPE} rollback to r${REVISION} from ${CURRENTREV} by ${SUDO_USER}";
    SUMMARY="rollback to r${REVISION}";
  else
    MSG="$(date +%Y%m%d%H%M) [${PROJECT}]: ${DTYPE} r${REVISION} deployed by ${SUDO_USER}";
    SUBJECT="[${PROJECT}] ${ENVIRONMENT} ${DTYPE} code deployed to r${REVISION} by ${SUDO_USER}";
    SUMMARY="deploy to r${REVISION}";
  fi
 
  if [[ ${DTYPE} == "widget" ]]; then
    DIFFS="$(sudo -iu deploy svn diff -r${CURRENTREV}:${REVISION} ${SVN_URL}public_html_widget)";
  elif [[ ${DTYPE} == "app" ]]; then
    DIFFS="$(sudo -iu deploy svn diff -r${CURRENTREV}:${REVISION} ${SVN_URL}public_html)";
  fi
 
  echo -e "${MSG}\n\n" >> ${TMPFILE}
  echo "${DIFFS}" >> ${TMPFILE}
}
 
sendmsg() {
 
  for contact in ${CONTACTS}
  do
    cat ${TMPFILE} | mail -s "${SUBJECT}" ${contact}
  done
 
}
sendmetriclog() {
  if [[ ${CURRENTREV} -gt ${REVISION} ]]; then
    MSG="[${PROJECT}] ${ENVIRONMENT} ${DTYPE} rollback to r${REVISION} from ${CURRENTREV} by ${SUDO_USER}";
  else
    MSG="[${PROJECT}] ${ENVIRONMENT} ${DTYPE} code deployed to r${REVISION} by ${SUDO_USER}";
  fi
 
  if [[ ${DTYPE} == "widget" ]]; then
    DIFFS="$(sudo -iu deploy svn log -r ${REVISION} ${SVN_URL}public_html_widget)";
  elif [[ ${DTYPE} == "app" ]]; then
    DIFFS="$(sudo -iu deploy svn log -r ${REVISION} ${SVN_URL}public_html)";
  fi
 
  API_KEY="3b9bd7c5023836d1b55dfaa474ac3afd";
  API_SECRET="bd7317bc6b1fcdfd8a62ab2d038eae20";
  MESSAGE="${MSG}<br>${DIFFS//|/<br>}";
  MESSAGE="${MESSAGE//------------------------------------------------------------------------/}";
 
  case ${ENVIRONMENT} in
    dev)
      API_URL="http://jurodriguez.sbx.crowdignite.com/logs/action/save" ;;
      # use the one below on prd, the one above is for testing
      # API_URL="http://dev.crowdignite.com/logs/action/save"
    stg)
      API_URL="http://stg.crowdignite.com/logs/action/save" ;;
    prd)
      API_URL="http://crowdignite.com/logs/action/save" ;;
  esac
 
  # here send the information to metric logs
  # type=39 means TYPE_TECH_DEPLOY
  curl -s -d "key=${API_KEY}" -d "secret=${API_SECRET}" -d "type=39" -d "username=${SUDO_USER}" -d "refer=${REVISION}" --data-urlencode "notes=${MESSAGE}" $API_URL
} 
 
minify() {
    echo "Compressing Js files:"
    for file in `find js/ -name "*.js"`
    do
        compress_file=${file/js/js-min}
        echo -e "\t $file into $compress_file"
        directory=`dirname $compress_file`
        mkdir -p $directory
        java -jar /usr/local/yuicompressor/yuicompressor-2.4.8.jar --type js $file -o $compress_file
    done
    chown -R deploy:apache $directory
    chown -R deploy:apache cjs
 
    echo "Compressing CSS files:"
    for file in `find css/ -name "*.css"`
    do
        compress_file=${file/css/css-min}
        echo -e "\t $file into $compress_file"
        directory=`dirname $compress_file`
        mkdir -p $directory
        java -jar /usr/local/yuicompressor/yuicompressor-2.4.8.jar --type css $file -o $compress_file
    done
    chown -R deploy:apache $directory
    chown -R deploy:apache ccss
}
 
### END FUNCTIONS
 
if [[ $# -lt 1 ]]; then
  usage;
fi
 
while getopts ":t:r:e:hb" OPT; do
  case ${OPT} in
    t) DTYPE=${OPTARG} ;;
    r) REVISION=${OPTARG} ;;
    e) ENVIRONMENT=${OPTARG} ;;
    b) ROLLBACK=1 ;;
    h) usage ;;
  esac
done
 
# opt arguments parsing
if ! [[ ${ENVIRONMENT} =~ (^dev$|^stg$|^prd$|^test$) ]]; then
  if [[ -z ${ENVIRONMENT} ]]; then
    echo "An environment must be specified.";
  else
    echo "${ENVIRONMENT}: Invalid environment.";
  fi
  exit 2;
fi
 
case ${ENVIRONMENT} in
  dev)
    CACHE_URL="http://dev.crowdignite.com/pages/cache_clear"
    SERVER="app1v-ci.ci.dev.lax.gnmedia.net"
    OBJ="trunk"
    NGXSERVERS=( ngx1v-ci.ci.${ENVIRONMENT}.lax.gnmedia.net )
    APPSERVERS=( app1v-ci.ci.${ENVIRONMENT}.lax.gnmedia.net app1v-mgmt.ci.${ENVIRONMENT}.lax.gnmedia.net ) ;;
  stg)
    CACHE_URL="http://stg.crowdignite.com/pages/cache_clear"
    SERVER="app1v-ci.ci.stg.lax.gnmedia.net"
    OBJ="branches/production"
    NGXSERVERS=( ngx{1..4}v-ci.ci.${ENVIRONMENT}.lax.gnmedia.net )
    APPSERVERS=( app{1..2}v-ci.ci.${ENVIRONMENT}.lax.gnmedia.net app1v-mgmt.ci.${ENVIRONMENT}.lax.gnmedia.net ) ;;
  prd)
    CACHE_URL="http://crowdignite.com/pages/cache_clear"
    SERVER="app1v-ci.ci.prd.lax.gnmedia.net"
    OBJ="branches/production"
    NGXSERVERS=( ngx{1..10}v-ci.ci.${ENVIRONMENT}.lax.gnmedia.net )
    APPSERVERS=( app{1..8}v-ci.ci.${ENVIRONMENT}.lax.gnmedia.net app{1,2}v-mgmt.ci.${ENVIRONMENT}.lax.gnmedia.net ) ;;
esac
 
 
if ! [[ ${DTYPE} =~ (^widget$|^app$) ]]; then
  echo "Invalid type.  Options: widget or app."
  exit 2;
fi
 
 
case ${DTYPE} in
  widget)
    WEBSITE="widget.crowdignite.com"
    CURRENTREV=`cat /mnt/${ENVIRONMENT}/public_html_widget/version.txt`
    BUILDROOT="/mnt/${ENVIRONMENT}/public_html_widget.build"
    DOCROOT="/mnt/${ENVIRONMENT}/public_html_widget"
    HTDOCS="public_html_widget"
    PROJECT="crowdignite-widget"
    GWEB_CLUSTER_REGEX="ngx-ci-${ENVIRONMENT}" ;;
  app)
    WEBSITE="crowdignite.com"
    CURRENTREV=`cat /mnt/${ENVIRONMENT}/public_html/version.txt`
    BUILDROOT="/mnt/${ENVIRONMENT}/public_html.build"
    DOCROOT="/mnt/${ENVIRONMENT}/public_html"
    HTDOCS="public_html"
    PROJECT="tewn"
    WEBROOT="/mnt/${ENVIRONMENT}/public_html/app/webroot"
    GWEB_CLUSTER_REGEX="(eng|app)-(ci|vw|mgmt)-${ENVIRONMENT}" ;;
esac
 
SVN_URL="${SVN_PREFIX}/${PROJECT}/${OBJ}/"
if [[ ${DTYPE} == "widget" ]]; then
    SVN_CO="${SVN_URL}/public_html_widget"
else
    SVN_CO="${SVN_URL}/public_html"
fi
 
 
###### START
cd "/mnt/${ENVIRONMENT}"
 
if [[ ${ROLLBACK} -eq 1 ]]; then
    if [ ! -e "${DOCROOT}.prev" ]; then
        echo -e "It looks like we already rolled back to the previous rev!\nYou must specify a revision to build."
        exit 1
    fi
 
    REVISION=$(ls -ald "${DOCROOT}.prev"|awk '{print $11}' | sed s/${HTDOCS}\.//g)
    echo "Rolling back to previous revision (${REVISION})..."
    rm -fr ${DOCROOT}.redo && mv -fT ${DOCROOT} ${DOCROOT}.redo && mv -fT ${HTDOCS}.prev ${HTDOCS} && touch ${DOCROOT} && sync
else
 
    if [[ -z ${REVISION} ]]; then
        REVISION=$(sudo -iu deploy svn info ${SVN_URL} | grep "Last Changed Rev:" | sed s/Last\ Changed\ Rev:\ //g);
    fi
 
    if ! [[ ${REVISION} =~ ^[0-9]+$ ]]; then
        echo "Error: Revision must be a number."
        exit 2;
    fi
 
    if [[ ${CURRENTREV} -eq ${REVISION} ]]; then
        echo "Already at r${CURRENTREV}, exiting..."
        exit 2;
    fi
 
    if [ ! -d "$BUILDROOT" ]; then
        mkdir ${BUILDROOT}
        chown -R deploy:deploy ${BUILDROOT}
        sudo -iu deploy svn co ${SVN_CO} ${BUILDROOT}
    fi
 
    SVNUP="svn up -r ${REVISION} ${BUILDROOT} && echo ${REVISION} > ${BUILDROOT}/version.txt"
    su - deploy -c "${SVNUP}"
    chown -R deploy:deploy ${BUILDROOT}
 
    echo "Rolling out revision:${HTDOCS}:${REVISION}"
    if [[ ${DTYPE} == "app" ]]; then
        cd "${BUILDROOT}/app/webroot"
        minify
        cd "/mnt/${ENVIRONMENT}"
    fi
 
    rsync --delete --include=tags -avhzC "${BUILDROOT}/" ${DOCROOT}.next && rm -fr ${DOCROOT}.prev && mv -fT ${DOCROOT} ${DOCROOT}.prev && mv -fT ${DOCROOT}.next ${DOCROOT} && touch ${DOCROOT} && sync
 
fi
#### END
 
 
if [[ ${DTYPE} == "widget" ]]; then
  for nginx in ${NGXSERVERS[@]};
    do
      echo "${nginx} process:"
      echo "${nginx}: /app/shared/public_html_widget -> /dev/shm";
      su - deploy -c "ssh ${nginx} $'rsync --delete -aqhzC /app/shared/public_html_widget/ /dev/shm/public_html_widget'";
      echo "${nginx}: Restarting php-fpm...";
      su - deploy -c "ssh ${nginx} $'sudo /etc/init.d/php-fpm reload'";
      echo "${nginx}: Reloading nginx...";
      su - deploy -c "ssh ${nginx} $'sudo /etc/init.d/nginx reload'";
    done
elif [[ ${DTYPE} == "app" ]]; then
  echo ${REVISION} > /mnt/${ENVIRONMENT}/public_html/app/webroot/version.txt
  echo "Deleting compressed css or js files, and clearing caches...";
  # delete any existing compressed css or js files
  su - deploy -c "ssh ${SERVER} $'sudo -u apache /bin/rm /app/shared/public_html/app/tmp/cache/models/cake_model_*'";
  su - deploy -c "ssh ${SERVER} $'sudo -u apache /bin/rm /app/tmp/cache/models/cake_model_*'";
  su - deploy -c "ssh ${SERVER} $'/usr/bin/php -d apc.enabled=0 /app/shared/public_html/app/cron_dispatcher.php /pages/cache_clear'";
  # gracefully restart all app servers
  for appeng in ${APPSERVERS[@]};
    do
      echo "${appeng}: process:"
      echo "${appeng}: apache graceful..."
      su - deploy -c "ssh ${appeng} $'sudo /etc/init.d/httpd graceful'";
      su - deploy -c "ssh ${appeng} $'/usr/bin/php -d apc.enabled=0 /app/shared/public_html/app/cron_dispatcher.php /pages/cache_clear'";
    done
 
  # run this again...just to make sure!
  su - deploy -c "ssh ${SERVER} $'/usr/bin/php -d apc.enabled=0 /app/shared/public_html/app/cron_dispatcher.php /pages/cache_clear'";
 
fi
 
# update caplog
CAPLOG=/mnt/caplog/deploy.log
endtimestamp=$(date "+%m/%d/%Y %H:%M:%S %Z")
vertical=CrowdIgnite
application=${WEBSITE}
revision=${REVISION}
stage=${ENVIRONMENT}
deployinguser=${SUDO_USER}
 
sed -i "1i${endtimestamp}|${vertical}|${application}|${revision}|${stage}|${deployinguser}" ${CAPLOG}
 
# update metrics logs
sendmetriclog;
echo
 
# send email
buildmsg && sendmsg && rm -rf ${TMPFILE};
 
# display vertical bar deploy events in gweb
wget -O/dev/null -q  "http://ci.gweb.gnmedia.net/api/events.php?action=add&start_time=now&summary=${SUMMARY}&host_regex=${GWEB_CLUSTER_REGEX}"
 
 
    if [[ ${DTYPE} == "app" ]]; then
        echo "Cleaning up old app builds..."
        oldreleases=$(find /mnt/${ENVIRONMENT} -maxdepth 1 -regex '.*public_html\..*[0-9].*' -printf '%T@ %p\n' | sort -r | sed 's/^[^ ]* //' | tail -n +6)
        for rpath in ${oldreleases}; do
            echo ${rpath}
            rm -fr ${rpath}
        done
    else
        echo "Cleaning up old widget builds..."
        oldreleases=$(find /mnt/${ENVIRONMENT} -maxdepth 1 -regex '.*public_html_widget\..*[0-9].*' -printf '%T@ %p\n' | sort -r | sed 's/^[^ ]* //' | tail -n +6)
        for rpath in ${oldreleases}; do
            echo ${rpath}
            rm -fr ${rpath}
        done
    fi
 
exit 0;
