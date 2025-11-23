#! /bin/bash

bar="▁▂▃▄▅▆▇█"
dict="s/;//g;"

# creating "dictionary" to replace char with bar
i=0
while [ $i -lt ${#bar} ]
do
    dict="${dict}s/$i/${bar:$i:1}/g;"
    i=$((i=i+1))
done

# write cava config
config_file="/tmp/polybar_cava_config"
echo "
[general]
bars = 10
sensitivity = 120
framerate = 60

[output]
method = raw
raw_target = /dev/stdout
data_format = ascii
ascii_max_range = 7
channels = mono

[eq]
1 = 1
2 = 1
3 = 1
4 = 1
5 = 1
" > $config_file

# echo "
# [general]
# mode = waves
# framerate = 60
# autosens = 1
# bars = 50

# [output]
# method = raw
# raw_target = /dev/stdout
# data_format = ascii
# channels = mono
# mono_option = average

# [smoothing]
# noise_reduction = 20
# " >$config_file

# read stdout from cava
cava -p $config_file | while read -r line; do
    echo $line | sed $dict
done