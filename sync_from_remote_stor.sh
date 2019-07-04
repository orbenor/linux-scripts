#!/bin/bash

#--------------------- Globals -----------------------------------------
RSYNC_FLAGS="-auv --stats "
#uncoment next line for testing
#RSYNC_FLAGS="-avn --stats "

TODAY_DATE=`date +%d_%m_%Y`	#Today's date DD_MM_YYYY format

declare -a REMOTE_STOR_ARR=("ngs002")
declare -a USERS_LIST=("bsdena" "bsgilgi" "esterf")
USERS_SOURCE=""
USERS_DEST="/net/istor01/export/users"
SOURCE_DIR=
DEST_DIR=
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





#---------------- Main -------------------------------------------------

log_file="/var/log/sync_from_remote_stor.log"
error_log_file="/var/log/sync_from_remote_stor.error.log"
du_log_file="/var/log/sync_from_remote_stor.du.log"


#for USER in `ls ${USERS_DEST}`
for USER in ${USERS_LIST[@]}
do
	for STOR in ${REMOTE_STOR_ARR[@]};
	do
		log "stor name: ${STOR} " "${log_file}"
		#DEST_DIR="${USERS_DEST}/${USER}/${USER}_${STOR}"
		DEST_DIR="${USERS_DEST}/${USER}"
		#check if the stor is mounted
		if [ -d "${USERS_SOURCE}/${STOR}" ];
		then
			#echo "stor: ${STOR} exists in ${USERS_SOURCE}"	
				#SOURCE_DIR="${USERS_SOURCE}/${STOR}/${USER}"
				SOURCE_DIR="${USERS_SOURCE}/${STOR}/user_data/${USER}"
				log "checking source dir: ${SOURCE_DIR}" "${log_file}"
				#check if the user home dir exists on the remote store	
				if [ -d "${SOURCE_DIR}" ];
				then
					log "${SOURCE_DIR} exists in  ${USERS_SOURCE}/${STOR}" "${log_file}"
					# if the destinetion dir dosen't exsits in the users home directory
					# it will be created
#					if [ ! -d "${DEST_DIR}" ]; 
#					then
#						MKDIR_CMD="mkdir ${DEST_DIR}"
#						echo "${MKDIR_CMD}"
						CMD="rsync ${RSYNC_FLAGS} ${SOURCE_DIR}/ ${DEST_DIR}/"
						log  "${CMD}" "${log_file}"
						((time $CMD) 1>> ${log_file} 2>> ${error_log_file})
						
#					fi	#end creatting home directory
				else
					log "${USER} doesn't exists in  ${USERS_SOURCE}/${STOR}" "${log_file}"
				fi	#end if user's home directory exists on remote stor
		else
			log "stor: ${STOR} doesn'texists in ${USERS_SOURCE}" "${log_file}"
		fi
			
		if [ -d "${DEST_DIR}" ]; 
		then
			# if the user exists in the nis
			# the user_id and group_id are set according to the nis server
			# else the defaults are used
			if [ `ypdomainname` == ${DOMAIN_NAME} ]; then
				user_id=`ypcat -k passwd | grep ${USER}| awk -F: '{ print $3 }'`
				group_id=`ypcat -k passwd | grep ${USER}| awk -F: '{ print $4 }'`
			fi
			CHOWN_CMD="chown -R ${user_id}:${group_id} ${DEST_DIR}"
			log "${CHOWN_CMD}" "${log_file}"
			((time $CHOWN_CMD) 1>> ${log_file} 2>> ${error_log_file})
			echo " "
		else 
			log "${DEST_DIR} dosen't exists" "${log_file}"
		fi		
	done #loop trough stores
done #loop trough users

