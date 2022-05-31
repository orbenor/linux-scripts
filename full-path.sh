root@benoradmin:/gpfs/units/it/1-quick/acronis# cat /root/scripts/ph.sh 
#!/bin/bash
num=`pwd| sed -e 's/\(.\)/\1\n/g' | grep '/' | wc -l`
pwdpath=`pwd`
for ((i=2; i<=$num+1; i++))
do
    # Unix command here #
    echo $pwdpath | cut -d'/' -f1-$i
done
