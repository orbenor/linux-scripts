#!/bin/bash
for arg in "$@"
do
index=$(echo $arg | cut -f1 -d=)
val=$(echo $arg | cut -f2 -d=)
case $index in
folder) x=$val;;

skip) y=$val;;

*)
esac
done

echo "folder $x"
echo "skip $y"


echo "3 years old folders"
echo "==================="
EXCLUDE=$y
for wis in `find -L $x* -maxdepth 0 -type d -print|xargs`
	do
		for dir in $wis
				do 
					#$DIR=`cat $dir`
					#if [[ -d ${dir} ]]
					#then
					if [ $wis = $EXCLUDE ]
						then
							echo "Skip $EXCLUDE"
						else
							(COUNT=`find -L "$dir" -type d -mtime -365 -print -quit | wc -l`;if [ $COUNT -eq 0 ];then du -hs "${dir}";fi) &
					fi
				done 
done 

