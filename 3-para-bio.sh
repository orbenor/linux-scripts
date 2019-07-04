#!/bin/bash
date
echo "3 years files size"
echo "========================================================="
 find /gpfs/units/bioinformatics/* -maxdepth 0| grep -v "^/gpfs/units/bioinformatics$"  | parallel -P 64 -k "find {} -type f -mtime -1095 -printf '%s\n'  | awk '{a+=\$1;} END {printf \"%.1f GB \", a/2**30;}' && echo {}" 
date
