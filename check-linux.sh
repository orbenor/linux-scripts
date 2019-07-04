#!/bin/bash
clear
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "`hostname` - STATUS"
echo "===================================================="
#Black        0;30     Dark Gray     1;30
#Red          0;31     Light Red     1;31
#Green        0;32     Light Green   1;32
#Brown/Orange 0;33     Yellow        1;33
#Blue         0;34     Light Blue    1;34
#Purple       0;35     Light Purple  1;35
#Cyan         0;36     Light Cyan    1;36
#Light Gray   0;37     White         1;37

#
if grep -q "MTU=9000" /etc/sysconfig/network-scripts/ifcfg-eth1
then
        echo -e "eth1 MTU is 9000\t\t\t\t- OK"
else
        echo -e "${RED}Wrong MTU in eth1 - please fix it to 9000${NC}"
fi


if grep -q "MTU=9000" /etc/sysconfig/network-scripts/ifcfg-eth2
then
        echo -e "eth2 MTU is 9000\t\t\t\t- OK"
else
        echo -e "${RED}Wrong MTU in eth2 - please fix it to 9000${NC}"
fi

#SELinux status:                 enabled
#SELinuxfs mount:                /selinux
#Current mode:                   enforcing
#Mode from config file:          enforcing
#Policy version:                 24
#Policy from config file:        targeted

service iptables status > /dev/null
OUT=$?
#echo $OUT
if [ $OUT -eq 3 ]
then
        echo -e "iptables: Firewall is not running.\t\t- OK"
else
        echo -e "${RED}ptables is running please stop it and chkconfig iptables off !! ${NC}"
fi

if grep -q "SELINUX=disabled" /etc/selinux/config
then
        echo -e "SELINUX in config is in disabled mode\t\t- OK"
else
        echo -e "${RED}Wrong SELINUX setting - please fix it to SELINUX=disabled and REBOOT your system!! ${NC}"
fi

sestatus | grep disabled > /dev/null
OUT=$?
#echo $OUT
if [ $OUT -eq 0 ]
then
        echo -e "SELINUX Current Status is in disabled mode\t- OK"
else
        echo -e "${RED}Wrong SELINUX setting - please fix it to SELINUX=disabled and REBOOT your system!! ${NC}"
fi

service ip6tables status > /dev/null
OUT=$?
#echo $OUT
if [ $OUT -eq 3 ]
then
        echo -e "ip6tables: Firewall is not running.\t\t- OK"
else
        echo -e "${RED}ip6tables: Firewall is running. - please stop it and run the command chkconfig ip6tables off${NC}"
fi
ifconfig | grep inet6 > /dev/null
OUT=$?
#echo $OUT

if [ $OUT -eq 0 ]
then
        echo -e "${RED}Please disable ipv6${NC}"
        echo -e "Please run the following command:"
        echo -e "=================================================="
        echo -e "sysctl net.ipv6.conf.all.disable_ipv6=1"
else
        echo -e "ipv6 module is off on all ethX \t\t\t- OK${NC}"
fi


grep "^net.ipv6.conf.all.disable_ipv6 = 1" /etc/sysctl.conf > /dev/null
OUT=$?
#echo $OUT
if [ $OUT -eq 1 ]
then
        echo -e "${RED}Please disable ipv6 in /etc/sysctl.conf${NC}"
        echo -e "Please add the following lines to /etc/sysctl.conf"
        echo -e "=================================================="
        echo -e "# IPv6 disabled\nnet.ipv6.conf.all.disable_ipv6 = 1\nnet.ipv6.conf.default.disable_ipv6 = 1\nnet.ipv6.conf.lo.disable_ipv6 = 1"

else
        echo -e "ipv6 module is off in /etc/sysctl.conf \t\t- OK${NC}"
fi


# IPv6 disabled
#net.ipv6.conf.all.disable_ipv6 = 1
#net.ipv6.conf.default.disable_ipv6 = 1
#net.ipv6.conf.lo.disable_ipv6 = 1

#[root@isrv05 ~]# chkconfig --list | grep Network| grep -E "3:off" | grep -E "5:on"
#[root@isrv05 ~]# echo $?
#1
#[root@isrv05 ~]# chkconfig --list | grep Network| grep -E "3:off" | grep -E "5:off"
#NetworkManager  0:off   1:off   2:off   3:off   4:off   5:off   6:off
#[root@isrv05 ~]# echo $?
#0

chkconfig --list | grep Network| grep -E "3:off" | grep -E "5:off" > /dev/null
OUT=$?
#echo $OUT
if [ $OUT -eq 0 ]
then
        echo -e "Network in chkconfig is off \t\t\t- OK"
#        echo -e "${RED}Please disable ipv6 in /etc/sysctl.conf${NC}"
#        echo -e "Please add the following lines to /etc/sysctl.conf"
##        echo -e "=================================================="
#        echo -e "# IPv6 disabled\nnet.ipv6.conf.all.disable_ipv6 = 1\nnet.ipv6.conf.default.disable_ipv6 = 1\nnet.ipv6.conf.lo.disable_ipv6 = 1"

