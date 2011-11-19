#!/bin/bash
# Script that allows to change: cpu governor, she, and proc and sys tweaks
# You can choose an existing preset or only cpu / she toggle.
# You can also simply write your own preset, it's simple :)  

# Preset -p:
#   powersave
#   normal
#   performance
#   turbo

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

# Parse the stdin
for i in $@ ; do
  case $1 in
    -p)	shift
        # Check if the preset name exist and if so, load it
        j=1
        for name in ${NAME[*]} ; do
          if [ "$1" == "$name" ] ; then
            apply_preset $j
            echo -e Preset `eval echo \${NAME[$j]}` loaded!
            exit 0
          fi
          let "j=$j+1"
        done
    ;;
    -c) shift
    	  # Dynamic check of the existing governors
        for gov in `cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_governors` ; do
	  	    if [ $1 = $gov ] ; then 
            apply_CPU $1
            echo -e "CPU governor: --> $1"
	  	    fi
        done
    ;;
    -s) shift
        she_toggle $1
    ;;
  esac
done
