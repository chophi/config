#!/bin/bash

CONF=$HOME/.aria2/aria2.conf
if ! [ -e $CONF ]; then
    echo "$CONF doesn't exist, do nothing"
    exit 1
fi

if ! ps axww | grep aria2c | grep aria2.conf 2>&1 > /dev/null; then
    echo "Start aria2c daemon"
    aria2c --conf-path=${HOME}/.aria2/aria2.conf -D
else
    echo "aria2c daemon already started"
    exit 0
fi
