#!/usr/bin/expect
cd /it/Software/IT/Altair/PBS/PBSPro_11.3.2
spawn "./INSTALL"
set timeout 20
expect "Execution directory"
send -- "\r"
expect "Home director"
send -- "\r"
expect "(1|2|3)"
send -- "3\r"
expect "Hostnam"
send "10.0.10.1\r"
expect "is this correct?"
#sleep 3
send -- "yes"
send -- "\r"
expect "Installation of release"
#send -- "\r"





