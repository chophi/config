#!/bin/bash

CONF=$HOME/.aria2/aria2.conf
if ! [ -e $CONF ]; then
    echo "$CONF doesn't exist, do nothing"
    exit 0
fi

SED=sed
if [ "$MY_HOST_SYSTEM" == "darwin" ]; then
    SED=gsed
fi

list=`wget -qO- https://raw.githubusercontent.com/ngosang/trackerslist/master/trackers_all.txt | awk NF | $SED ":a;N;s/\n/,/g;ta"`
if [ -z "`grep bt-tracker ${CONF}`" ]; then
    $SED -i '$a bt-tracker='$list ${CONF}
    echo "added list"
else
    $SED -i "s@bt-tracker.*@bt-tracker=$list@g" ${CONF}
    echo "list is updated"
fi
