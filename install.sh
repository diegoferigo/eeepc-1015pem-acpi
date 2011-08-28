#!/bin/bash

if [ $(whoami) != "root" ] ; then
  echo -e ">>"
  echo -e ">> You must be root to use this script"
  echo -e ">>"
  exit 0
fi

help() {
echo -e ""
echo -e "Usage: $0 [option]"
echo -e ""
echo -e "Options:"
echo -e "--cpufreq	If you need a cpufreq conf"
echo -e "--uninstall	To remove all script in you file system"
echo -e ""
exit 0
}


UNINSTALL="n"
if [ ! $1 = "" ] ; then
  case $1 in
    --uninstall) UNINSTALL="y" ;;
    --cpufreq) CPUFREQ="y" ;;
    *) help ;;
  esac
fi

if [ ! $UNINSTALL = "y" ] ; then
  if [ -e /etc/conf.d/eeepc-1015pem-acpi.conf ] ; then
    install -m 755 -D eeepc-1015pem-acpi.conf /etc/conf.d/eeepc-1015pem-acpi.conf.new
    echo -e ">>"
    echo -e ">> New configuration file installed as eeepc-1015pem-acpi.conf.new"
    echo -e ">>"
  else
    install -m 755 -D eeepc-1015pem-acpi.conf /etc/conf.d/eeepc-1015pem-acpi.conf && echo -e "Installed eeepc-1015pem-acpi.conf"
  fi
  if [ $CPUFREQ = "y" ] ; then
    install -m 755 -D cpufreq /etc/conf.d/cpufreq && echo -e "Installed cpufreq conf file"
  fi
  install -m 755 -D eeepc-1015pem-acpi-handler.sh /etc/acpi/eeepc-1015pem-acpi-handler.sh && echo -e "Installed eeepc-1015pem-acpi-handler.sh"
  install -m 755 -D eeepc-1015pem-acpi-functions /etc/acpi/eeepc/eeepc-1015pem-acpi-functions && echo -e "Installed eeepc-1015pem-acpi-functions"
  install -m 755 -D eeepc-1015pem-acpi-events /etc/acpi/events/eeepc-1015pem-acpi-events && echo -e "Installed eeepc-1015pem-acpi-events"
  install -m 755 -D switch_perf_powersave.sh /etc/acpi/eeepc/switch_perf_powersave.sh && echo -e "Installed switch_perf_powersave.sh"
else
  rm /etc/conf.d/eeepc-1015pem-acpi.conf && echo -e "Removed eeepc-1015pem-acpi.conf"
  rm /etc/acpi/eeepc-1015pem-acpi-handler.sh && echo -e "Removed eeepc-1015pem-acpi-handler.sh"
  rm /etc/acpi/eeepc/eeepc-1015pem-acpi-functions && echo -e "Removed eeepc-1015pem-acpi-functions"
  rm /etc/acpi/events/eeepc-1015pem-acpi-events && echo -e "Removed eeepc-1015pem-acpi-events"
  rm /etc/acpi/eeepc/switch_perf_powersave.sh && echo -e "Removed switch_perf_powersave.sh"
fi
