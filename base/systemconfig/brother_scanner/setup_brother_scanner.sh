#!/bin/bash

# Change the following line according to the specific scanner and driver
doas brsaneconfig4 -a name=Brother_DCP-J562DW model=DCP-J562DW nodename=BRW2C6FC9187896

# Check if sane can find the scanner now
scanimage --list-devices

