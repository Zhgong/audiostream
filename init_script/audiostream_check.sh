#!/bin/bash

CMD="/usr/bin/pulseaudio --start --log-target=syslog"
SCRIPT="pulseaudio"
NAME="pulseaudio"

STATE="INIT"
OLD_STATE="INIT"
iRESTART=0  # counter for how many times it restarts
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
                MSG="$NAME is running with PID: $PID."
                STATE="ACTIVE"
            else
                ((iRESTART+=1))

                MSG="$NAME is not running. Restart $iRESTART times."
                STATE="INACTIVE"
            fi


            # check if state changed

            if [[ $OLD_STATE != $STATE ]]
            then
                echo $(date): $MSG
            else
                if [[ $STATE == "ACTIVE" ]]
                then
                    break
                fi
            fi

            if [[ $STATE == "INACTIVE" ]]
            then
                tst $CMD
            fi

            OLD_STATE=$STATE

            sleep 3
            done
}


echo ----------------------------------
tst run_pulseaudio

# set output to analog
echo "===> Setting outpt to analog jack"
tst sudo amixer cset numid=3 1

itry=1 
# check again
while [ $itry -lt 10 ]
do
    # echo "$(date): check $itry times:"
    run_pulseaudio
    ((itry+=1))
    sleep 10
    done

echo "$(date): exit script"
