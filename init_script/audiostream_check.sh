#!/bin/bash

CMD="/usr/bin/pulseaudio --start --log-target=syslog"
SCRIPT="pulseaudio"
NAME="pulseaudio"

#--------------------------------------------------------------------
function tst {
    echo "===> Executing: $*"
    if ! $*; then
        echo "Exiting scrip due to error from: $*"
        exit 1
    fi
}
#--------------------------------------------------------------------

function run_pulseaudio {
        # run pulse audio
        while true; do

            PID=$(ps aux | grep -v grep|grep $SCRIPT |awk '{print $2}') # get PID

            if ! [ -z $PID ]
            then
                echo "$NAME is running with PID: $PID."
                break
            else
                echo $PID "$NAME is not running... "
            fi

            tst $CMD
            sleep 3
            done
}

run_pulseaudio

# set output to analog
echo "Setting outpt to analog jack"
tst sudo amixer cset numid=3 1

itry=1 
# check again
while [ $itry -lt 10 ]
do
    echo "$(date): check $itry times:"
    run_pulseaudio
    ((itry+=1))
    sleep 10
    done
