#!/usr/bin/env bash
#  ┳┓┏┓┏┓┳  ┏┓┳┳┓┏┓┏┳┳
#  ┣┫┃┃┣ ┃━━┣ ┃┃┃┃┃ ┃┃
#  ┛┗┗┛┻ ┻  ┗┛┛ ┗┗┛┗┛┻
#                     

dir="$HOME/.config/rofi/launchers/styles"
theme='style-10'


rofi \
    -modi emoji \
    -show emoji \
    -theme ${dir}/${theme}.rasi
