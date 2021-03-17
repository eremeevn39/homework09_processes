#!/bin/bash
echo "PID" "TTY" "STATE" "TIME_IN_SEC" "CMD_LINE" "COMMAND"
function ps_ax
{
    pid_array=`ls /proc | grep -E '^[0-9]+$'`
    HZ=$(getconf CLK_TCK)
    for pid in $pid_array
    do
        fd=/proc/$pid/fd/0
        if [ -r /proc/$pid/stat ]
        then
	    state=$(cat /proc/$pid/stat | awk  '{print $(NR=3)}')
	    utime=$(cat /proc/$pid/stat | awk  '{print $(NR=14)}')
	    stime=$(cat /proc/$pid/stat | awk  '{print $(NR=15)}')
            total_time=$(( $utime + $stime ))
	    time_in_sec=$(( $total_time / $HZ ))
	    cmd=$(cat /proc/$pid/cmdline | strings -1 | awk 'NR==1 {print}')
	    comm=$(echo [$(cat /proc/$pid/comm)])
	        if [ -r "$fd" ]
			then tty=$( ls -l $fd | awk  '{print $(NR=11)}' )
			else tty="?"	
		fi
	echo $pid $tty $state $time_in_sec $cmd $comm
	fi
    done
}
ps_ax
