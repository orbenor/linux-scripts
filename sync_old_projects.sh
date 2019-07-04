#!/bin/bash

#--------------------- Globals -----------------------------------------
RSYNC_FLAGS="-av --stats "
#uncoment next line for testing
#RSYNC_FLAGS="-avn --stats "

TODAY_DATE=`date +%d_%m_%Y`	#Today's date DD_MM_YYYY format

declare -a REMOTE_STOR_ARR=("ngs002")
declare -a PROJECTS_LIST=()
SOURCE_DIR="/ngs002/user_data"
DEST_DIR="/bio/old_projects"
USERS_DIR="/net/istor01/export/users"
DOMAIN_NAME="INCPM"
MKDIR_CMD=
CMD=
CHOWN_CMD=

user_id=""
group_id=10000 #group id for incpm


#-----------------------------------------------------------------------


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

#---------------- Main -------------------------------------------------

script_name="${0##*/}"
log_file="/var/log/${script_name%.*}.log"
error_log_file="/var/log/${script_name%.*}.error.log"
du_log_file="/var/log/${script_name%.*}.du.log"

source_dir="${SOURCE_DIR}"
dest_dir="${DEST_DIR}"
users_dir="${USERS_DIR}"
project_dir=

echo "${log_file}"
#echo ${users_dir}
#echo ${source_dir}
#echo ${dest_dir}
#diff -q ${source_dir} ${users_dir} | sort | grep -v ${users_dir} | awk -F: '{print $2}'

#all directories that exists in ${source_dir} and missing from ${users_dir} are considered old projects
for PROJECT in `diff -q ${source_dir} ${users_dir} | sort | grep -v ${users_dir} | awk -F: '{print $2}'`
do
	project_dir="${source_dir}/${PROJECT}"
	#echo "for: ${source_dir}/${PROJECT}"
	if [ -d "${project_dir}" ];
	then
		log "copying ${project_dir} to ${dest_dir}/" "${log_file}"
		cmd="rsync ${RSYNC_FLAGS} ${project_dir} ${dest_dir}/"
		log "${cmd}" "${log_file}"
		((time $cmd) 1>> ${log_file} 2>> ${error_log_file})
		du -sh ${dest_dir}/${PROJECT} >& ${du_log_file}
	fi #if project directory exists
	if [ -d "${dest_dir}/${PROJECT}" ]; 
		then
			CHOWN_CMD="chown -R ${user_id}:${group_id} ${DEST_DIR}/${PROJECT}"
			log "${CHOWN_CMD}" "${log_file}"
		#	((time $CHOWN_CMD) 1>> ${log_file} 2>> ${error_log_file})
			echo " "
		else 
			log "${DEST_DIR}/${PROJECT} dosen't exists" "${log_file}"
		fi		
done #going trough old projects directories


