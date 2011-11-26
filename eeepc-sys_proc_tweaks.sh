#!/bin/sh
# A script to enable laptop power saving features
# Credits to:
# http://crunchbanglinux.org/forums/topic/11954

# List of modules to unload, space seperated. Edit depending on your hardware and preferences.
modlist="uvcvideo"
# Bus list for runtime pm. Probably shouldn't touch this.
buslist="pci i2c"

case "$1" in
    powersave)
	# Enable laptop mode
	echo 5 > /proc/sys/vm/laptop_mode

	# Less VM disk activity. Suggested by powertop #1500
	echo 5000 > /proc/sys/vm/dirty_writeback_centisecs

	# Intel power saving
	echo Y > /sys/module/snd_hda_intel/parameters/power_save_controller 
	echo 1 > /sys/module/snd_hda_intel/parameters/power_save

	# USB powersaving
	for i in /sys/bus/usb/devices/*/power/autosuspend; do
	  echo 1 > $i 
	done

	# SATA power saving
	for i in `ls /sys/class/scsi_host/` ; do
	  echo min_power > /sys/class/scsi_host/$i/link_power_management_policy
	done

	# Disable hardware modules to save power
	for mod in $modlist; do
	  grep $mod /proc/modules >/dev/null || continue
	  modprobe -r $mod 2>/dev/null
	done

	# Enable runtime power management. Suggested by powertop.
	for bus in $buslist; do
	  for i in /sys/bus/$bus/devices/*/power/control; do
	    echo auto > $i
	  done
	done

	# Minimize the number of processor packages and CPU cores carrying the process load
	if [ -e /sys/devices/system/cpu/sched_smt_power_saving ] ; then
	  echo 1 > /sys/devices/system/cpu/sched_smt_power_saving
	fi

	# Disable NMI watchdog
	if [ -e /proc/sys/kernel/nmi_watchdog ] ; then
	  echo 0 > /proc/sys/kernel/nmi_watchdog
	fi
    ;;

    performance)
	#Return settings to default on AC power
	echo 0 > /proc/sys/vm/laptop_mode
	echo 60000 > /proc/sys/vm/dirty_writeback_centisecs
	echo N > /sys/module/snd_hda_intel/parameters/power_save_controller
	echo 0 > /sys/module/snd_hda_intel/parameters/power_save
	for i in /sys/bus/usb/devices/*/power/autosuspend; do
	  echo 2 > $i
	done
   for i in `ls /sys/class/scsi_host/` ; do
	  echo max_performance > /sys/class/scsi_host/$i/link_power_management_policy
	done
	for mod in $modlist; do
	  if ! lsmod | grep $mod; then
	    modprobe $mod 2>/dev/null
	  fi
	done
	for bus in $buslist; do
	  for i in /sys/bus/$bus/devices/*/power/control; do
	    echo on > $i
	  done
	done
	if [ -e /sys/devices/system/cpu/sched_smt_power_savings ] ; then
	  echo 0 > /sys/devices/system/cpu/sched_smt_power_savings
	fi
	if [ -e /proc/sys/kernel/nmi_watchdog ] ; then
	  echo 1 > /proc/sys/kernel/nmi_watchdog
	fi
    ;;
esac

exit 0
