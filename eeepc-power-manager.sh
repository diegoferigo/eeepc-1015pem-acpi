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

# Count of the number of the preset in config file
number=0
for preset in ${PRESET[*]} ; do
  number=$(($number+1))
done

help()
{
  echo -e "Use:"
  echo -e "$0 -c <cpu_governor> -s <she governor>"
  echo -e "$0 -p <preset>"
  echo -e ""
  echo -e "Existing presets:"
  # Dynamic creation of the presets name:
  i=0
  for i in `seq 1 $number` ; do
    echo -e "-> $i: $NAME_$i"
  done
  # The governor enabled into the kernel:
  echo -e "Existing cpu governor:"
  echo -e "-> performance"
  echo -e "-> ondemand"
  echo -e "-> conservative"
  echo -e "-> powersave"
  # SHE governor: eeepc_laptop module
  echo -e "Existing SHE governor"
  echo -e "-> performance"
  echo -e "-> normal"
  echo -e "-> powersave"
}

help

apply_CPU()
{
  for i in 0 1 2 3 ; do #TODO dinamyc creation of the core number
    echo "$1" > /sys/devices/system/cpu/cpu$i/cpufreq/scaling_governor
  done
}

apply_preset()
{
  # CPU governor:
  apply_CPU $CPU_GOV_$1
  # SHE governor:
  she_toggle $SHE_$1
  # Tweak some /sys and /proc entry
  if [ "$SYS_PROC_TWEAK_$1" = "yes"] ; then
    sh /usr/bin/eeepc-sys_proc_tweaks
  fi
}

for i in $@ ; do
  case $1 in
    -p)	shift
        # Check if the preset name exist and if so, load it
        j=0
        for name in ${PRESET[*]} ; do
          if [ $1 = "$name" ] ; then
            apply_preset $j
            echo -e "Preset $NAME_$j loaded!"
            exit 0
          fi
          $((j=$j+1))
        done
    ;;
    -c) shift
        for gov in performance ondemand conservative powersave ; do
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
