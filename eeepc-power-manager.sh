#!/bin/bash
# Script that allows to change: cpu governor, she, and proc and sys tweaks
# You can choose an existing preset or only cpu / she toggle.
# You can also simply write your own preset, it's simple :)  

# Preset -p:
#   Powersave
#   Normal
#   Performance
#   Turbo

# She:
#   powersave
#   normal
#   performance

# CPU:
#   powersave
#   conservative
#   ondemand
#   performance
. /etc/acpi/eeepc/eeepc-1015pem-acpi-functions
. /etc/conf.d/eeepc-1015pem-acpi.conf

# Check if i have root access
if [ $(whoami) != "root" ] ; then
	echo -e ">>"
	echo -e ">> You must be root to use this script"
	echo -e ">>"
	exit 0
fi

help()
{
	echo -e "Use:"
	echo -e "$0 -c <cpu_governor> -s <she governor>"
	echo -e "$0 -p <preset>"
	echo -e ""
	echo -e "Existing presets:"
	# Dynamic creation of the presets name:
	for i in `seq 1 $preset_num` ; do
		echo -e "-> `eval echo \${NAME[$i]}`"
	done
	# The governor enabled into the kernel:
	echo -e "Existing cpu governor:"
	for i in `cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_governors` ; do
		echo "-> $i"
	done
	# SHE governor: eeepc_laptop module
	echo -e "Existing SHE governor"
	echo -e "-> performance"
	echo -e "-> normal"
	echo -e "-> powersave"
}

if [ $# == 0 ] ; then
	help
fi

# Parse the stdin
for i in $@ ; do
	case $1 in
		-p)	shift
			#Check if the preset name exist and if so, load it
			apply_preset $1
			echo -e "Preset $1 loaded!"
			exit 0
		;;
		-c) shift
			# Dynamic check of the existing governors, TODO the _hpow / _lpow
			for gov in `cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_governors` ; do
				if [ $1 = $gov ] ; then
					apply_CPU $1
					echo -e "CPU governor: --> $1"
					exit 0
				fi
			done
		;;
		-s)	shift
			she_toggle $1
			echo -e "SHE governor --> $1"
			exit 0
		;;
		*) help ;;
	esac
done
