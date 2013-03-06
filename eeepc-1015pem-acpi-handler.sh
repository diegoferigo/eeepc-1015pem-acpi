#!/bin/bash
# Copyright 2013 Diego Ferigo
#
# eeepc-1015pem-acpi is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# eeepc-1015pem-acpi is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with eeepc-1015pem-acpi.  If not, see <http://www.gnu.org/licenses/>.

. /etc/conf.d/eeepc-1015pem-acpi.conf
. /etc/acpi/eeepc/eeepc-1015pem-acpi-functions

KEY_Fn_F1="00000080"    # Sleep
KEY_Fn_F2=("00000010" "00000011") # Wifi toggle
KEY_Fn_F3="00000037"    # Touchpad
KEY_Fn_F4="00000038"    # Resolution
KEY_Fn_F5="0000002*"    # Brightness down
KEY_Fn_F6="0000002*"    # Brightness up
KEY_Fn_F7="00000016"    # Cross Screen Icon (Blank)
KEY_Fn_F8="00000030"    # XRandR
KEY_Fn_F9="00000012"    # Task Manager
KEY_Fn_F10="00000013"   # Mute
KEY_Fn_F11="00000014"   # Volume Down
KEY_Fn_F12="00000015"   # Volume Up
KEY_Fn_Space="00000039" # Space Bar

PROFILE_TOGGLE=$KEY_Fn_Space
SLEEP=$KEY_Fn_F1
WIFI_TOGGLE=${KEY_Fn_F2[0]}
TOUCHPAD_TOGGLE=$KEY_Fn_F3
ROTATE=$KEY_Fn_F4
BRIGHTNESS_UP=$KEY_Fn_F5
BRIGHTNESS_DOWN=$KEY_Fn_F6
SCREEN_OFF=$KEY_Fn_F7
RANDR_TOGGLE=${KEY_Fn_F8[0]}
TASK=$KEY_Fn_F9
VOL_MUTE=$KEY_Fn_F10
VOL_DOWN=$KEY_Fn_F11
VOL_UP=$KEY_Fn_F12

#########################################
#########################################

case "$1" in
	button/power)
		case "$2" in
			PBTN|PWRF)
				sendlog "Button power pressed"
				execute $ACTION_POWER_BUTTON
			;;
		esac
	;;

	button/sleep)
		case "$2" in
  			SLPB|SBTN)
				sendlog "Sleep power pressed"
				execute $ACTION_SLEEP
			;;
			*)	sendlog "[WW] ACPI action undefined: $2" #TODO mi sa che non serve
			;;
		esac
	;;

	ac_adapter)
		case "$2" in
			# ACPI0003:00 called twice from acpid, why??
			AC|AC0|ACAD|ADP0|ACPI0003:00)
				case "$4" in
					00000000)
						sendlog "AC cable unplugged"
						sendlog "Switch to battery settings"
						eeepc-power-manager.sh -p $PRESET_AC_UNPLUG
						execute $ACTION_AC_UNPLUG
					;;
					00000001)
						sendlog "AC cable plugged"
						sendlog "Switch to AC power settings"
						eeepc-power-manager.sh -p $PRESET_AC_PLUG
						execute $ACTION_AC_PLUG
					;;
				esac
			;;
			*)	sendlog "[WW] ACPI action undefined: $2"
			;;
		esac
	;;

	# Added some event actually unused. Maybe a future switch
	# (can break the compatibility with old /proc acpi handling) is someone still using old kernel?
	battery|processor|video/switchmode|button/prog1|button/volumeup|button/volumedown|button/mute) ;;

	button/lid)
		lidstate=""
		[ -e /proc/acpi/button/lid/LID/state ] && \
			lidstate=$(cat /proc/acpi/button/lid/LID/state | awk '{print $2}')

		case "$lidstate" in
			open)
				sendlog "Screen opened"
				execute "$ACTION_SCREEN_OPEN"
			;;
	  		closed)
				sendlog "Screen closed"
				execute "$ACTION_SCREEN_CLOSED"
			;;
		esac
	;;
	
	# New event for screen off key button
	video/displayoff)
		if [ "$4" = "DOFF" ] ; then
			sendlog "Screen Off button pressed"
			execute "$ACTION_SCREEN_CLOSED"
		fi
	;;

	hotkey)
		case $3 in
			$PROFILE_TOGGLE)
				sendlog "Profile button pressed"
				execute "$ACTION_PROFILE_TOGGLE"   
			;;
			# Old way. Replaced by button/sleep
			$SLEEP)
				sendlog "Sleep button pressed"
				execute "$ACTION_SLEEP"
			$WIFI_TOGGLE)
				sendlog "Wifi button pressed"
				execute "$ACTION_WIFI_TOGGLE"      
			;;
			$TOUCHPAD_TOGGLE)
				sendlog "Touchpad button pressed"
				execute "$ACTION_TOUCHPAD_TOGGLE"	  
			;;
			$ROTATE)
				sendlog "Rotate button pressed"
				execute "$ACTION_ROTATE"		 
			;;
			$BRIGHTNESS_UP)
				execute "$ACTION_BRIGHTNESS_UP"
			;;
			$BRIGHTNESS_DOWN)
				execute "$ACTION_BRIGHTNESS_DOWN"
			;;
			# The screen off acpi event with new /sys migration is
			# handled by the video/displayoff event.
			# This section remains here for back compatibility
			$SCREEN_OFF)
				sendlog "Screen Off button pressed"
				execute "$ACTION_SCREEN_CLOSED"		
			;;
			$RANDR_TOGGLE)
				sendlog "Randr Toggle button pressed"
				execute "$ACTION_RANDR_TOGGLE"
			;;
			$TASK)
				sendlog "Task button pressed"
				execute "$ACTION_TASK"
			;;
			$VOL_MUTE)
				execute "$ACTION_VOL_MUTE"
			;;
			$VOL_DOWN)
				execute "$ACTION_VOL_DOWN"
			;;
			$VOL_UP)
				execute "$ACTION_VOL_UP"
			;;
			# New ac-plug/unplug event from /proc to /sys migration 
			ASUS010:00) 
			;;
		esac
	;;
	*)	sendlog "[WW] ACPI group/action undefined: $1 / $2"
	;;
esac