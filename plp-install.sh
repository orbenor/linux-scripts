#!/bin/bash
sed -i s/SELINUX=enforcing/SELINUX=disabled/g /etc/selinux/config
setenforce 0
/etc/init.d/iptables stop
/etc/init.d/ip6tables stop
chkconfig iptables off
chkconfig ip6tables off
echo -e "\n# Disabling IPv6 # LEON \nnet.ipv6.conf.all.disable_ipv6 = 1" >> /etc/sysctl.conf
echo -e "# Disabling IPv6 # LEON\nNETWORKING_IPV6=no" >> /etc/sysconfig/network

#rpmlist

#for I in /etc/sysconfig/network-scripts/ifcfg-eth* ; do echo "IPV6INIT=no" >> $I ; done
chkconfig NetworkManager off
service NetworkManager stop

ip=`ifconfig | grep 132.76.| awk -F. '{print $4}'| awk '{print $1}'`
echo $ip

touch /etc/sysconfig/network-scripts/ifcfg-eth1

## declare an array variable
declare -a arr=("DEVICE=eth1" "TYPE=Ethernet" "ONBOOT=yes" "NM_CONTROLLED=no" "BOOTPROTO=none" "IPADDR=192.168.113.$ip" "PREFIX=16" "IPV4_FAILURE_FATAL=yes" "IPV6INIT=no" "MTU=9000" "NAME=\"System eth1\"")

## now loop through the above array
for i in "${arr[@]}"
do
	grep -q "$i" /etc/sysconfig/network-scripts/ifcfg-eth1 || echo "$i" >> /etc/sysconfig/network-scripts/ifcfg-eth1
	echo "$i"
   # or do whatever with individual element of the array
done
ifup eth1

touch /etc/sysconfig/network-scripts/ifcfg-eth2

## declare an array variable
declare -a arr=("DEVICE=eth2" "TYPE=Ethernet" "ONBOOT=yes" "NM_CONTROLLED=no" "BOOTPROTO=none" "IPADDR=10.0.113.$ip" "PREFIX=16" "IPV4_FAILURE_FATAL=yes" "IPV6INIT=no" "MTU=9000" "NAME=\"System eth2\"")

## now loop through the above array
for i in "${arr[@]}"
do
	grep -q "$i" /etc/sysconfig/network-scripts/ifcfg-eth2 || echo "$i" >> /etc/sysconfig/network-scripts/ifcfg-eth2
	echo "$i"
   # or do whatever with individual element of the array
done
ifup eth2
#/etc/init.d/network restart

mkdir /repos

grep -q istor01:/export/local/el6_x86_64 /etc/fstab || echo "istor01:/export/local/el6_x86_64 /usr/local      nfs ro" >> /etc/fstab
grep -q istor01:/export/local/repos  /etc/fstab || echo "istor01:/export/local/repos /repos nfs ro" >> /etc/fstab
mount -a
mount
sed -i s/"# Defaultvers=4"/Defaultvers=3/g /etc/nfsmount.conf
sed -i s/"# noatime=True"/noatime=True/g /etc/nfsmount.conf
grep "Defaultvers=4" /etc/fstab
grep "noatime=True" /etc/fstab

