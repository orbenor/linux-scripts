#!/bin/bash
echo "3 years old folders"
echo "==================="

for wis in `find -L $1* -maxdepth 0 -type d -print|xargs`
	do
		for dir in $wis
				do 
					#$DIR=`cat $dir`
					#if [[ -d ${dir} ]]
					#then
					COUNT=`find -L "$dir" -type d -mtime -1095 -print -quit | wc -l`
					if [ $COUNT -eq 0 ]
						then
						       du -hs "${dir}"	
					fi 
				done 
done 

