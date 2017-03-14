#!/bin/bash
set -e
#set -x

# get today's date minus 10 days
TODAY=`date +"%s"`
OLD=`expr $TODAY - 864000`

if [ -z $1 ]; then
    echo "Error: Missing git repository"
    exit 1
else
    REPO=$1
fi

function delete_tags {
	for TAG in $ALL_TAGS;
	do
	  #for each tag, get the epoch date of the tag
	  EDATE=`git log --pretty=format:"%ad" --date=raw -1 $TAG |cut -d ' ' -f1`

	  #if epoch date is older than 10 days, delete the tag
	  if [[ ${EDATE} -le ${OLD} ]]; then
	      git push https://git.gnmedia.net/${REPO} :$TAG
	  fi
	done
}

GIT_DIR="/app/shared/git"
#cd to the local repo
cd ${GIT_DIR}/${REPO}.git

if [ "${REPO}" == "puppet-modules" ]; then

        # get list of tags for each dev env
        ALL_TAGS=$(git for-each-ref --format="%(refname)" refs/tags |grep jenkins-puppet-modules-dev|cut -d '/' -f3)
        # if we have fewer than 10 tags, don't delete any
        CHECK="$(echo "$ALL_TAGS" | wc -l)"
        if [[ ${CHECK} -gt "10" ]]; then
            delete_tags
        fi

        # get list of tags for each stage env 
        # if we have fewer than 10 tags, don't delete any
        ALL_TAGS=$(git for-each-ref --format="%(refname)" refs/tags |grep jenkins-puppet-modules-stg|cut -d '/' -f3)
        CHECK="$(echo "$ALL_TAGS" | wc -l)"
        if [[ ${CHECK} -gt "10" ]]; then
            delete_tags
        fi

        # get list of tags for each prod env 
        ALL_TAGS=$(git for-each-ref --format="%(refname)" refs/tags |grep jenkins-puppet-modules-prd|cut -d '/' -f3)
        CHECK="$(echo "$ALL_TAGS" | wc -l)"
        if [[ ${CHECK} -gt "10" ]]; then
            delete_tags
        fi

else
        # get list of all tags
        ALL_TAGS=$(git for-each-ref --format="%(refname)" refs/tags |grep jenkins|cut -d '/' -f3)
        CHECK="$(echo "$ALL_TAGS" | wc -l)"
        if [[ ${CHECK} -gt "10" ]]; then
            delete_tags
        fi

fi 
