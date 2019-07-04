##
## Aliases inserted by Leon.
##
#set -x 
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

umask 0002
#
# ----------------------------------------------
# 	Exports...
#
export LFS=/usr/local/src
export LC_ALL=POSIX
export LFS_TGT=$(uname -m)-lfs-linux-gnu
export TZ='Asia/Jerusalem'
#
[ -h "/usr/local/src/SysTools/Java/java-1.7-latest" ] && export JAVA_HOME="/usr/local/src/SysTools/Java/java-1.7-latest" || export JAVA_HOME="/usr/java/latest"
[ -h "/usr/local/src/BioApps/ngsPlot/ngsplot-latest" ] && export NGSPLOT="/usr/local/src/BioApps/ngsPlot/ngsplot-latest"
#export PATH="/usr/local/bin:${JAVA_HOME}/bin:${NGSPLOT}/bin:${PATH}"
export PATH="/usr/local/bin:${JAVA_HOME}/bin:${PATH}"
export PHYLOCSF_BASE="/usr/local/src/PhyloCSF/PhyloCSF"
export LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:/usr/lib:/usr/lib64:/usr/local/lib:/usr/local/lib64"

# SSH config add
file="$HOME/.ssh/config"
if [ "$USER" != "root" ]  && [ "$USER" != "postgres" ]
        then
                g=`groups | tr ' ' '\n' | grep -i "incpm$"`
                if [ "$g" = "incpm" ]
                        then
                        if [ -f "$file" ]
                                then
				:
                        else
                              #  echo "$file not found."
                                printf "Host *\n   StrictHostKeyChecking no\n   UserKnownHostsFile=/dev/null\n   LogLevel error\n" >> $file
		                chmod 644 $file
                        fi
		else
			if [ -f "$file" ]
				then
				:
			else
				echo "The user is not in incpm group - please config ssh manualy"
				echo "Add the follwing lines to ~./ssh/config file."
				echo "----------------------------------------------------------"
				echo "Host *"
				echo "StrictHostKeyChecking no"
				echo "UserKnownHostsFile=/dev/null"
				echo "LogLevel error"
				echo "-------------------------------------------------------EOF"
				echo "Now run the follwing command:"
				echo "# chmod 644 ~/.ssh/config"
			fi
                fi

fi
#
