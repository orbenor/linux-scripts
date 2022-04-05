#!/bin/bash
clear 

unit_size()
  {
    unit=$1
		LC=`echo $unit | tr [:lower:] [:upper:]`
	  B=`tail -n 24 /var/log/sizenfs.log | grep "/nfs/units/$unit" | sort -r | head -n 2 | awk -F, 'NR==2 {print $2}'`
	  A=`tail -n 24 /var/log/sizenfs.log | grep "/nfs/units/$unit" | sort -r | head -n 2 | awk -F, 'NR==1 {print $2}'`

	  echo -e "\b"
	  GB=`echo "$A-$B" | bc`
	  TB=`echo "$GB / 1024" | bc`
	  echo "the size of $LC that's add today is: $GB GB - $TB TB" | mail -s "$LC - $GB GB / $TB TB - add to $LC folder" mail@example.com
	  echo "the size of $LC that's add today is: $GB GB - $TB TB" 
  }

ogsave -a /var/log/sizenfs.log /root/scripts/df-log.sh > /dev/null

unit_size 
unit_size it

-----------------------------------------------------

# root@admin:~/scripts# cat df-log.sh 
## #!/bin/bash
## df -PBG | grep units | awk '{  print strftime("%d-%m-%Y")","$3","$6}'| sed 's/G//g'
-----------------------------------------------------


