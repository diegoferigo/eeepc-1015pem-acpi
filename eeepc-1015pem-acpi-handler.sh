#!/bin/bash
# Copyright 2011 Diego Ferigo
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
            PBTN|PWRF) echo -e "$logdate Button power pressed" >> $logfile 
							  $ACTION_POWER_BUTTON
	     ;;
        esac
    ;;

    button/sleep)
        case "$2" in
            SLPB) echo -e "$logdate Sleep power pressed" >> $logfile
						$ACTION_SLEEP   
	     ;;
            *)      echo -e "$logdate [WW] ACPI action undefined: $2" >> $logfile 
	     ;;
        esac
    ;;

    ac_adapter)
        case "$2" in
            AC|AC0|ACAD|ADP0)
                case "$4" in
                    00000000) echo -e "$logdate AC cable unplugged" >> $logfile
										echo -e "$logdate Switch to powersave settings" >> $logfile
                       			$ACTION_AC_UNPLUG
                       			$ADDITIONAL_AC_UNPLUG
                    ;;
                    00000001) echo -e "$logdate AC cable plugged" >> $logfile
                              echo -e "$logdate Switch to performance settings" >> $logfile
                        		$ACTION_AC_PLUG
										$ADDITIONAL_AC_PLUG
                    ;;
                esac
        ;;
        *)  echo -e "$logdate [WW] ACPI action undefined: $2" >> $logfile ;;
        esac
    ;;

    battery|processor) ;;

    button/lid) lidstate=""
        			 [ -e /proc/acpi/button/lid/LID/state ] && \
            	 lidstate=$(cat /proc/acpi/button/lid/LID/state | awk '{print $2}')

					 case "$lidstate" in
          		     open) echo -e "$logdate Screen opened" >> $logfile
								  $ACTION_SCREEN_OPEN
	  				     ;;
	  					  closed) echo -e "$logdate Screen closed" >> $logfile
									 $ACTION_SCREEN_CLOSED
          			  ;;
					 esac
    ;;

    hotkey)  case $3 in
				     $SHE_TOGGLE) echo -e "$logdate She button pressed" >> $logfile
										$ACTION_SHE_TOGGLE		     
					  ;;
					  $SLEEP) echo -e "$logdate Sleep button pressed" >> $logfile
								 $ACTION_SLEEP	
					  ;;
					  $WIFI_TOGGLE) echo -e "$logdate Wifi button pressed" >> $logfile
			      					 $ACTION_WIFI_TOGGLE	      
					  ;;
					  $TOUCHPAD_TOGGLE) echo -e "$logdate Touchpad button pressed" >> $logfile
				  							  $ACTION_TOUCHPAD_TOGGLE	  
					  ;;
					  $ROTATE) echo -e "$logdate Rotate button pressed" >> $logfile
			 					  $ACTION_ROTATE			 
					  ;;
					  $BRIGHTNESS_UP) $ACTION_BRIGHTNESS_UP
					  ;;
					  $BRIGHTNESS_DOWN) $ACTION_BRIGHTNESS_DOWN
					  ;;
					  $SCREEN_OFF) echo -e "$logdate Screen Off button pressed" >> $logfile
			     						$ACTION_SCREEN_CLOSED		
					  ;;
					  $RANDR_TOGGLE) echo -e "$logdate Randr Toggle button pressed" >> $logfile
			       					  $ACTION_RANDR_TOGGLE
					  ;;
					  $TASK) echo -e "$logdate Task button pressed" >> $logfile
		       				$ACTION_TASK
					  ;;
					  $VOL_MUTE) $ACTION_VOL_MUTE
					  ;;
					  $VOL_DOWN) $ACTION_VOL_DOWN
					  ;;
					  $VOL_UP) $ACTION_VOL_UP
					  ;;
		    esac
    ;;
    *) echo -e "$logdate [WW] ACPI group/action undefined: $1 / $2" >> $logfile
       ;;
esac
