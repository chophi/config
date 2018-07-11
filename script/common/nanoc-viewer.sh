#!/bin/bash

function bin_exist_p {
    if [ "`which $1`" == "" ]; then
        return 1
    else
        return 0
    fi
}

if !(bin_exist_p fswatch); then
    echo "You should install fswatch first"
    exit 0;
fi

function do_clean_up {
    killall nanoc 2>/dev/null
    killall fswatch 2>/dev/null
}

public_dir=~/nanoc-site
private_dir=~/nanoc-site-private

if [ "$1" != "public" ] && [ "$1" != "private" ]; then
    # do_clean_up
    exit 0;
fi

if [ "$1" == "public" ]; then
    root_dir=$public_dir
    port=3000
else
    root_dir=$private_dir
    port=3001
fi

# do_clean_up

cd $root_dir
fifo_name=/tmp/`basename $root_dir`.fifo

mkfifo $fifo_name 2>/dev/null

fswatch . --exclude='tmp/.*' --exclude='output/.*' --exclude='.*#.*' --exclude='.git/.*'> $fifo_name &
nanoc view --port=$port &

while [ 1 ]; do
    < $fifo_name read -t 1 input_content
    if [ -n "$input_content" ]; then
        echo "Changes in below files:"
        echo "======================="
        while [ -n "$input_content" ]; do
            echo $input_content
            < $fifo_name read -t 1 input_content
        done
        echo "======================="
        echo "Nanoc updating ........"
        nanoc
    fi
    # sleep 3
done

