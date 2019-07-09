#!/bin/bash
#set -x
while getopts f:e: option
do
case "${option}"
in
f) FOLDER=${OPTARG};;
e) EXCLUDE=${OPTARG};;
esac
done

echo "folder ${FOLDER}"
echo "skip ${EXCLUDE}"

echo "========================================================="
FOLDEROK=`echo "${FOLDER: -1}"`
#echo "${FOLDEROK}"
if [ "${FOLDEROK}" != "/" ]
	then
#		echo "${FOLDER}/" 
		FOLDER="${FOLDER}/"
fi

echo "3 years old folders"
echo "==================="

find -L $FOLDER* -maxdepth 0 -type d | while read wis; do

                                        if [ "${wis}" = "${EXCLUDE}" ] || [ "${wis}" = "${EXCLUDE}/" ] || [ "${wis}/" = "${EXCLUDE}" ] || [ "${wis}/" = "${EXCLUDE}/" ]
                                                then
                                                        echo "Skip $EXCLUDE"
                                                else
							#echo "${wis}"
							#du -hs "${wis}"
                                                        (COUNT=`find -L "${wis}" -type d -mtime -1095 -print -quit | wc -l`;if [ $COUNT -eq 0 ];then du -hs "${wis}";fi) &
							pids[${i}]=$!
                                        fi
                               
	done

# wait for all pids
for pid in ${pids[*]}; do
    wait $pid
done

echo "All processes done!"

#find -L $x* -maxdepth 0 -type d -print| xargs -0 | parallel -k "find -L {} -type d -mtime +1095 -and -not -mtime -1095 -print -quit"
# grep -e '^[0-9]*[0-9]M'  bioinformatics-projects-3-years-8-7-2019.txt | sort -nr | awk '{total+=$1} END {print total}'
