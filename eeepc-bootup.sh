#!/bin/bash
. /etc/acpi/eeepc/eeepc-1015pem-acpi-functions

# Check if i have root access
if [ $(whoami) != "root" ] ; then
	echo -e ">>"
	echo -e ">> You must be root to use this script"
	echo -e ">>"
	exit 0
fi

#If the cable is plugged
if [ "$(cat /proc/acpi/ac_adapter/AC0/state | awk '{print $2}')" = "on-line" ] ; then
	eeepc-power-manager.sh -p $PRESET_AC_PLUG
	sendlog "Boot with $PRESET_AC_PLUG profile"
#If the cable is unplugged
else
	eeepc-power-manager.sh -p $PRESET_AC_UNPLUG
	sendlog "Boot with $PRESET_AC_UNPLUG profile"
fi
