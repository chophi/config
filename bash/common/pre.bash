#!/bin/bash

echo "Start sourcing `dirname ${BASH_SOURCE[0]}`/`basename ${BASH_SOURCE[0]}`"

export MY_HOST_SYSTEM=`uname -a | cut -d " " -f 1 | tr A-Z a-z`

function _add_to_variable {
    local path_list=${3//\~/$HOME}
    local tmp_var=`printenv $2`
    local path
    for path in ${path_list//:/ }; do
        if [ -d $path ]; then
            if [ "$1" == "append" ]; then
                tmp_var=$tmp_var:$path
            else
                tmp_var=$path:$tmp_var
            fi
        fi
    done
    export $2=$tmp_var
}

alias head-to-variable='_add_to_variable to-head '
alias append-to-variable='_add_to_variable append '
alias head-to-path='head-to-variable PATH '
alias append-to-path='head-to-variable PATH '

function clean-variable {
    local new_path=""
    local IFS=":"
    for path in `printenv $1`; do
        local new=1
        for p in ${new_path}; do
            if [ "$p" == "$path" ]; then
                new=0
                break
            fi
        done
        if [ $new -eq 1 ]; then
            if [ "$new_path" == "" ]; then
                new_path=$path
            else
                new_path=$new_path:$path
            fi
        fi
    done
    export $1="$new_path"
}

# 0: get all pre.bash except the ${CONFIG_ROOT_DIR}/bash/common/pre.bash
# 1: get all *.bash except pre.bash and post.bash
# 2: get all post.bash
function _get_filtered_bash_list {
    local search_dirs=(
        "${CONFIG_ROOT_DIR}/bash/common"
        "${CONFIG_ROOT_DIR}/bash/${MY_HOST_SYSTEM}"
        "${CONFIG_ROOT_DIR}/private/bash/common"
        "${CONFIG_ROOT_DIR}/private/bash/${MY_HOST_SYSTEM}"
    )
    local flist=""
    if [ $1 -eq 0 ]; then
        for dir in ${search_dirs[@]:1}; do
            if [ -f "$dir/pre.bash" ]; then
                flist=$flist:$dir/pre.bash
            fi
        done
    elif [ $1 -eq 2 ]; then
        for dir in ${search_dirs[@]}; do
            if [ -f "$dir/post.bash" ]; then
                flist=$flist:$dir/post.bash
            fi
        done
    elif [ $1 -eq 1 ]; then
        local filter_out_file=(
            "pre.bash"
            "post.bash"
            "init.bash"
        )
        for dir in ${search_dirs[@]}; do
            for name in `ls $dir/*.bash 2>/dev/null` ; do
                local base=`basename $name`
                local in_black_list=0
                for f in ${filter_out_file[@]}; do
                    if [ "${base}" == "$f" ]; then
                        in_black_list=1
                    fi
                done
                if [ $in_black_list -ne 1 ]; then
                    flist=$flist:$name
                fi
            done
        done
    fi
    echo $flist
}

function _source_bash_files {
    local bash_files=`_get_filtered_bash_list $1`
    for name in ${bash_files//:/ }; do
        echo "Source $name"
        source $name
    done
}

function source-if-exist {
    if [ -f "$1" ]; then
        source "$1"
    fi
}

alias source-pre-bashes='_source_bash_files 0'
alias source-other-bashes='_source_bash_files 1'
alias source-post-bashes='_source_bash_files 2'
alias sync-bashrc='source ${CONFIG_ROOT_DIR}/bash/${MY_HOST_SYSTEM}/init.bash'
