#!/usr/bin/env bash

while true; do

  battery=$(cat /sys/class/power_supply/BAT0/capacity)
  status=$(cat /sys/class/power_supply/BAT0/status)


  if [[ $status == "Charging" || $status == "Not charging" ]]; then
    powerprofilesctl set performance

  elif [[ $battery -gt 40 && $status == "Discharging" ]]; then
    powerprofilesctl set balanced
  else
    powerprofilesctl set power-saver
  fi

  sleep 5

done
