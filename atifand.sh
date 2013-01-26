#!/bin/bash

fan_idle=20       # fan speed for idle card
fan_min=30        # minimum fan speed for not idle card
fan_max=80        # maximum possible fan speed
temp_idle=55      # hitting below this, the fan will be set to fan_idle
temp_min=65       # hitting above this, the fan will be switched to something between fan_min and fan_max
temp_max=80       # hitting this means going fan_max
                  # temperatures between temp_min and temp_max
                  # linearly adjust fan speed between fan_min and fan_max

function GET_TEMP
{
	aticonfig --odgt | grep Temperature | sed -e 's/.*- \([0-9]\+\)\..*/\1/g'
}

aticonfig --od-enable 1>/dev/null

fan_d=$(($fan_max - $fan_min))
temp_d=$(($temp_max - $temp_min))
fan_is_idle=1
fan=$fan_idle

while : ; do
	temp=`GET_TEMP`

	if [ $temp -lt $temp_idle ]; then
		fan=$fan_idle
		fan_is_idle=1
	elif [ $temp -lt $temp_min -a $fan_is_idle == 0 ]; then
		fan=$fan_min
	elif [ $temp -gt $temp_max ]; then
		fan_is_idle=0
		fan=$fan_max
	elif [ $temp -gt $temp_min ]; then
		fan_is_idle=0
		temp_p=$(((($temp - $temp_min) * 100) / $temp_d))
		fan=$(((fan_min + (($temp_p * $temp_d)) / 100)))
	fi

	[ ! -z "$1" ] && echo "TEMP: $temp -> FAN: $fan"
	aticonfig --pplib-cmd "set fanspeed 0 $fan" 1>/dev/null
	sleep 10
done
