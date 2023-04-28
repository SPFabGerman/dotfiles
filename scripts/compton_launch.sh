#!/bin/sh

# A Wrapper for compton, that makes the shadow the same as value of xrdb color0.
# It can also disable comptons alpha.

killall compton

COLOR0=$(xrdb -query | grep "^\*color0:" | sed 's/^\*color0:\s*#//')

COLOR_R=${COLOR0:0:2}
COLOR_R=$(python3 -c "print(0x$COLOR_R / 0xff)")

COLOR_G=${COLOR0:2:2}
COLOR_G=$(python3 -c "print(0x$COLOR_G / 0xff)")

COLOR_B=${COLOR0:4:2}
COLOR_B=$(python3 -c "print(0x$COLOR_B / 0xff)")

compton --shadow-red $COLOR_R --shadow-green $COLOR_G --shadow-blue $COLOR_B &

