#!/bin/bash
if grep -lq '/usr/local/share/MODULES' /usr/share/Modules/init/.modulespath ; then
        echo "yes"
  # do one thing
else
  # do another thing
        echo "no"
	sed -i '17 a /usr/local/share/MODULES        # modules for G-INCPM' /usr/share/Modules/init/.modulespath

fi


