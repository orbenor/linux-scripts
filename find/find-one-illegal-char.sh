#!/bin/bash
# [+{;"\=?~()<>&*|$]
# it is only find the first char and quit.
date
echo "Files"
echo "---------------------------------------------------------------------------------"
for i in "\*" "\+" "\{" "\;" "\=" "\?" "\~" "\(" "\)" "\<" "\>" "\&" "\|" "\$" "\[" "\]"
       do
         echo $i | tr -d '\\' 
	 find /gpfs/units/genomics/* -not -path '*/.*' -name "*[$i]*" -type f -print -quit
       done

echo "Folders" 
echo "---------------------------------------------------------------------------------"
for i in "\*" "\+" "\{" "\;" "\=" "\?" "\~" "\(" "\)" "\<" "\>" "\&" "\|" "\$" "\[" "\]"
       do
	 echo $i | tr -d '\\'
	 find /gpfs/units/genomics/* -not -path '*/.*' -name "*[$i]*" -type d -print -quit
       done
date
