#!/bin/bash

CMD="/usr/bin/pulseaudio --start --log-target=syslog"
SCRIPT="pulseaudio"

while true; do

    PID=$(ps aux | grep -v grep|grep $SCRIPT |awk '{print $2}') # get PID

    if ! [ -z $PID ]
    then
        echo $PID "Successfully"
        break
    else
        echo $PID "Failed"
    fi

    echo "Starting..." "$CMD"
    $CMD
    sleep 3
    done
