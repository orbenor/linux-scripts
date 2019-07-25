#!/bin/bash

counter(){
    for file in "$1"/*
    do
    if [ -d "${file}" ]
    then
#            echo "$file"
		find "${file}"/* -maxdepth 0 -type f -exec stat --format "%n,%y,%s" {} \+ 2>/dev/null &
            counter "${file}" &
    fi
    done &
}
find "$1"/* -maxdepth 0 -type f -exec stat --format "%n,%y,%s" {} \+
counter "$1"
