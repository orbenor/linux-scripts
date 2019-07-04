#!/bin/bash
yum -y install gcc-c++ gcc-objc gcc-objc++ compat-gcc-34-c++ gcc-x86_64-linux-gnu libgcj libgcj-devel
if ! grep -qi 'PEERDNS' /etc/sysconfig/network-scripts/ifcfg-eth0
then
	echo "PEERDNS=yes" >> /etc/sysconfig/network-scripts/ifcfg-eth0
else
	if ! grep -qi 'PEERDNS=no\|PERRDNS=NO' /etc/sysconfig/network-scripts/ifcfg-eth0
		then
			echo "peerdns= ok"

		else
			sed -i 's/PEERDNS=no/PEERDNS=yes/g' /etc/sysconfig/network-scripts/ifcfg-eth0
			sed -i 's/PEERDNS=NO/PEERDNS=yes/g' /etc/sysconfig/network-scripts/ifcfg-eth0

	fi
		
fi
/etc/init.d/NetworkManager restart
#search INCPM.WEIZMANN.AC.IL incpm.weizmann.ac.il default.domain.incpm.weizmann.ac.il
#nameserver 172.20.10.6
#nameserver 132.76.113.6
#nameserver 132.76.113.2

# DNS1=xxx.xxx.xxx.xxx
# DNS2=xxx.xxx.xxx.xxx
# DOMAIN=lab.foo.com bar.foo.com

if ! grep -qi 'DOMAIN' /etc/sysconfig/network-scripts/ifcfg-eth0
then
	sed -i "1i DOMAIN='default.domain.incpm.weizmann.ac.il INCPM.WEIZMANN.AC.IL incpm.weizmann.ac.il'" /etc/sysconfig/network-scripts/ifcfg-eth0
else
	echo '/etc/sysconfig/network-scripts/ifcfg-eth0 - DOMAIN - OK'
fi

if ! grep -qi 'DNS1' /etc/sysconfig/network-scripts/ifcfg-eth0
then
        sed -i '2i DNS1=172.20.10.6' /etc/sysconfig/network-scripts/ifcfg-eth0
else
        echo '/etc/sysconfig/network-scripts/ifcfg-eth0 - DNS1 - OK'
fi

if ! grep -qi 'DNS2' /etc/sysconfig/network-scripts/ifcfg-eth0
then
        sed -i '3i DNS2=132.76.113.6' /etc/sysconfig/network-scripts/ifcfg-eth0
else
        echo '/etc/sysconfig/network-scripts/ifcfg-eth0 - DNS2 - OK'
fi
/etc/init.d/NetworkManager restart

cat /etc/resolv.conf

/etc/init.d/iptables stop
/etc/init.d/ip6tables stop
chkconfig iptables off
chkconfig ip6tables off

umount /mnt
mount igpfs:/gpfs/apps/repos /mnt
rpm -ivh /mnt/RHEL/RHEL6.8/RHEL6.8-Server/Packages/ksh-20120801-33.el6.x86_64.rpm
umount /mnt
if [ -f /etc/profile.d/incpm.sh ];
then
   echo "File incpm.sh exists."
else
 rsync -rvpougt isrv09:/etc/profile.d/incpm.sh /etc/profile.d/
fi

mount igpfs:/gpfs/units/it /mnt/

rpm -ivh /mnt/Software/IT/IBM/GPFS/lin_rpms/gpfs*.rpmutoconfig
cd /usr/lpp/mmfs/src
make Autoconfig
make World
make InstallImages
umount /mnt

mount igpfs:/gpfs/units/it	/mnt

/etc/init.d/gpfs stop
/mnt/Software/IT/IBM/GPFS/gpfs-4.1.1.6/Spectrum_Scale_Standard-4.1.1.6-x86_64-Linux-update
cd /usr/lpp/mmfs/4.1.1.6
rm -f /usr/lpp/mmfs/4.1.1.6/*.deb
rm -f /usr/lpp/mmfs/4.1.1.6/gpfs.hadoop-connector-2.7.0-6.x86_64.rpm
cd /usr/lpp/mmfs/4.1.1.6
rpm -Uvh *.rpm
cd /usr/lpp/mmfs/src
make Autoconfig
make World
make InstallImages

if [ -f /etc/profile.d/gpfs.sh ];
then
	echo "PATH=$PATH:/usr/lib64/qt-3.3/bin:/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/opt/ibutils/bin:/root/bin:/usr/lpp/mmfs/bin" > /etc/profile.d/gpfs.sh 
else
	echo "/etc/profile.d/gpfs.sh - Ok"
fi

if [ -f /root/.ssh/id_dsa.pub ];
then
	rsync -rvpougt igpfs-01:/root/.ssh/* /root/.ssh/
else
	echo ".ssh - Ok"
fi
mmstartup
sleep 30

ln -sv /gpfs/units/admin /adm
ln -sv /gpfs/units/admin /admin
ln -sv /gpfs/apps /apps
ln -sv /gpfs/units/bioinformatics /bio
ln -sv /gpfs/units/bioinformatics /bioinfo
ln -sv /gpfs/units/genomics /gen
ln -sv /gpfs/units/genomics /genom
ln -sv /gpfs/units/hts /hts
ln -sv /gpfs/units/it /it
ln -sv /gpfs/units/proteomics /pro
ln -sv /gpfs/units/proteomics /proto
ln -sv /gpfs/apps/repos/ /repos
ln -sv /gpfs/users /users
mv /usr/local /usr/local-bkp
ln -sv /gpfs/apps/el6_x86_64/ /usr/local
