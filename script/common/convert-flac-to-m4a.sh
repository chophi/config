#!/bin/bash

IFS='
'
set -f
for file in $(find . -name "*.flac"); do
    ffmpeg -i "${file}" -acodec alac "${file/.flac/.m4a}"
done
