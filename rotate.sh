#!/bin/sh

# screen and input device rotation for e.g. a Thinkpad X1 Yoga
# adopted from by the script from http://ubuntuforums.org/showthread.php?t=996830&p=6274392#post6274392
# adopted from https://gist.github.com/sarmbruster/a3a6f4f62ccdc074af7b4e349e6d9bf0
# Usage:
# ./rotate.sh
# will rotate both the screen and input device either to right or normal setting depending on previous state. Additionally:
# * in "right" layout, a on screen keyboard (onboard) is started or stopped in normal mode
# * the touchpad is switched off in "right" mode
#
# I've bound this script to a shortcut key for easily flipping back and forth settins

#stylus=`xsetwacom --list devices | grep " stylus" | cut -f 1`
#eraser=`xsetwacom --list devices | grep " eraser" | cut -f 1`
#touch=`xsetwacom --list devices | grep " touch" | cut -f 1`

# Find the line in "xrandr -q --verbose" output that contains current screen orientation and "strip" out current orientation.

rotation="$(xrandr -q --verbose | grep 'connected' | egrep -o  '\) (normal|left|inverted|right) \(' | egrep -o '(normal|left|inverted|right)')"

# Using current screen orientation proceed to rotate screen and input tools.

case "$rotation" in
    normal)
    # rotate to the right
    xrandr -o right
#    xsetwacom set "$stylus" rotate  none
#    xsetwacom set "$touch" rotate none
#    xsetwacom set "$eraser" rotate none
    xinput set-prop 13 "Device Enabled" 0   # touchpad off
    xinput set-prop 'Wacom Co.,Ltd. Pen and multitouch sensor Finger' 'Coordinate Transformation Matrix' 0 1 0 -1 0 1 0 0 1
    xinput set-prop 'Wacom Co.,Ltd. Pen and multitouch sensor Pen' 'Coordinate Transformation Matrix' 0 1 0 -1 0 1 0 0 1
    onboard &
    ;;
    right)
    # rotate to normal
    xrandr -o normal
#    xsetwacom set "$stylus" rotate none
#    xsetwacom set "$touch" rotate none
#    xsetwacom set "$eraser" rotate none
    xinput set-prop 13 "Device Enabled" 1 # touchpad on
    xinput set-prop 'Wacom Co.,Ltd. Pen and multitouch sensor Finger' 'Coordinate Transformation Matrix' 1 0 0 0 1 0 0 0 1
    xinput set-prop 'Wacom Co.,Ltd. Pen and multitouch sensor Pen' 'Coordinate Transformation Matrix' 1 0 0 0 1 0 0 0 1
    killall onboard
    ;; 
esac
