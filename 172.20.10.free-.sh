#!/bin/bash

#------------------------------------------------------------------------------
#this script find all IP's that's are not in A recored in DNS and print them.
# and if it is less then  20 or 10 it will exit with warning or critical alert.
#------------------------------------------------------------------------------

# Nagios return codes
STATE_OK=0
STATE_WARNING=1
STATE_CRITICAL=2
STATE_UNKNOWN=3
STATE_DEPENDENT=4
NETWORK=172.20.10
WIP=20
CIP=10

i=0
echo "IP's that's are not recorded in DNS"
for ip in {1..255}
do
#	echo $ip
	host -l $NETWORK.$ip | grep NXDOMAIN > /dev/null
if [ $? -eq 0 ]; then
	echo "Free IP: 172.20.20.$ip"
	let "i += 1"
fi
done
if [ $i -lt $CIP ]
	then
		exit $STATE_OK
		exitstatus=$STATE_CRITICAL
elif [ $i -lt $WIP ]
	then
		exit $STATE_OK
		exitstatus=$STATE_WARNING
fi

echo "|Free_IPs=$i"
exit $STATE_OK
