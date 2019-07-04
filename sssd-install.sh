#!/bin/bash
yum -y install adcli

if grep -q "default.domain.incpm.weizmann.ac.il" /etc/resolv.conf
then
        echo -e "default Ok"
else
        echo -e "no default"
        sed -i 's/search incpm.weizmann.ac.il/search default.domain.incpm.weizmann.ac.il incpm.weizmann.ac.il/g' /etc/resolv.conf
        sed -i 's/search weizmann.ac.il/search default.domain.incpm.weizmann.ac.il weizmann.ac.il/g' /etc/resolv.conf

fi

adcli info incpm.weizmann.ac.il
adcli join incpm.weizmann.ac.il
klist -k

if  ! grep -q 'INCPM.WEIZMANN.AC.IL' /etc/krb5.conf 
then
	echo Not found.
	cp /etc/krb5.conf /etc/krb5.conf-`date +"%d-%b-%Y-%H-%M-%S"`
echo -e "[logging]
 default = FILE:/var/log/krb5libs.log
 kdc = FILE:/var/log/krb5kdc.log
 admin_server = FILE:/var/log/kadmind.log

[libdefaults]
 default_realm = INCPM.WEIZMANN.AC.IL
 dns_lookup_realm = true
 dns_lookup_kdc = true
 ticket_lifetime = 24h
 renew_lifetime = 7d
 rdns = false
 forwardable = true

[realms]
 INCPM.WEIZMANN.AC.IL = {
  kdc = idc01.incpm.weizmann.ac.il
  admin_server = idc01.incpm.weizmann.ac.il
 }

[domain_realm]
.incpm.weizmann.ac.il = INCPM.WEIZMANN.AC.IL
incpm.weizmann.ac.il = INCPM.WEIZMANN.AC.IL" > /etc/krb5.conf

fi



yum install authconfig sssd
if [ ! /root/pam.d ]
then
	echo "999999"
	rsync -rvpougt /etc/pam.d /root/
fi

yum install authconfig sssd
authconfig --enablesssd --enablesssdauth --update
authconfig --disablenis --update
authconfig --test
grep sss /etc/nsswitch.conf
echo "
[sssd]
services = nss, pam, ssh
config_file_version = 2
domains = INCPM.WEIZMANN.AC.IL
 
 
[domain/INCPM.WEIZMANN.AC.IL]
id_provider = ad
auth_provider = ad
access_provider = ad
chpass_provider = ad
schema_mode = sfu
range = low
ldap_id_mapping = False
ldap_schema = ad
default_shell = /bin/bash
fallback_homedir = /users/%u" > /etc/sssd/sssd.conf

chmod 600 /etc/sssd/sssd.conf
service sssd start
chkconfig sssd on
tail  /var/log/messages
chkconfig ypbind off
chkconfig autofs off
service ypbind stop
service autofs stop
id pmbenor
