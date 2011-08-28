#!/bin/bash
# Copyright 2011 Diego Ferigo
#
# eeepc-1015pem-acpi is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# acpi-eeepc-generic is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with acpi-eeepc-generic.  If not, see <http://www.gnu.org/licenses/>.

. /etc/conf.d/eeepc-1015pem-acpi.conf

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

SHE_TOGGLE=$KEY_Fn_Space
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
            PBTN|PWRF)  $ACTION_POWER_BUTTON ;;
        esac
        ;;
    button/sleep)
        case "$2" in
            SLPB)   $ACTION_SLEEP ;;
            *)      logger "ACPI action undefined: $2" ;;
        esac
        ;;
    ac_adapter)
        case "$2" in
            AC|ACAD|ADP0)
                case "$4" in
                    00000000) # Rimosso
                        $ACTION_AC_UNPLUG
                    ;;
                    00000001) # Attaccato
                        $ACTION_AC_PLUG
                    ;;
                esac
            ;;
            *)  logger "ACPI action undefined: $2" ;;
        esac
        ;;

    battery|processor) ;;

    button/lid)
	lidstate=""
        [ -e /proc/acpi/button/lid/LID/state ] && \
            lidstate=$(cat /proc/acpi/button/lid/LID/state | awk '{print $2}')

	case "$lidstate" in
          open)
		$ACTION_SCREEN_OPEN
	  ;;
	  closed)
		$ACTION_SCREEN_CLOSED
          ;;
	esac
    ;;

    hotkey)
	case $3 in
		SHE_TOGGLE) $ACTION_SHE_TOGGLE ;;
		SLEEP) $ACTION_SLEEP ;;
		WIFI_TOGGLE) $ACTION_WIFI_TOGGLE ;;
		TOUCHPAD_TOGGLE) $ACTION_TOUCHPAD_TOGGLE ;;
		ROTATE) $ACTION_ROTATE ;;
		BRIGHTNESS_UP) $ACTION_BRIGHTNESS_UP ;;
		BRIGHTNESS_DOWN) $ACTION_BRIGHTNESS_DOWN ;;
		SCREEN_OFF) $ACTION_SCREEN_CLOSED ;;
		RANDR_TOGGLE) $ACTION_RANDR_TOGGLE ;;
		TASK) $ACTION_TASK ;;
		VOL_MUTE) $ACTION_VOL_MUTE ;;
		VOL_DOWN) $ACTION_VOL_DOWN ;;
		VOL_UP) $ACTION_VOL_UP ;;
	esac
    ;;
    *)
        logger "ACPI group/action undefined: $1 / $2"
        ;;
esac
