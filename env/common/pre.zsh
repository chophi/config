#!/bin/zsh

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
    if [[ "$var_1" == "append" ]]; then
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

function _clean_variable_no_awk {
    local new_path=""
    local IFS=":"
    if [ $# -ge 2 ]; then
        IFS="$2"
    fi
    for path in `printenv $1`; do
        local new=1
        for p in ${new_path}; do
            p=${p/%\//}         # remove the trailing /
            if [[ "$p" == "$path" ]]; then
                new=0
                break
            fi
        done
        if [ $new -eq 1 ]; then
            if [[ "$new_path" == "" ]]; then
                new_path=$path
            else
                new_path=${new_path}${IFS}${path}
            fi
        fi
    done
    export $1="$new_path"
}

function _clean_variable_with_awk {
    local field_separator=":"
    if [ $# -ge 2 ]; then
        field_separator="$2"
    fi
    local new_value=`awk -v FS="$field_separator" -v OFS="$field_separator" '
    {
        delete seen
        sep=""
        for (i=1; i<=NF; i++) {
            sub(/\/$/, "", $i)
            if (!seen[$i]++) {
                printf "%s%s", sep, $i
            }
            sep=OFS
        }
        print ""
    }' <<< "$(printenv $1)"`
    export $1="$new_value"
}

function clean-variable {
    if [[ "`printenv $1`" == "" ]]; then
        return 0;
    fi
    if [ -e /usr/bin/awk ]; then
        _clean_variable_with_awk "$@"
    else
        _clean_variable_no_awk "$@"
    fi
}
# 0: get all pre.zsh except the ${CONFIG_ROOT_DIR}/zsh/common/pre.zsh
# 1: get all *.zsh except pre.zsh and post.zsh
# 2: get all post.zsh
function _get_filtered_zsh_list {
    local search_dirs=(
        "${CONFIG_ROOT_DIR}/env/common"
        "${CONFIG_ROOT_DIR}/env/${MY_HOST_SYSTEM}"
        "${CONFIG_PRIVATE_ROOT_DIR}/env/common"
        "${CONFIG_PRIVATE_ROOT_DIR}/env/${MY_HOST_SYSTEM}"
    )
    local flist=""
    if [ $1 -eq 0 ]; then
        for dir in ${search_dirs[@]:1}; do
            if [ -f "$dir/pre.zsh" ]; then
                flist=$flist:$dir/pre.zsh
            fi
        done
    elif [ $1 -eq 2 ]; then
        for dir in ${search_dirs[@]}; do
            if [ -f "$dir/post.zsh" ]; then
                flist=$flist:$dir/post.zsh
            fi
        done
    elif [ $1 -eq 1 ]; then
        local filter_out_file=(
            "pre.zsh"
            "post.zsh"
            "init.zsh"
        )
        for dir in ${search_dirs[@]}; do
            for name in `ls $dir/*.zsh 2>/dev/null` ; do
                local base=`basename $name`
                local in_black_list=0
                for f in ${filter_out_file[@]}; do
                    if [[ "${base}" == "$f" ]]; then
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

typeset -A CHECK_COMMAND_TIME_MATRIX

function check_time {
    local command="$@"
    local date_command="date +%s%3N"
    local time_lapsed_unit="ms"
    if [[ "$MY_HOST_SYSTEM" == "darwin" ]]; then
        local gnu_date=/usr/local/opt/coreutils/libexec/gnubin/date
        if [ -x $gnu_date ]; then
            date_command="$gnu_date +%s%3N"
            time_lapsed_unit="ms"
        else
            date_command="date +%s"
            time_lapsed_unit="seconds"
        fi
    fi
    local pre_time=`eval $date_command`
    eval $command
    local post_time=`eval $date_command`
    ((time_took=post_time-pre_time))
    CHECK_COMMAND_TIME_MATRIX["$command"]="(${time_took}${time_lapsed_unit})"
}

function _source_zsh_files {
    local zsh_files=`_get_filtered_zsh_list $1`
    for name in ${(z)zsh_files//:/ }; do
        check_time source $name
    done
}

function check-command-time-matrix {
    local width=0
    local tmp_width
    for key val in ${(kv)CHECK_COMMAND_TIME_MATRIX}; do
        tmp_width=${#key}
        ((tmp_width=tmp_width+5))
        if [ $width -lt $tmp_width ]; then
            width=$tmp_width
        fi
    done
    for key val in ${(kv)CHECK_COMMAND_TIME_MATRIX}; do
        printf "|%-${width}s| %-10s|\n" "$key" "$val"
    done
}

function source-if-exist {
    if [ -f "$1" ]; then
        source "$1"
    fi
}

alias source-pre-zshes='_source_zsh_files 0'
alias source-other-zshes='_source_zsh_files 1'
alias source-post-zshes='_source_zsh_files 2'
alias sync-zshrc='source ${CONFIG_ROOT_DIR}/zsh/common/init.zsh'

__zsh_load_log=""
function append-to-log {
    __zsh_load_log="${__zsh_load_log}$@\n"
}
function dump-log {
    echo -e "$__zsh_load_log"
}