else
#        echo -e "ipv6 module is off in /etc/sysctl.conf \t\t- OK${NC}"
        echo -e "${RED}Please off NetworkManager with: chkconfig NetworkManager off${NC}"
fi

#[root@isrv05 ~]# service NetworkManager status
#NetworkManager is stopped
#[root@isrv05 ~]# echo $?
#3

service NetworkManager status > /dev/null
OUT=$?
#echo $OUT
if [ $OUT -eq 3 ]
then
        echo -e "NetworkManager is stopped\t\t\t- OK"

else
        echo -e "${RED}Please top NetworkManager with: service NetworkManager stop${NC}"
fi

grep -E "^Defaultvers=3" /etc/nfsmount.conf > /dev/null
OUT=$?
if [ $OUT -eq 1 ]
then
        echo -e "${RED}Please uncomment and change value of #Defaultvers=4 to Defaultvers=3 in /etc/nfsmount.conf${NC}"

else
        echo -e "NFS Defaultvers is set to 3\t\t\t- OK"
fi
grep -E "^noatime=True" /etc/nfsmount.conf > /dev/null
OUT=$?
if [ $OUT -eq 1 ]
then
        echo -e "${RED}Please uncomment and the value of # noatime=True in /etc/nfsmount.conf${NC}"

else
        echo -e "NFS noatime=True \t\t\t\t- OK"
fi

FILE="/etc/profile.d/incpm.sh"

if [ -f "$FILE" ];
then
   echo -e "File $FILE exist\t\t- OK"
else
   echo -e "${RED}File $FILE does not exist${NC}"
fi

FILE="/etc/profile.d/gpfs.sh"

if [ -f "$FILE" ];
then
   echo -e "File $FILE exist\t\t- OK"
else
   echo -e "${RED}File $FILE does not exist${NC}"
fi

FILE="/etc/profile.d/modules.csh"

if [ -f "$FILE" ];
then
   echo -e "File $FILE exist\t\t- OK"
else
   echo -e "${RED}File $FILE does not exist${NC}"
fi

FILE="/etc/profile.d/modules.sh"

if [ -f "$FILE" ];
then
   echo -e "File $FILE exist\t\t- OK"
else
   echo -e "${RED}File $FILE does not exist${NC}"
fi
grep -E "rocommunity incpm" /etc/snmp/snmpd.conf > /dev/null
OUT=$?
#echo $OUT
if [ $OUT -eq 1 ]
then
        echo -e "${RED}Please add "rocommunity incpm" to /etc/snmp/snmpd.conf${NC}"

else
        echo -e "snmpd.conf settings\t\t\t\t- OK"
fi

service snmpd status > /dev/null
OUT=$?
#echo $OUT
if [ $OUT -eq 3 ]
then
        echo -e "${RED}snmpd is stopped please start it: service snmpd start${NC}"
else
        echo -e "snmpd is running\t\t\t\t- OK"
fi
chkconfig --list | grep snmpd| grep -E "3:off" | grep -E "5:off" > /dev/null
OUT=$?
#echo $OUT
if [ $OUT -eq 0 ]
then
        echo -e "${RED}Please on snmpd with: chkconfig snmpd  on${NC}"

#        echo -e "${RED}Please disable ipv6 in /etc/sysctl.conf${NC}"
#        echo -e "Please add the following lines to /etc/sysctl.conf"
##        echo -e "=================================================="
#        echo -e "# IPv6 disabled\nnet.ipv6.conf.all.disable_ipv6 = 1\nnet.ipv6.conf.default.disable_ipv6 = 1\nnet.ipv6.conf.lo.disable_ipv6 = 1"

else
#        echo -e "ipv6 module is off in /etc/sysctl.conf \t\t- OK${NC}"
        echo -e "snmpd chkconfig is on in chkconfig\t\t- OK"

fi


#+ : (incpm-admin) : ALL
#+ : (incpm) : ALL
#+ : root : 132.77.97.
#+ : root : 132.76.113.
#+ : root : 127.0.0.1
#+ : root : cron crond :0 tty1 tty2 tty3 tty4 tty5 tty6 pts/1 pts/2 pts/3 pts/4
#- : ALL EXCEPT (incpm) (wheel) shutdown sync:LOCAL
#- : ALL : ALL


#[root@isrv05 profile.d]# grep -e "^+ : (incpm-admin) : ALL" -e "^+ : (incpm) : ALL" -e "^+ : root : 132.77.97." /etc/security/access.conf
#+ : (incpm-admin) : ALL
#[root@isrv05 profile.d]# echo $?
#0


