#!/bin/bash
. /etc/acpi/eeepc/eeepc-1015pem-acpi-functions

#If the cable is plugged
if [ "$(cat /proc/acpi/ac_adapter/AC0/state | awk '{print $2}')" = "on-line" ] ; then
    eeepc-power-manager.sh -p Performance
    echo -e "$logdate Boot to Performance profile" >> $logfile 
#If the cable is unplugged
else
    eeepc-power-manager.sh -p Powersave
    echo -e "$logdate Boot to Powersave profile" >> $logfile 
fi
