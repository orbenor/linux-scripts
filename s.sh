#!/bin/bash
for dir in /root/scripts/*
do echo $dir
#	$find -L "$dir" -path "./.snapshots/*" -prune -o -type d -o -type d -perm /o+r -print &
done

