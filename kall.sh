#!/bin/bash
for i in `ps -e --sort=start -o start,pid,cmd|grep <cmd>|egrep -v grep |sed 1d`
do
     echo $i
     #kill -9 $i
done
