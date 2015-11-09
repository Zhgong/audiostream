#!/bin/bash
### BEGIN INIT INFO
# Provides:          smsutil
# Required-Start:    $remote_fs $syslog
# Required-Stop:     $remote_fs $syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Example initscript
# Description:       This service is used to manage a servo
### END INIT INFO


# todo: reconfigure this file to run autiostream_check.sh
# CMD="/usr/bin/pulseaudio --start --log-target=syslog"
# echo "Starting" $CMD >> $RC_LOCAL_LOG
# sleep 60
# sudo -u osmc $CMD >> $RC_LOCAL_LOG 2>&1
# echo $now >> $RC_LOCAL_LOG
# echo "rc.local finished" $CMD >> $RC_LOCAL_LOG

DIR=/home/osmc/smsutil
SCRIPT=smsutil.py
DAEMON=$DIR/$SCRIPT
DAEMON_NAME=smsutil
LOGFILE=/var/log/$DAEMON_NAME.log

echo `date`: $0: running >> $LOGFILE

start(){
	python3 $DAEMON $LOGFILE >> $LOGFILE 2>&1 &
	# sleep 1
	PID=$(ps aux | grep -v grep|grep $SCRIPT |awk '{print $2}') # get PID
	echo "script started with pid:" $PID
	echo `date`: "Starting system $DAEMON_NAME daemon with PID: $PID" >> $LOGFILE
}

stop(){
	PID=$(ps aux | grep -v grep|grep $SCRIPT |awk '{print $2}') # get PID
	kill -15 $PID
	echo "killed" $SCRIPT "with pid:" $PID
	echo `date`: "Stopping system $DAEMON_NAME daemon with PID: $PID" >> $LOGFILE
}


status(){
	PID=$(ps aux | grep -v grep|grep $SCRIPT |awk '{print $2}') # get PID

	if [ -z $PID ]
	then
	 	echo $SCRIPT "is not running"
	else
	 	echo $SCRIPT "is running with pid:" $PID
	fi
}

case "$1" in 
	start)
 		echo "Starting " $SCRIPT
       		start
        	;;
	stop)
       		echo "Stopping " $SCRIPT
		stop
        	;;

	restart)
		stop
		start
		;;
	status)
		status
		;;
    	*)
		echo "Usage: /etc/init.d/"$DAEMON_NAME" start|stop|status|restart"
        	exit 1
	        ;;
esac

exit 0

