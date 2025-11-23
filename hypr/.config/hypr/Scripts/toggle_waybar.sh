#!/bin/bash

if pgrep -x "qs" > /dev/null; then
    killall qs 
else
    qs -c ~/.config/quickshell/newbar
fi
