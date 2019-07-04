if grep -q "default.domain.incpm.weizmann.ac.il" /etc/resolv.conf
then
        echo -e "default Ok"
else
        echo -e "no default"
	sed -i 's/search incpm.weizmann.ac.il/search default.domain.incpm.weizmann.ac.il incpm.weizmann.ac.il/g' /etc/resolv.conf
	sed -i 's/search weizmann.ac.il/search default.domain.incpm.weizmann.ac.il weizmann.ac.il/g' /etc/resolv.conf

fi

