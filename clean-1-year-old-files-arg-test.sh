#!/bin/bash
#set -x
waitall() { # PID...
  ## Wait for children to exit and indicate whether all exited with 0 status.
  local errors=0
  while :; do
    debug "Processes remaining: $*"
    for pid in "$@"; do
      shift
      if kill -0 "$pid" 2>/dev/null; then
        debug "$pid is still alive."
        set -- "$@" "$pid"
      elif wait "$pid"; then
        debug "$pid exited with zero exit status."
      else
        debug "$pid exited with non-zero exit status."
        ((++errors))
      fi
    done
    (("$#" > 0)) || break
    # TODO: how to interrupt this sleep when a child terminates?
    sleep ${WAITALL_DELAY:-1}
   done
  ((errors == 0))
}

debug() { echo "DEBUG: $*" >&2; }

set -o monitor
pids=""
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

echo "1 years old folders"
echo "==================="

find -L $FOLDER* -maxdepth 0 -type d | while read wis; do

                                        if [ "${wis}" = "${EXCLUDE}" ] || [ "${wis}" = "${EXCLUDE}/" ] || [ "${wis}/" = "${EXCLUDE}" ] || [ "${wis}/" = "${EXCLUDE}/" ]
                                                then
                                                        echo "Skip $EXCLUDE"
                                                else
							#echo "${wis}"
							#du -hs "${wis}"
                                                        (COUNT=`find -L "${wis}" -type d -mtime -365 -print -quit | wc -l`;if [ $COUNT -eq 0 ];then du -hs "${wis}";fi) &
							 pids="${wis} $i"
                                        fi
                               
	done

#wait $pid
	wait $pids
wait
echo " HAHAHA"
#find -L $x* -maxdepth 0 -type d -print| xargs -0 | parallel -k "find -L {} -type d -mtime +1095 -and -not -mtime -1095 -print -quit"
