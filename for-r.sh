#!/bin/bash

counter(){
    for file in "$1"/*
    do
    if [ -d "$file" ]
    then
	    #stat --format "%n,%s,%y"
#	    find $1$file/ -maxdepth 1 -type f -print0 #| xargs -0 -I {} stat --format "%n %a" {}
		echo $1
	    counter "$file" 
    	fi
    done 
}
wait
counter "$1"
wait
jobs
echo "============================================================================"
echo "Done"
echo "============================================================================"
