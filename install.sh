#!/bin/bash

# Check if i have root access
if [ $(whoami) != "root" ] ; then
  echo -e ">>"
  echo -e ">> You must be root to use this script"
  echo -e ">>"
  exit 0
fi

# Is a supported model?
if [ "$(dmidecode -s system-product-name)" != "1015PEM" ] ; then
  echo -e ">>"
  echo -e ">> You have an unsupported model!"
  echo -e ">>"
  exit 1
fi

# Help function:
help() {
echo -e ""
echo -e "Usage: $0 [option]"
echo -e ""
echo -e "Options:"
echo -e "--uninstall   To remove all script in you file system"
echo -e ""
exit 0
}

# Parse stdin:
UNINSTALL="n"
if [ ! $1 = "" ] ; then
case $1 in
    --uninstall) UNINSTALL="y" ;;
    *) help ;;
  esac
fi


if [ ! "$UNINSTALL" = "y" ] ; then
# Conf file
  if [ -e /etc/conf.d/eeepc-1015pem-acpi.conf ] ; then
    install -m 755 -D eeepc-1015pem-acpi.conf /etc/conf.d/eeepc-1015pem-acpi.conf.new
    echo -e ">>"
    echo -e ">> New configuration file installed as eeepc-1015pem-acpi.conf.new"
    echo -e ">>"
  else
    install -m 755 -D eeepc-1015pem-acpi.conf \
		/etc/conf.d/eeepc-1015pem-acpi.conf \
		&& echo -e "Installed eeepc-1015pem-acpi.conf"
  fi

# Other files
  install -m 755 -D eeepc-1015pem-acpi-handler.sh \
		/etc/acpi/eeepc-1015pem-acpi-handler.sh  \
		&& echo -e "Installed eeepc-1015pem-acpi-handler.sh"
  install -m 755 -D eeepc-1015pem-acpi-functions \
		/etc/acpi/eeepc/eeepc-1015pem-acpi-functions \
		&& echo -e "Installed eeepc-1015pem-acpi-functions"
  install -m 755 -D eeepc-1015pem-acpi-events \
		/etc/acpi/events/eeepc-1015pem-acpi-events \
		&& echo -e "Installed eeepc-1015pem-acpi-events"
  install -m 755 -D eeepc-sys_proc_tweaks.sh \
		/etc/acpi/eeepc/eeepc-sys_proc_tweaks.sh \
		&& echo -e "Installed eeepc-sys_proc_tweaks.sh"
  install -m 755 -D eeepc-bootup.sh \
		/usr/bin/eeepc-bootup.sh \
		&& echo -e "Installed eeepc-bootup.sh"
  install -m 755 -D eeepc-power-manager.sh \
		/usr/bin/eeepc-power-manager.sh \
		&& echo -e "Installed eeepc-power-manager.sh"

# Uninstall the package:
else
  rm /etc/conf.d/eeepc-1015pem-acpi.conf && echo -e "Removed eeepc-1015pem-acpi.conf"
  rm /etc/acpi/eeepc-1015pem-acpi-handler.sh && echo -e "Removed eeepc-1015pem-acpi-handler.sh"
  rm /etc/acpi/eeepc/eeepc-1015pem-acpi-functions && echo -e "Removed eeepc-1015pem-acpi-functions"
  rm /etc/acpi/events/eeepc-1015pem-acpi-events && echo -e "Removed eeepc-1015pem-acpi-events"
  rm /etc/acpi/eeepc/switch_perf_powersave.sh && echo -e "Removed eeepc-sys_proc_tweaks.sh"
  rm /usr/bin/eeepc-bootup.sh && echo -e "Removed eeepc-bootup.sh"
  rm /usr/bin/eeepc-power-manager.sh && echo -e "Removed eeepc-power-manager.sh"
fi
