#!/bin/bash

declare RTBIN=/usr/local/bin/rt
declare RTSERVER='http://inventory.gnmedia.net'
declare vis_check_dir=/var/lib/visual_check_html_gen
declare -A vis_check_template=(
    [static]=$vis_check_dir/sitemonTemplate.html
    [dynamic]=$vis_check_dir/auto_site_monTemplate.html
)

# Runs the rt query which retrieves the high priority production sites.
get_urls() {
    local query=$(cat <<EOF
Type = 'Site'
  AND Status != 'retired'
  AND Status = 'production'
  AND 'CF.{MonitorPriority}' = 'High'
EOF
    )

    $RTBIN ls -s -t asset "$query" |
    sed 's/.*: //g'
}

# Cherry picks those sites which need to be visual checked.
get_visual_check_urls() {
    local pattern=$(echo \
	'^analytics' \
	'|^external' \
	'|^trigger' \
	'|origin\.evolvemediacorp\.com' \
	'|assets' \
	'|microsites\.gorillanation' \
	'|geo\.g' \
	'|^widget' \
	'|^campaigns' |
	tr -d ' '
    )

    get_urls |
    grep -v -E "$pattern"
}

# Interpolates the value of the variable "$url" into the choosen template.
template() {
    local type=$1
    local urls=$(
	while read url ; do
	    echo $url
	done |
	sed 's/.\+/"&", /' |
	sed '$s/, //'
    )

    echo $(eval "echo -e \"$(sed 's/\"/\\\"/g' ${vis_check_template[$type]})\"")
}

# Dynamically generates all the required visual check monitoring files.
generate_files() {
    local -a sitemonTotal=($(get_visual_check_urls))
    local -i partSize=$(((${#sitemonTotal[@]} + 1)/ 2))
    local -a sitemonPartA=(${sitemonTotal[@]:0:$partSize})
    local -a sitemonPartB=(${sitemonTotal[@]:$partSize:${#sitemonTotal[@]}})
    local -a auto_site_mon=(${sitemonTotal[@]})
    declare -a sitemonInternal=(
	'netflow.gnmedia.net:8000/report.jsp?templid=0000&output=chart&unit=minute&nunits=60&device=72.172.76.1&recappl=80%2FTCP&reload=90'
	'vipvisual.gnmedia.net'
	'toolshed.gnmedia.net/toolshed'
	'em.gnmedia.net'
	'intranet'
	'graphite.gnmedia.net'
	'docs.gnmedia.net'
	'caplog.gnmedia.net/prd.php'
	'nagios.prd.gnmedia.net'
	'rt.gorillanation.com'
	'inventory.gnmedia.net'
	'nocreports.gnmedia.net'
	'www.speedtest.net'
    )

    if [ ! -d $vis_check_dir ] ; then
	mkdir -p $vis_check_dir
    fi

    for part in sitemon{Total,Part{A,B},Internal} ; do
	eval "echo \${$part[@]}" |
	tr ' ' '\n' |
	template 'static' > $vis_check_dir/$part.html
    done

    # The auto cycler uses a different kind of template.
    echo ${auto_site_mon[@]} |
    tr ' ' '\n' |
    template 'dynamic' > $vis_check_dir/auto_site_mon.html
}

generate_files
