#!/bin/bash

# ----------- Globals --------------------------------------------------
# The defualt backup source
DATA_DIR="/net/istor01/export/local/el6_x86_64"

# The defualt backup destination
BACKUP_ROOT="/net/istor01/export/local/backups"

# used for testing
TEST_BACKUP_DIR="/tmp/backup"; TEST_DATA_DIR="/tmp/test" 

FULL_DEST_DAY=6		#day of the week to run the full backup
					# 0 - Sunday to 6 - Saturday

MONTH_DAY=`date +%d`	#numeric day of the month
WEEK_DAY=`date +%w`	#first day of the week is Sunday (day 0). last day is saturday (day 6)a
TODAY_DATE=`date +%d_%m_%Y`	#Today's date DD_MM_YYYY format

# uncomment next line for testing
#BACKUP_ROOT=${TEST_BACKUP_DIR}; DATA_DIR=${TEST_DATA_DIR}

#FULL_BACKUP_ROOT=${BACKUP_ROOT}/full
#DIFFERENTIAL_BACKUP_ROOT=${BACKUP_ROOT}/differential

EXCLUDE_FILES_LIST="exclude-list.txt"

RSYNC_FLAGS=" --archive --verbose --stats"

# uncomment next line for testing
# dry run
#RSYNC_FLAGS=" -n --archive --verbose --delete --delete-excluded --exclude-from=$EXCLUDE_FILES_LIST"


# ----------------------------------------------------------------------



function usage
{
	#cat << "EOF"
	#	USAGE: rsync-backups.sh HOST [--recheck]
	#
	#	EOF
	echo "USAGE: rsync-backups.sh [options] [source dir] [destination dir]"
}	# usage end


function die 
{

	echo $1;

	exit 1;
}	# die end

function log 
{
	# first argument is the log message
	# second argument is the logs dir
	
	local logs_dir="${2%/*}"
	#echo "logs dir is: ${logs_dir}"
  
	message="`date` : $1"

	echo "$message"
	
	if [ ! -e ${logs_dir} ]; then
		mkdir -p ${logs_dir}
	fi

	echo "$message" >> $log_file

}	# log end

 

function clear_log 
{

  log=$1

  if [ -e $log ]; then

    rm -rf ${log} || die "Could not delete log file $log"

  fi

}	# clear_log end



function isFullDate 
{
	
	local exit_code=""
		
	#	return 0 if need to do a full backup
	#	today is one of the 7 first days of the month and is the full backup day
	#	otherwise return 1
	if [ ${MONTH_DAY} -lt 8 ] && [ ${MONTH_DAY} -eq ${FULL_DEST_DAY} ];
	then
		log "according to schedule runing full backup" "${log_file}"
		exit_code=0
	else
		log "according to schedule runing differential backup" "${log_file}"
		exit_code=1
	fi
	
	log "isFullDate exit with code ${exit_code}" "${log_file}"
	return "${exit_code}"
} #end of isFulldate


