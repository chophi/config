#!/bin/bash

function usage {
    echo "`basename $0` <dir> 0 [doit]: move all files under <dir>"
    echo "`basename $0` <dir> 1 [doit]: <dir> can have a subfolder, and move all files under subfolder to subfolder"
}

if [ $# -lt 2 ]; then
    usage
    exit 1
fi

dir=$1
level=$2
doit=$3

if [ "$level" != "0" ] && [ "$level" != "1" ]; then
    usage
    exit 1
fi

function uniq_name {
    local fullname="$1"
    local dir=$(dirname "$fullname")
    local filename=$(basename "$fullname")
    local extension="${filename##*.}"
    local base_name="${filename%.*}"
    if [ "$extension" == "$filename" ]; then
        echo "${dir}/x_${filename}"
    else
        echo "${dir}/x_${base_name}.${extension}"
    fi
}

function move_file_to_dir {
    if [ "$doit" == "doit" ]; then
        local bsname=$(basename "$1")
        if [ -e "$2/$bsname" ]; then
            local uniqname=$(uniq_name "$2/$bsname")
            mv "$1" "$uniqname"
        else
            mv "$1" "$2"
        fi
    else
        echo mv \"$1\" \"$2\"
    fi
}

function remove_dir {
    if [ "$doit" == "doit" ]; then
        rmdir "$1"
    else
        echo rmdir \"$1\"
    fi
}

if [ "$level" == "0" ]; then
    while read -r file; do
        if [ -n "$file" ] && [ -e "$file" ]; then
            move_file_to_dir "$file" "$dir"
        fi
    done <<< "$(find $dir -type f -depth +1)"

    while read -r subdir; do
        if [ -n "$subdir" ] && [ -e "$subdir" ]; then
            remove_dir "$subdir"
        fi
    done <<< "$(find $dir -type d -depth 1)"
else
    echo "currently only support level 0"
    exit 1
fi
