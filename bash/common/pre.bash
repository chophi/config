#!/bin/bash

# echo "Start sourcing `dirname ${BASH_SOURCE[0]}`/`basename ${BASH_SOURCE[0]}`"

export MY_HOST_SYSTEM=`uname -a | cut -d " " -f 1 | tr A-Z a-z`

# $1: append or to-head
# $2: the variable name
# $3 - rest: path list
function _add_to_variable {
    local var_1="$1"
    local var_2="$2"
    local tmp_var=`printenv $var_2`

    local IFS='
'
    shift 2
    path_list=("$@")

    local dir
    local add
    local first=1
    for dir in "${path_list[@]}"; do
        if [ -d $dir ]; then
            if [ $first -eq 1 ]; then
                add=$dir
                ((++first))
            else
                add=$add:$dir
            fi
        fi
    done
    if [ "$var_1" == "append" ]; then
        tmp_var=$tmp_var:$add
    else
        tmp_var=$add:$tmp_var
    fi
    export $var_2="$tmp_var"
}

alias head-to-variable='_add_to_variable to-head '
alias append-to-variable='_add_to_variable append '
alias head-to-path='head-to-variable PATH '
alias append-to-path='append-to-variable PATH '

function clean-variable {
    local new_path=""
    local IFS=":"
    if [ $# -ge 2 ]; then
        IFS="$2"
    fi
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
                new_path=${new_path}${IFS}${path}
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

declare -A CHECK_COMMAND_TIME_MATRIX

function check_time {
    local command="$@"
    local date_command="date +%s%3N"
    local time_lapsed_unit="ms"
    if [ "$MY_HOST_SYSTEM" == "darwin" ]; then
        local gnu_date=/usr/local/opt/coreutils/libexec/gnubin/date
        if [ -x $gnu_date ]; then
            date_command="$gnu_date +%s%3N"
            time_lapsed_unit="ms"
        else
            date_command="date +%s"
            time_lapsed_unit="seconds"
        fi
    fi
    local pre_time=`$date_command`
    eval $command
    local post_time=`$date_command`
    ((time_took=post_time-pre_time))
    CHECK_COMMAND_TIME_MATRIX[$command]="(${time_took}${time_lapsed_unit})"
}

function _source_bash_files {
    local bash_files=`_get_filtered_bash_list $1`
    for name in ${bash_files//:/ }; do
        check_time source $name
    done
}

function check-command-time-matrix {
    local width=0
    local tmp_width
    for com in "${!CHECK_COMMAND_TIME_MATRIX[@]}"; do
        tmp_width=${#com}
        ((tmp_width=tmp_width+5))
        if [ $width -lt $tmp_width ]; then
            width=$tmp_width
        fi
    done
    for com in "${!CHECK_COMMAND_TIME_MATRIX[@]}"; do
        printf "|%-${width}s| %-10s|\n" "$com" ${CHECK_COMMAND_TIME_MATRIX[$com]}
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
alias sync-bashrc='source ${CONFIG_ROOT_DIR}/bash/common/init.bash'

__bash_load_log=""
function append-to-log {
    __bash_load_log="${__bash_load_log}$@\n"
}
function dump-log {
    echo -e "$__bash_load_log"
}
