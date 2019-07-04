#!/bin/bash
for wis in `find $1* -maxdepth 0 -type d -print`
	do
		for dir in $wis/*
			do 
				COUNT=`find "$dir" -type d -mtime -365 -print -quit | wc -l`
				if [ "$COUNT" -eq 0 ]
					then
					du -hs $dir
				fi	

		done 
done 

