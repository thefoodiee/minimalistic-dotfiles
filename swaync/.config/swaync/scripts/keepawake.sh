#!/bin/bash

STATE_FILE="/tmp/keepawake"

        if [ -f "$STATE_FILE" ]; then
            echo true
        else
            echo false
        fi
