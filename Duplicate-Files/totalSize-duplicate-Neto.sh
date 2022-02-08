#!/bin/bash
DIRECTORY=$1
for dir in $DIRECTORY*/    # list directories in the form "/tmp/dirname/"

        do
                dir=${dir%*/}      # remove the trailing "/"
                total=`du -hms "${DIRECTORY}${dir##*/}" | awk '{print $1}'`
                duplicate=`fdupes -rqSm "${DIRECTORY}${dir##*/}"`
                if [ "$duplicate" = "No duplicates found." ]; then
                        yes=0
                        bom="megabytes"
                else
                        yes=`echo $duplicate| awk '{print $8}'`
                        bom=`echo $duplicate |awk '{print $9}'`

                fi
                # echo 'Bytes Kilobytes or Megabytes:' $bom

                if [ "$bom" = "bytes." ]; then
                        #echo "Strings are bytes. :" $bom
                        ConvertToMega=`echo $yes / 1048576 | bc 2>/dev/null`
                        #echo "Convert Bytes to MegaBytes:" $ConvertToMega
                else
                        if [ "$bom" = "kilobytes" ]; then
                                # echo "Convert kiloBytes to MegaBytes:" $ConvertToMega
                                ConvertToMega=`echo $yes / 1024 | bc 2>/dev/null`
                        else
                                #echo "Strings are Mega:" $bom
                                ConvertToMega=$yes
                        fi
                fi
#   echo 'Duplicate size in Mega:' $ConvertToMega
fsize=`echo $total - $ConvertToMega | bc  2>/dev/null`
echo "${dir##*/}",$total,$yes,$fsize,"MB","${DIRECTORY}${dir##*/}"
done
