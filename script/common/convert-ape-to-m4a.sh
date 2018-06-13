#!/bin/bash

IFS='
'
set -f
for file in $(find . -name "*.ape"); do
    to_file="${file/.ape/.m4a}"
    if [ ! -f "$to_file" ]; then
        ffmpeg -i "${file}" -acodec alac "${to_file}"
    else
        echo ${to_file} already exists
    fi
    echo delete ape file: ${file}
    rm ${file}
done
