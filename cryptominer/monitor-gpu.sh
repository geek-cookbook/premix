#!/bin/bash
# This script, when given GPU family (nvidia or amd) and an optional GPU number, will 
# Examine the output of whatever minerhotel-managed miner is running currently,
# extract the hash rate, and report it back to Icinga/Nagios as OK
# If no hash rate is found, a critical alarm is raised

GPUTYPE=$1
GPU=$2
VAR=$3

# If the user didn't specify a GPU, they probably only have one, so default to GPU0
if [[ -z "$GPU" ]]
then
	GPU=0
fi

case $GPUTYPE in
'amd')
	MINER=`systemctl | grep miner-amd | cut -f3 -d" " | cut -f1 -d\.`

	# Check the last 10 lines of output for the miner, for KH/s, MH/s or Sol/s, and grab the last line
	LAST_ETH_SPEED=`journalctl -u $MINER -n 20 | grep ETH    | egrep -oi "GPU$GPU [0-9\.]+ (kh/s|mh/s|sol/s)" | tail -n 1`
	LAST_DC_SPEED=`journalctl -u $MINER -n 20  | grep -v ETH | egrep -oi "GPU$GPU [0-9\.]+ (kh/s|mh/s|sol/s)" | tail -n 1`

	if [[ -z "$LAST_ETH_SPEED" ]]
	then
		echo "CRITICAL: No GPU$GPU stats from miner ($MINER)"
		exit 2
	else
		echo "OK : AMD $LAST_ETH_SPEED (Eth) / $LAST_DC_SPEED (Dual) on $MINER"
		exit 0
	fi

	;;
'nvidia')
	MINER=`systemctl | grep miner-nvidia | cut -f3 -d" " | cut -f1 -d\.`

	# Are we using the ewbf miner?
	if echo $MINER | grep -q ewbf
	then
		LAST_SPEED=`journalctl -u $MINER | egrep -i "kh/s|mh/s|sol/s" | grep "GPU$GPU" | tail -n 1 | egrep -o "GPU$GPU.*"`
	else
		# no, we're using ccminer
		LAST_SPEED=`journalctl -u $MINER | egrep -i "kh/s|mh/s|sol/s" | grep "GPU #$GPU" | tail -n 1 | egrep -o "GPU #$GPU.*"`
	fi
	
	if [[ -z "$LAST_SPEED" ]]
	then
		echo "CRITICAL: No GPU$GPU stats from miner ($MINER)"
		exit 2
	else
		echo "OK : $LAST_SPEED on $MINER"
		exit 0
	fi
	;;

*)
	echo "First parameter ($GPUTYPE) must be either 'amd' or 'nvidia'"
	exit 3
	;;
esac	


