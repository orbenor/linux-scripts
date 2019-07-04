#!/bin/bash
#FILESYSTEMLIST=`izshell -u admin -p admin -c filesystem.query 132.76.113.5 | awk '{print $1}' | grep -v NAME`
#/usr/bin/izsnap -H 132.76.113.5 -a /etc/izbox.file -f users -b daily -r 10 -q --log=/var/log/izsnap.users-daily

HOURLY=6
DAILY=10
WEEKLY=8
OPSVIEW=132.76.113.11
STATE_ERROR=2

RETAINHourly=20
RETAINDaily=23
RETAINWeekly=15
RETAINMonthly=15
RETAINYearly=8
RETAINtad=20

STATE_ERROR_FS=2
STATE_ERROR_BASENAME=3
IZ_HOSTNAME=132.76.113.5
IZBOXFILE="/etc/izbox.file"

COMMAND="/usr/bin/izsnap"
PROGNAME=`basename $0`

problem_with_script() {
		snmptrap -v 2c -c incpmtrap  $OPSVIEW "" ucdStart sysContact.0 s "Problem with izsnap-script.sh"
		echo "Problem with izsnap-script.sh $COMMAND/"
}

print_usage() {
        echo "Usage: $PROGNAME -f <filesytem> -b <basename -r <retain> "
        echo ""
        echo "Notes:"
        echo "Example:"
        echo "/usr/bin/izsnap -f users -b daily-users -r 7"
        echo ""
	problem_with_script
	echo "Problem with izsnap-script.sh $COMMAND/"
	#problem_with_script
	exitstatus=$STATE_ERROR
	exit $exitstatus
}

while test -n "$1"; do
        case "$1" in
                --help)
                        print_usage
                        exit $STATE_UNKNOWN
                        ;;
                -h)
                        print_usage
                        exit $STATE_UNKNOWN
                        ;;
                -f)
                        FILESYSTEM=$2
                        shift
                        ;;
                -b)
                        BASENAME=$2
			echo "BASENAME IS: $BASENAME"
                        shift
                        ;;
                -r)
                        RETAIN=$2
                        shift
                        ;;
                *)
                        print_help
                        exit $STATE_UNKNOWN
        esac
        shift
done
if [ -z ${FILESYSTEM} ]
then
        echo "You must filesystem name."
        print_usage
        exitstatus=$STATE_ERROR_FS
        exit $exitstatus
fi
if [ -z ${BASENAME} ]
then
	echo "---------------------------------------------"
        echo "You must specify a base name of the snapshot."
 	echo "---------------------------------------------"
     	print_usage
        exitstatus=$STATE_ERROR_BASENAME
        exit $exitstatus
fi
#if [ "$BASENAME" -ne "daily" ] || [ "$BASENAME" -ne "hourly" ] || [ "$BASENAME" -ne "weekly"] ;
if [ "${BASENAME}" != "daily" ] && [ "${BASENAME}" != "hourly" ] && [ "${BASENAME}" != "weekly" ] && [ "${BASENAME}" != "tad" ] && [ "${BASENAME}" != "yearly" ] && [ "${BASENAME}" != "monthly" ];
# && [ "$BASENAME" <> "hourly" ] && [ "$BASENAME" <> "weekly"] ;
then
	echo "---------------------------------------------"
        echo "The base name can be |weekly|daily|hourly|tad|yearly|monthly|"
        echo "---------------------------------------------"
	problem_with_script
        exitstatus=$STATE_ERROR_BASENAME
        exit $exitstatus
else
	case "$BASENAME" in
                daily)
                        RETAIN=$RETAINDaily
                        ;;
                weekly)
                        RETAIN=$RETAINWeekly
                        ;;
        	hourly)
                        RETAIN=$RETAINHourly
                        ;;
		monthly)
			RETAIN=$RETAINMonthly
			;;
                tad)
			RETAIN=$RETAINtad
                        ;;
		
		*)
                        echo "RETAIN error 1 - 115"
			exitstatus=$STATE_ERROR
		        exit $exitstatus
        esac

fi
#if [ -z ${RETAIN} ]
#then
##        echo "You must specify retain number."
#        print_usage
#        exitstatus=$STATE_UNKNOWN
#        exit $exitstatus
#fi
echo "file SYSTEM $FILESYSTEM"
echo "BASENAME $BASENAME"
echo "RETAIN $RETAIN"

#ls /dsfsdf

