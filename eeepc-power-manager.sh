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
for preset in ${NAME[*]} ; do
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
  for i in `seq 1 $number` ; do
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
help
apply_CPU()
{
  for i in $(seq 0 $((`cat /proc/cpuinfo | grep processor | wc -l`-1))) ; do
    echo "$1" > /sys/devices/system/cpu/cpu$i/cpufreq/scaling_governor
  done
}

apply_preset()
{
  # CPU governor:
  apply_CPU `eval echo \${CPU_GOV[$1]}`
  # SHE governor:
  she_toggle `eval echo \${SHE[$1]}`
  # Tweak some /sys and /proc entry
  if [ `eval echo \${SYS_PROC_TWEAK[$1]}` == "yes" ] ; then
    sh /usr/bin/eeepc-sys_proc_tweaks
  fi
}

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
