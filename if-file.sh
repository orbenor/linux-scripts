#!/bin/bash
home=`echo ~`
file="$home/.ssh/config"
g=`groups | tr ' ' '\n' | grep -i "incpm$"`
if [ $g = "incpm" ] && [ "$USER" != "root" ]  && [ "$USER" != "postgres" ]
	then 
		if [ -f "$file" ]
		then
			echo "$file found."
		else
			echo "$file not found."
			printf "Host *\n   StrictHostKeyChecking no\n   UserKnownHostsFile=/dev/null\n   LogLevel error\n" >> $file
		fi
fi
