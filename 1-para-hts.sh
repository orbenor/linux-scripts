#!/bin/bash
 find /gpfs/units/hts/* -maxdepth 0| grep -v "^/gpfs/units/hts$"  | parallel -P 64 -k "find {} -type f -mtime -365 -printf '%s\n'  | awk '{a+=\$1;} END {printf \"%.1f GB \", a/2**30;}' && echo {}" 
