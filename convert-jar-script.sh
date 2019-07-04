#!/bin/bash

cd /usr/local/bin


for I in `ls *.jar`; do
	name=`echo $I| sed 's/.jar//'`
#	if [ ! -f /usr/local/bin/$name ] && [ -L /usr/local/bin/$I ] ; then
	if [  -f /usr/local/bin/$name ] && [ -L /usr/local/bin/$I ] ; then
		RealFile=`ls -l /usr/local/bin/$I | awk '{print $11}'`
		RealDir=`dirname ${RealFile}`
		#echo "File nameis:$I, new:$name -- realfile=${RealFile}, realdirectory=${RealDir}"
		echo "$name"
		echo '#!/bin/bash' > /usr/local/bin/${name}
		echo -e "args=\`echo \$@\`\n\totherargs=\" \"\n\tjavaargs=\" \"\n\tfor I in \$@ ; do"  >> /usr/local/bin/${name}
		echo -e "\tIfJavaArg=\`echo \$I | grep \^-X > /dev/null ; echo \$?\`\n\t\tif [ \"\${IfJavaArg}\" == \"0\" ] ; then\n\t\tjavaargs=\"\${javaargs} \$I\" " >> /usr/local/bin/${name}
		echo -e "\telse\n\t\totherargs=\"\${otherargs} \$I\"\n\tfi\ndone" >> /usr/local/bin/${name}
		echo -e "\n\texec /usr/local/bin/java \${javaargs} -jar ${RealDir}/${name}.jar \$otherargs" >> /usr/local/bin/${name}
		chmod +x  /usr/local/bin/${name}
	echo 
	fi
done

#cat << EOF > /usr/local/bin/${name}  && chmod +x  /usr/local/bin/${name}
#EOF
