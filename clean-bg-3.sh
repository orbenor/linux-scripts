#!/bin/bash
#PATHCLEAN=`find -L $1* -maxdepth 0 -type d -print|xargs`
for wis in `find -L $1* -maxdepth 0 -type d -print|xargs`
	do

		for dir in $wis/*
				do 
						COUNT=`find -L "$dir" -type d -mtime -1095 -print -quit | wc -l`
						if [ "$COUNT" -eq 0 ]
							then
							du -hs "${dir}" &
						fi
			done 
done 

