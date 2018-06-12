#!/bin/bash

counter=0
while [ -n "loop forever" ]; do
    echo "loop counter: $counter"
    ((++counter))
    sleep 3
done
