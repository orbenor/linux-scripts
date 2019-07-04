#!/bin/bash

RSYNC_FLAGS="-av --stats "
#uncoment next line for testing
RSYNC_FLAGS="-avn --stats "
STOR_PREFIX="gladia"
SOURCE_DIR="/home"
DEST_DIR="/net/istor01/export/users"
DOMAIN_NAME="INCPM"

user_id=""
group_id=10000 #group id for incpm

for USER in `ls ${SOURCE_DIR}`; do
        CMD=""
        USER_NAME=${USER#*_};
        echo "user name is: " ${USER_NAME}
        if [ -e ${DEST_DIR}/${USER_NAME} ]; then
                echo "user exists in ${DEST_DIR}/${USER_NAME}"
                if [ ! -d "${DEST_DIR}/${USER_NAME}/${USER_NAME}_${STOR_PREFIX}" ]; then
                        echo "mkdir -pv ${DEST_DIR}/${USER_NAME}/${USER_NAME}_${STOR_PREFIX}"
                fi
                if [ `ypdomainname` == ${DOMAIN_NAME} ]; then
                                        user_id=`ypcat -k passwd |grep ${USER_NAME} | awk -F: '{ print $3 }'`
                                        echo "users id: ${user_id}"
                                        group_id=`ypcat -k passwd | grep ${USER_NAME} |awk -F: '{ print $4 }'`
                                        echo "group id: ${group_id}"
                                fi
                CMD="rsync ${RSYNC_FLAGS} ${SOURCE_DIR}/${USER}/ ${DEST_DIR}/${USER_NAME}/${USER_NAME}_${STOR_PREFIX}/"
                CHOWN_CMD="chown -R ${user_id}:${group_id} ${DEST_DIR}/${USER_NAME}/${USER_NAME}_${STOR_PREFIX}/"
                echo ${CMD}
                #${CMD}
                echo ${CHOWN_CMD}
        else
                echo "user, ${USER_NAME}, dosen't exists in ${DEST_DIR}/"
        fi
done

