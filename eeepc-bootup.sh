#!/bin/bash
. /etc/acpi/eeepc/eeepc-1015pem-acpi-functions

#If the cable is plugged
if [ "$(cat /proc/acpi/ac_adapter/AC0/state | awk '{print $2}')" = "on-line" ] ; then
    sh /etc/acpi/eeepc-1015pem-acpi-handler.sh ac_adapter AC0 00000001
    echo -e $logdate "Boot:" >> $logfile 
#If the cable is unplugged
else
    sh /etc/acpi/eeepc-1015pem-acpi-handler.sh ac_adapter AC0 00000000
    echo -e "$logdate Boot:" >> $logfile 
fi