NEWBASE="${BASENAME}_${FILESYSTEM}"
/usr/bin/izsnap -H $IZ_HOSTNAME -a $IZBOXFILE -f $FILESYSTEM -b ${NEWBASE}  -r $RETAIN -q --log=/var/log/izsnap/${NEWBASE}.log

#ls /root
#echo "Yes"
exitcode=$?
#echo $exitcode
if [ $exitcode -ne 0 ];
	then
		echo "$BASENAME Snapshot failed!!"
		snmptrap -v 2c -c incpmtrap  $OPSVIEW "" ucdStart sysContact.0 s "$BASENAME Snapshot Command failed"
		echo $exitcode
	else
		if  [ $exitcode == 0 ]; 
			then
				echo "$BASENAME Snapshot Succeeded"
				snmptrap -v 2c -c incpmtrap  $OPSVIEW "" ucdStart sysContact.0 s "$BASENAME Snapshot Command Succeeded"
		fi
fi

	case "$BASENAME" in
                monthly)
                        TODAY=`date +"%Y-%m-%d"`
			SNAPSHOTDATE=`izshell --csv -u admin -p admin -c snapshot.query $IZ_HOSTNAME| grep $NEWBASE.0 | awk -F, '{print $1,$2}' | awk '{print $2}'|head -n1`
			exitcode=$?
                        ;;

                daily)
                        TODAY=`date +"%Y-%m-%d"`
			SNAPSHOTDATE=`izshell --csv -u admin -p admin -c snapshot.query $IZ_HOSTNAME| grep $NEWBASE.0 | awk -F, '{print $1,$2}' | awk '{print $2}'|head -n1`
			exitcode=$?
                        ;;
                weekly)
                        TODAY=`date +"%Y-%m-%d"`
			SNAPSHOTDATE=`izshell --csv -u admin -p admin -c snapshot.query $IZ_HOSTNAME| grep $NEWBASE.0 | awk -F, '{print $1,$2}' | awk '{print $2}'|head -n1`
			exitcode=$?
#			date --d='this Friday' +"%Y-%m-%d"
                        ;;
		hourly)
                        TODAY=`date +"%Y-%m-%d %H"`
		#	SNAPSHOTDATE=`izshell --csv -u admin -p admin -c snapshot.query $IZ_HOSTNAME| grep hour| awk -F, '{print $2}'| awk -F: '{print $1}'|head -n1`
			SNAPSHOTDATE=`izshell --csv -u admin -p admin -c snapshot.query $IZ_HOSTNAME| grep $NEWBASE.0| awk -F, '{print $2}'| awk -F: '{print $1}'|head -n1`
	
		exitcode=$?
                        ;;

			tad)
                        TODAY=`date +"%Y-%m-%d"`
                        SNAPSHOTDATE=`izshell --csv -u admin -p admin -c snapshot.query $IZ_HOSTNAME| grep $NEWBASE.0 | awk -F, '{print $1,$2}' | awk '{print $2}'|head -n1`
                        exitcode=$?
                        ;;


                *)
                        echo "RETAIN error 2 - 172"
			exitstatus=$STATE_ERROR
		        exit $exitstatus
        esac


#TODAY=`date +"%Y-%m-%d"`
echo "TODAY: " $TODAY

#  SNAPSHOTDATE=`izshell --csv -u admin -p admin -c snapshot.query $IZ_HOSTNAME| grep $NEWBASE`
#printf "$SNAPSHOTDATE\n"

#SNAPSHOTDATE=`izshell --csv -u admin -p admin -c snapshot.query $IZ_HOSTNAME| grep $NEWBASE.0 | awk -F, '{print $1,$2}' | awk '{print $2}'|head -n1`
printf "$SNAPSHOTDATE\n"


if [ "$TODAY" == "$SNAPSHOTDATE" ] && [ "$exitcode" -eq "0" ] ;
	then
		echo "$BASENAME Snapshot Succeeded"
		snmptrap -v 2c -c incpmtrap  $OPSVIEW "" ucdStart sysContact.0 s "$BASENAME Snapshot Succeeded"
	elif  [ $exitcode -ne 0 ] ; 
		then 
		  echo "$BASENAME Snapshot failed"
                snmptrap -v 2c -c incpmtrap  $OPSVIEW "" ucdStart sysContact.0 s "$BASENAME Snapshot Command failed"
                echo $exitcode
	else
		echo "$BASENAME Snapshot Failed!!"
		snmptrap -v 2c -c incpmtrap  $OPSVIEW "" ucdStart sysContact.0 s "$BASENAME Snapshot failed"
fi
