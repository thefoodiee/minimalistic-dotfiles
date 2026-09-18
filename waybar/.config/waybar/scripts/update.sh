#!/usr/bin/env bash

if checkupdates | grep -q linux-cachyos; then
  echo "󰚰"
else
  echo ""
fi
