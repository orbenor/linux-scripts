#!/bin/bash
for wis in `find -L /gpfs/units/bioinformatics/projects/wis/* -maxdepth 0 -type d -print|xargs`
	do
		for dir in $wis/*
				do 
					#$DIR=`cat $dir`
					#if [[ -d ${dir} ]]
					#then
						COUNT=`find -L "$dir" -type d -mtime -365 -print -quit | wc -l`
						if [ "$COUNT" -eq 0 ]
							then
							du -hs "${dir}" 
						#echo "$dir"
						fi
					#if	
			done 
done 

