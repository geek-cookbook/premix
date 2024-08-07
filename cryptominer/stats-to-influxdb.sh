#!/bin/bash
# This script will identify running mirers (potentiall nvidia AND amd) and send their
# stats (hash rate, power, temperature) to MQTT

MINER=`systemctl | grep miner-amd | cut -f3 -d" " | cut -f1 -d\.`
COIN=`echo $MINER | cut -f3 -d\-`
DCOIN="sia"
SENDTOINFLUXDB="curl -i -XPOST http://influxdb:8086/write?db=cryptominer --data-binary"

if [[ ! -z "${MINER}" ]]  
then
	# Cycle through up to 10 GPUs
	for GPU in {0..9}
	do
		# Check the last 10 lines of output for the miner, for KH/s, MH/s or Sol/s, and grab the last line
		LAST_ETH_SPEED=`journalctl -u $MINER -n 20 | grep ETH    | egrep -oi "GPU$GPU [0-9\.]+ (kh/s|mh/s|sol/s)" | egrep -oi "[0-9\.]+" | tail -n 1` 
		LAST_DC_SPEED=`journalctl -u $MINER -n 20  | grep -v ETH | egrep -oi "GPU$GPU [0-9\.]+ (kh/s|mh/s|sol/s)" | egrep -oi "[0-9\.]+" | tail -n 1`

		# Checek the last 50 lines of output for environmental data (temp and fan), and grab and parse the last line
		LAST_ENV=`journalctl -u $MINER -n 20 | egrep -oi "GPU$GPU t=[0-9]+C fan=[0-9]+\%" | tail -n 1`
		LAST_FAN=`echo $LAST_ENV | cut -f 3 -d\= | egrep -o '[0-9]+'`
		LAST_TEMP=`echo $LAST_ENV | cut -f 2 -d\= | egrep -o '[0-9]+'`

		# If we actually _got_ any data (i.e, the GPU exists), then send it to influxdb
		if [[ ! -z "${LAST_ETH_SPEED}" ]]
		then

			# Query /proc to identify clockspeed and power draw
			# Start by incrementing the GPU number, /sys/kernel/debug/dri/ info starts with GPU1
			GPUPLUS1=$((GPU+1))

			# Grab power/clock stats based on how the data is represented in /proc
			LAST_MEMCLOCK=`grep mclk /sys/kernel/debug/dri/$GPUPLUS1/amdgpu_pm_info | cut -f3 -d\: | egrep -o "[0-9]+"`  
			if [[ ! -z "${LAST_MEMCLOCK}" ]]  
			then
				# Adjust to deal with decimal places
				let LAST_MEMCLOCK=`echo $((LAST_MEMCLOCK / 100))`
			else
				LAST_MEMCLOCK=`grep MCLK /sys/kernel/debug/dri/$GPUPLUS1/amdgpu_pm_info | egrep -o "[0-9\.]+"` 
				LAST_POWER=`grep 'max GPU' /sys/kernel/debug/dri/$GPUPLUS1/amdgpu_pm_info | egrep -o "[0-9\.]+"`
			fi
		
			$SENDTOINFLUXDB "hashrate,miner=$MINER,gpu=$GPU,coin=$COIN value=$LAST_ETH_SPEED" 
			$SENDTOINFLUXDB "hashrate,miner=$MINER,gpu=$GPU,coin=$DCOIN value=$LAST_DC_SPEED" 
			$SENDTOINFLUXDB "fan,miner=$MINER,gpu=$GPU value=$LAST_FAN" 
			$SENDTOINFLUXDB "temp,miner=$MINER,gpu=$GPU value=$LAST_TEMP" 
			$SENDTOINFLUXDB "memclock,miner=$MINER,gpu=$GPU value=$LAST_MEMCLOCK" 
			$SENDTOINFLUXDB "power,miner=$MINER,gpu=$GPU value=$LAST_POWER" 
		fi
	done
fi

# Now NVidia cards

MINER=`systemctl | grep miner-nvidia | cut -f3 -d" " | cut -f1 -d\.`
COIN=`echo $MINER | cut -f3 -d\-`

if [[ ! -z "${MINER}" ]]
then

        # Cycle through up to 10 GPUs
        for GPU in {0..9}
 	do

		# are we using ewbf?
		if echo $MINER | grep -q ewbf
		then
			LAST_SPEED=`journalctl -u $MINER | egrep -i "kh/s|mh/s|sol/s" | grep "GPU$GPU" | tail -n 1 | cut -f5 -d\: | egrep -o "[0-9]+"`
			LAST_POWER=`journalctl -u $MINER | grep " |  $GPU  |" | tail -n 1 | egrep -o "[0-9]+W" | cut -f1 -dW`
			LAST_TEMP=`journalctl -u $MINER | grep "Temp: GPU$GPU" | tail -n 1 | egrep -o "[0-9]+C" | cut -f1 -dC`
		else
			# no, we're using ccminer
			LAST_SPEED=`journalctl -u $MINER | egrep -i "kh/s|mh/s|sol/s" | grep "GPU #$GPU" | tail -n 1 | cut -f 2 -d \, | egrep -o "[0-9\.]+"`
			LAST_POWER=`journalctl -u $MINER | grep "GPU #$GPU" | grep MHz | tail -n 1 | egrep -o "[0-9]+W" | cut -f 1 -dW`
			LAST_TEMP=`journalctl -u $MINER | grep "GPU #$GPU" | grep MHz | tail -n 1 | egrep -o "[0-9]+C" | cut -f 1 -dC`
			LAST_FAN=`journalctl -u $MINER | grep "GPU #$GPU" | grep MHz | tail -n 1 | egrep -o "[0-9]+%" | cut -f 1 -d\%`
		fi

		# Get the temp, fan and power settings from nvidia-smi directly - note this only works for a singre GPU (I don't have 2 NVidia GPUs to test)
		LAST_TEMP=`nvidia-smi -q | grep "GPU Current Temp" | cut -f2 -d\: | egrep -o "[0-9]+"`		
	 	LAST_POWER=`nvidia-smi -q | grep "Power Draw" | cut -f2 -d\: | egrep -o "[0-9\.]+"`
	 	LAST_MEMCLOCK=`nvidia-smi -q -d CLOCK | grep Memory | head -1 | cut -f2 -d\: | egrep -o "[0-9\.]+"`
	
                # If we actually _got_ any data (i.e, the GPU exists), then send it to influxdb
                if [[ ! -z "${LAST_SPEED}" ]]
                then
                        $SENDTOINFLUXDB "hashrate,miner=$MINER,gpu=$GPU,coin=$COIN value=$LAST_SPEED"
                        $SENDTOINFLUXDB "fan,miner=$MINER,gpu=$GPU value=$LAST_FAN"
                        $SENDTOINFLUXDB "temp,miner=$MINER,gpu=$GPU value=$LAST_TEMP"
                        $SENDTOINFLUXDB "power,miner=$MINER,gpu=$GPU value=$LAST_POWER"
                        $SENDTOINFLUXDB "memclock,miner=$MINER,gpu=$GPU value=$LAST_MEMCLOCK"
                fi
	done
fi
