#!/bin/bash
for FILE in $PWD/* 
#for FILE in "$(find $PWD/* -maxdepth 0 -type d  | xargs -0)"
do
    echo "${FILE}"
    du -hs "${FILE}"
done
