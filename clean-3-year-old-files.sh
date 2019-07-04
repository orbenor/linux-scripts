#!/bin/bash
#set -x
for arg in "$@"
do
index=$(echo $arg | cut -f1 -d=)
val=$(echo $arg | cut -f2 -d=)
case $index in
folder) x=$val;;

skip) y=$val;;

*)
esac
done

echo "folder $x"
echo "skip $y"


echo "3 years old folders"
echo "==================="
EXCLUDE=$y

find -L $x* -maxdepth 0 -type d | while read wis; do

                                        if [ "${wis}" = "${EXCLUDE}" ]
                                                then
                                                        echo "Skip $EXCLUDE"
                                                else
							#echo "${wis}"
							#du -hs "${wis}"
                                                        (COUNT=`find -L "${wis}" -type d -mtime -1095 -print -quit | wc -l`;if [ $COUNT -eq 0 ];then du -hs "${wis}";fi) 
                                        fi
                               
	done



#find -L $x* -maxdepth 0 -type d -print| xargs -0 | parallel -k "find -L {} -type d -mtime +1095 -and -not -mtime -1095 -print -quit"