function run_daily_sync 
{
	#first argument is Full (1) or Diffrential (0)
	#second argument is the rsync flags
	#third argument is an exclusion files list 
	#fourth argument is the source location for the rsync
	#fifth argument is destinetion location for the rsync
	#sixth argument, if exists, is the compare directory
	
	local do_full="$1"
	local rsync_flags="$2"
	local exclude_list="$3"
	local source="$4"
	local destination="$5"
	local cmd="rsync ${rsync_flags}"
	local clean_cmd=
  
	#echo "daily_sync do_full: ${do_full}"
	#echo "source is: ${source}"
	#echo "dest is: ${destination}"
	#echo "exclude list is: ${exclude_list}"
	
	if [ -f $exclude_list ]; then
		#echo "exclude files list doesn't exists"
		#touch ${exclude_list}
		rsync_flags="${rsync_flags} --exclude-from=${exclude_list}"
	fi
	
	local cmd="rsync ${rsync_flags}"
	
	if [ $# -eq 6 ];then
		local compare="$6"
		#echo "comapre dir: ${compare}"
	#else
		#echo "no comparison dir"
	fi
	
	#echo "comparison is: ${compare}"
	#echo "do_Full: ${do_full}"
	if  [ "${do_full}" -eq 0 ]; then
		#echo "do_Full: ${do_full}, check resault is FULL"
		local cmd="${cmd} ${source} ${destination}"
	else
		#echo "do_Full: ${do_full}, check resault is DIFF"
		local cmd="${cmd} --compare-dest=${compare} ${source} ${destination}"
		#removing empty directories created by --compare-dest
		local clean_cmd="find ${destination} -depth -type d -empty -exec rmdir {} \;"
	fi
	

	log "Started backup with the following command:" "${log_file}"

	log "$cmd" "${log_file}"

	((time $cmd) 1>> ${log_file} 2>> ${error_log_file})
	
	local rc=$?
	
	log "Finished backup" "${log_file}"
	
	
	log "Started deleting empty firectories:" "${log_file}"

	log "$clean_cmd" "${log_file}"

	((time eval "$clean_cmd") 1>> ${log_file} 2>> ${error_log_file})
	#local rc=$?
	
	log "Finished cleaning" "${log_file}"

	du -sh ${destination} >& ${du_log_file}

	email_report $rc

} #end of run_daily_sync


function email_report 
{

	local rc=$1
	local email_file=/tmp/$$.eml

	#  local recipients='ophir.tal@weizmann.ac.il,leon.samuel@weizmann.ac.il'
	local recipients='mindu.weizmann@gmail.com'
  	
	log "Preparing email file ${email_file}"
	echo "Return code: ${rc}" >> $email_file
	echo "Error log:" >> $email_file
	echo "" >> $email_file
	cat $error_log_file >> $email_file
	echo "" >> $email_file
	echo "Backup directory size:" >> $email_file
	tail -1 ${du_log_file} >> $email_file
	mail -s "[Backup] ${TODAY_DATE} Report" ${recipients} < ${email_file}

	\rm $email_file

	log "Sent email to ${recipients}"

}	# end email report

##### --------- Main ---------------------------------------------------

# defualts

data_dir="${DATA_DIR}"
backup_root="${BACKUP_ROOT}"
full_backup_root="${backup_root}/full"
diff_backup_root="${backup_root}/differential"
exclud_files_list="${backup_root}/${EXCLUDE_FILES_LIST}"
log_file="${backup_root}/logs/${TODAY_DATE}.log"
error_log_file="${backup_root}/logs/${TODAY_DATE}.error.log"
du_log_file="${backup_root}/logs/${TODAY_DATE}.du.log"

fullflag=0 #defualt is to do a full backup

#cheking if according to the schedule need to do full or diffrential backup
isFullDate
fullflag=$?
#echo "fullflag: ${fullflag}"

# get the aruments
while [ "$1" != "" ]; do
	case $1 in
		-f | --full )			shift
								fullflag=0
								;;
		-d | --differential )	fullflag=1
								;;
		-h | --help )			usage
								exit
								;;
		--exclude )				;;
		* )						usage
								exit 1
	esac
done # checking the aruments

#echo "fullflag:  ${fullflag}"


# check if backup root exists
if [ ! -d ${full_backup_root} ]; then
	mkdir -p ${full_backup_root}
	log "full backups directory, ${full_backup_root}, dosn't exists" "${log_file}"
	fullflag=0 #if full backup destination dir doesn't exists, full backup if mandatory
	#checking if full backup root is not empty
else if find ${backup_root} -mindepth 1 | read; then #the full backup root is not empty
		last_full=`ls -t ${full_backup_root} | head -1`
		log "latest full backup dir is ${last_full}" "${log_file}" 
	else # full backup root is empty
		fullflag=0 #full backup if mandatory
		log "full backup root is empty" "${log_file}"
	fi #end of finding the last full backup, is exists
fi #end of checking if full backup root exists

#echo "fullflag:  ${fullflag}"
#echo "last full is: ${last_full}"

if [ ${fullflag} -eq 0 ]; then #need to do a full backup
	#echo "doing full backup"
	#		do full		flags for rsync		list of excluded files	files to backup		where to backup to
	run_daily_sync "${fullflag}" "${RSYNC_FLAGS}" "${exclud_files_list}" "${data_dir}" "${full_backup_root}/${TODAY_DATE}"
else	#need to do a diffrential backup
	#echo "doing diffrential backup"
	if [ ! -d ${diff_backup_root} ]; then
		mkdir -p ${diff_backup_root}
	fi
	#		do full		flags for rsync		list of excluded files	files to backup		where to backup to			compare to last full backup
	run_daily_sync "${fullflag}" "${RSYNC_FLAGS}" "${exclud_files_list}" "${data_dir}" "${diff_backup_root}/${TODAY_DATE}" "${full_backup_root}/${last_full}"
fi