release=`cat /etc/redhat-release | awk '{print $7}'`
rsync -avP /repos/yum.d/RHEL-$release/ /etc/yum.repos.d/
yum repolist
cat /etc/redhat-release
#!/bin/bash
declare -a arr=("
cyrus-sasl-lib.i686
db4.i686
e2fsprogs-libs.i686
expat.i686
fontconfig.i686
freetype.i686
gamin.i686
glib2.i686
libdbi.i686
libdrm.i686
libICE.i686
libselinux.i686
libSM.i686
libstdc++.i686
libuuid.i686
libX11.i686
libXau.i686
libxcb.i686
libXcursor.i686
libXdamage.i686
libXdmcp.i686
libXext.i686
libXfixes.i686
libXi.i686
libXinerama.i686
libXinerama.i686
libXp.i686
libXp.i686
libXpm.i686
libXrandr.i686
libXrender.i686
libXt.i686
libXtst.i686
libXxf86vm.i686
mesa-dri-drivers.i686
mesa-libGL.i686
mesa-libGLU.i686
nspr.i686
pam.i686
zlib.i686
cyrus-sasl-lib.x86_64
db4.x86_64
e2fsprogs-libs.x86_64
expat.x86_64
fontconfig.x86_64
freetype.x86_64
gamin.x86_64
glib2.x86_64
libdbi.x86_64
libdrm.x86_64
libICE.x86_64
libselinux.x86_64
libSM.x86_64
libstdc++.x86_64
libuuid.x86_64
libX11.x86_64
libXau.x86_64
libxcb.x86_64
libXcursor.x86_64
libXdamage.x86_64
libXdmcp.x86_64
libXext.x86_64
libXfixes.x86_64
libXi.x86_64
libXinerama.x86_64
libXinerama.x86_64
libXp.x86_64
libXp.x86_64
libXpm.x86_64
libXrandr.x86_64
libXrender.x86_64
libXt.x86_64
libXtst.x86_64
libXxf86vm.x86_64
mesa-dri-drivers.x86_64
mesa-libGL.x86_64
mesa-libGLU.x86_64
nspr.x86_64
pam.x86_64
zlib.x86_64")

## now loop through the above array
for i in "${arr[@]}"
do
yum -y install $i
   # or do whatever with individual element of the array
done
yum -y install gcc-c++ gcc-objc gcc-objc++ compat-gcc-34-c++ gcc-x86_64-linux-gnu libgcj libgcj-devel
rpm -ivh /repos/optional/x86_64/os/Packages/xorg-x11-server-Xvfb-1.13.0-11.el6.x86_64.rpm


incpmsh=`cat <<EOF
##
## Aliases inserted by Leon.;
##

# Control grep command output
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

# Start calculator with math support
alias bc='bc -l'

# Create parent directories on demand
alias mkdir='mkdir -pv'

# confirmation #
alias mv='mv -i'
alias cp='cp -i'
alias ln='ln -i'

#
# ----------------------------------------------
#       Exports...
#
export LFS=/usr/local/src
export LC_ALL=POSIX
export LFS_TGT=$(uname -m)-lfs-linux-gnu
export PBS_EXEC="/opt/pbs/default"

#
export JAVA_HOME="/usr/java/latest"
#export NGSPLOT="/usr/local/src/ngsplot/latest"
#export PATH="/usr/local/bin:${JAVA_HOME}/bin:${NGSPLOT}/bin:${PATH}:${PBS_HOME}"
export PATH="/usr/local/bin:${JAVA_HOME}/bin:${PATH}:${PBS_EXEC}/bin"
export PHYLOCSF_BASE="/usr/local/src/PhyloCSF/PhyloCSF"
#export LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:/usr/lib:/usr/lib64:/usr/local/lib:/usr/local/lib64"
export LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:/usr/local/lib:/usr/local/lib64:/usr/lib:/usr/lib64"


##

export TZ='Asia/Jerusalem'
export PBS_TZID='Asia/Jerusalem'
EOF
`
echo "${incpmsh}" > /etc/profile.d/incpm.sh

declare -a arr=(
"*             -   memlock        unlimited"
"*          soft   memlock        unlimited"
"*          hard   memlock        unlimited"
"*          soft    nofile          4096"
"*          hard    nofile          16384"
"*          soft    nproc           4096"
"*          hard    nproc           16384"
)

## now loop through the above array
for i in "${arr[@]}"
do
        grep -q "$i" /etc/security/limits.conf || echo "$i" >> /etc/security/limits.conf
        echo "$i"
   # or do whatever with individual element of the array
done
sed -i s/"# End of file"//g /etc/security/limits.conf
echo "# End of file" >> /etc/security/limits.conf

yum -y install open-vm-tools.x86_64

grep -q "domain INCPM server 132.76.113.104" /etc/yp.conf || echo "domain INCPM server 132.76.113.104" >> /etc/yp.conf


java -version


declare -a arr=(
"/net    -hosts"
"/users   /etc/auto.home"
"/-       /etc/auto.direct"
"+auto.master"
)

## now loop through the above array
for i in "${arr[@]}"
do
        grep -q "$i"  /etc/auto.master || echo "$i" >> /etc/auto.master
        echo "$i"
   # or do whatever with individual element of the array
done

declare -a arr=(
"/users +auto.home"
"+auto.home"
)

## now loop through the above array
for i in "${arr[@]}"
do
        grep -q "$i"  /etc/auto.home || echo "$i" >> /etc/auto.home
        echo "$i"
   # or do whatever with individual element of the array
done

grep -q "+auto.direct"  /etc/auto.direct || echo "+auto.direct" >> /etc/auto.direct



sed -i s/"passwd:     files$"/"passwd:     files nis"/g /etc/nsswitch.conf
sed -i s/"shadow:     files$"/"shadow:     files nis"/g /etc/nsswitch.conf
sed -i s/"group:     files$"/"group:     files nis"/g /etc/nsswitch.conf
sed -i s/"hosts:      files dns"/"hosts:      files nis dns"/g /etc/nsswitch.conf
sed -i s/"automount:  files nisplus$"/"automount:  files nis"/g /etc/nsswitch.conf


grep -q "server 132.76.113.2 iburst" /etc/ntp.conf || echo "server 132.76.113.2 iburst" >> /etc/ntp.conf
grep -q "server 132.76.113.6 iburst" /etc/ntp.conf || echo "server 132.76.113.6 iburst" >> /etc/ntp.conf

chkconfig ntpd on
service ntpd restart
ntpq -p

/etc/init.d/autofs restart
chkconfig autofs on
chkconfig ypbind on
/etc/init.d/ypbind restart
ypwhich

useradd plp91

rsync -avP  ~plpilot/AEP91_Linux64 /tmp/