#MISSING=`grep -e "^+ : (incpm-admin) : ALL" -e "^+ : (incpm) : ALL" -e "^+ : root : 132.77.97." -e "^+ : root : 132.76.113." -e "^+ : root : 127.0.0.1" -e "^+ : root : cron crond :0 tty1 tty2 tty3 tty4 tty5 tty6 pts/1 pts/2 pts/3 pts/4" -e "^- : ALL EXCEPT (incpm) (wheel) shutdown sync:LOCAL" -e "^- : ALL : ALL" /etc/security/access.conf`
#echo $?
#echo $MISSING
count=0

for i in "+ : (incpm-admin) : ALL" "+ : (incpm) : ALL" "+ : root : 132.77.97." "+ : root : 132.76.113." "+ : root : 127.0.0.1" "+ : root : cron crond :0 tty1 tty2 tty3 tty4 tty5 tty6 pts/1 pts/2 pts/3 pts/4" "- : ALL EXCEPT (incpm) (wheel) shutdown sync:LOCAL" "- : ALL : ALL"
do
        grep "^$i" /etc/security/access.conf > /dev/null
        if [ $? -eq 1 ]
        then
                let "count += 1"
                echo -e "${RED} '$i'${NC} is missing from /etc/security/access.conf please add the line."
        fi
done
if [ "$count" -gt 0 ]
then
        echo "-------------------------------------------------------"
        echo "/etc/security/access.conf file should look like: (in the end of file)"
        echo "-------------------------------------------------------"
        echo "+ : (incpm-admin) : ALL"
        echo "+ : (incpm) : ALL"
        echo "+ : root : 132.77.97."
        echo "+ : root : 132.76.113."
        echo "+ : root : 127.0.0.1"
        echo "+ : root : cron crond :0 tty1 tty2 tty3 tty4 tty5 tty6 pts/1 pts/2 pts/3 pts/4"
        echo "- : ALL EXCEPT (incpm) (wheel) shutdown sync:LOCAL"
        echo "- : ALL : ALL"
else
        echo -e "/etc/security/access.conf\t\t\t- OK"
fi


#*             -   memlock        unlimited
#*          soft   memlock        unlimited
#*          hard   memlock        unlimited
# Leon
#*          soft    nofile          4096
#*          hard    nofile          16384
#*          soft    nproc           4096
#*          hard    nproc           16384
count=0
for i in "*             -   memlock        unlimited" "*          soft   memlock        unlimited" "*          hard   memlock        unlimited" "*          soft    nofile          4096" "*          hard    nofile          16384" "*          soft    nproc           4096" "*          hard    nproc           16384"
do
        grep "^$i" /etc/security/limits.conf > /dev/null
        if [ $? -eq 1 ]
        then
                let "count += 1"
                echo -e "${RED} '$i'${NC} is missing from /etc/security/limits.conf please add the line."
        fi
done
if [ "$count" -gt 0 ]
then
        echo "-------------------------------------------------------"
        echo "/etc/security/limits.conf file should look like: (in the end of file)"
        echo "-------------------------------------------------------"
        echo "*             -   memlock        unlimited"
        echo "*          soft   memlock        unlimited"
        echo "*          hard   memlock        unlimited"
        echo "*          soft    nofile          4096"
        echo "*          hard    nofile          16384"
        echo "*          soft    nproc           4096"
        echo "*          hard    nproc           16384"
else
        echo -e "/etc/security/limits.conf\t\t\t- OK"
fi

service ntpd status > /dev/null
OUT=$?
#echo $OUT
if [ $OUT -eq 0 ]
then
        echo -e "ntpd is running...\t\t\t\t- OK"
else
        echo -e "${RED}ntpd is not running please run it: service ntpd start${NC}"
fi
chkconfig --list | grep "ntpd " | grep -e "3:off" | grep -e "5:off" > /dev/null
OUT=$?
#echo $OUT
if [ $OUT -eq 0 ]
then
        echo -e "${RED}Please on ntpd with: chkconfig ntpd on${NC}"

#        echo -e "${RED}Please disable ipv6 in /etc/sysctl.conf${NC}"
#        echo -e "Please add the following lines to /etc/sysctl.conf"
##        echo -e "=================================================="
#        echo -e "# IPv6 disabled\nnet.ipv6.conf.all.disable_ipv6 = 1\nnet.ipv6.conf.default.disable_ipv6 = 1\nnet.ipv6.conf.lo.disable_ipv6 = 1"

else
#        echo -e "ipv6 module is off in /etc/sysctl.conf \t\t- OK${NC}"
        echo -e "ntpd is in on mode in chkconfig\t\t\t- OK"

fi


if grep -q -E 132.76.113.2 -E 132.76.113.6 /etc/ntp.conf
then
        echo -e "132.76.113.2 & 132.76.113.6 are in /etc/ntp.conf\t\t\t\t- OK"
else
        echo -e "${RED}please add this lines to: /etc/ntp.conf${NC}"
fi



if [ -f /usr/bin/vmware-config-tools.pl ]
then
        echo -e "VMware Tools installed\t\t\t\t- OK"
else
        echo -e "${RED}Please verify that you installed VMware Tools${NC}"
fi
