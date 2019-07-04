#!/bin/bash
 
if [ ! -d "../zip-`basename "$PWD"`" ];
       then
               mkdir ../zip-`basename "$PWD"`
       fi
 
for i in */
do
	status=`ps -ef | grep "${i%/}.zip| grep -v grep"`
	if [ ! -z "$status" ]
		then
			if [ ! -f "../zip-`basename "$PWD"`/${i%/}.zip" ];
				then
					zip -r "../zip-`basename "$PWD"`/${i%/}.zip" "$i" 
			fi
	fi
done
