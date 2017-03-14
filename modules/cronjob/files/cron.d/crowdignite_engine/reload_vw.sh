#!/bin/bash

widget_pidfile="/var/run/vw/vw_widget.pid"
widget_modelfile="/app/data/vwmodels.live/widget.model"

# if vw pid exists and is older than the latest widget.model
if [ -e "$widget_pidfile" -a "$widget_pidfile" -ot "$widget_modelfile" ]
then
    /sbin/service vw_widget restart
fi


landing_pidfile="/var/run/vw/vw_landing.pid"
landing_modelfile="/app/data/vwmodels.live/landing.model"

# if vw pid exists and is older than the latest landing.model
if [ -e "$landing_pidfile" -a "$landing_pidfile" -ot "$landing_modelfile" ]
then
    /sbin/service vw_landing restart
fi
