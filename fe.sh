#.!bin/bash
ls -l /gpfs/units/bioinformatics/projects/wis/ada.yonath/
FILE=`find /gpfs/units/bioinformatics/projects/wis/ada.yonath/* -type d -mtime -365 -print -exec sh -c 'kill -TERM $PPID' ';'`
case "$FILE" in
    '') ;;
    *)  echo "Found '$FILE'." ;;
esac
