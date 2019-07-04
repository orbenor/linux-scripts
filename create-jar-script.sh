#!/bin/bash

## Has to have a stub.sh in the same directory as script.
## needs input the directory from where you want to create , has to have *.jar

if [ "$1" == "" ] ; then
	echo "Please enter a directory with .jar files"
	exit 3
fi

if [ ! -d "$1" ] ; then 
	echo "Not a directory: $1" 
	exit 4
fi

targetdir="$1"

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# checking to see if stub.sh is present

if [ ! -f "${DIR}/stub.sh" ] ; then
	echo "ERROR: stub file not present in $DIR"
	exit 5
fi


#echo $DIR
Link=`file ${targetdir}`
for files in `ls ${targetdir}/*.jar | sed 's/.jar$//'` ; do
cat << EOF > /usr/local/bin/${files}  && chmod +x  /usr/local/bin/${files}"
#!/bin/bash
# ${Link}
MYSELF=`which "$0" 2>/dev/null`
[ $? -gt 0 -a -f "$0" ] && MYSELF="./$0"
java="/usr/local/bin/java"
exec "$java" $java_args -jar $MYSELF "$@"
exit 1
EOF


#	echo -e "cat ${DIR}/stub.sh \
#		${files}.jar > /usr/local/bin/${files}	&& chmod +x  /usr/local/bin/${files}" 
done


### stub.sh


#!/bin/bash 
MYSELF=`which "$0" 2>/dev/null` 
[ $? -gt 0 -a -f "$0" ] && MYSELF="./$0" ;
echo $@
#java="/usr/local/bin/java" ;
#exec "$java" $java_args -jar $MYSELF "$@" ;
#exit 1  ;
