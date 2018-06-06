#!/bin/bash

function path_push {
    length=${#RECORDED_PATH[@]}
    ((++length))
    RECORDED_PATH[length]=`pwd`
}

function path_list {
    end=${#RECORDED_PATH[@]}
    for i in `seq 1 $end`; do
        echo $i : ${RECORDED_PATH[$i]}
    done
}

function path_cd {
    path_list
    echo -n "input the index of path to cd: "
    read index
    if [ $index -ge 1 ] && [ $index -le ${#RECORDED_PATH[@]} ]; then
        cd "${RECORDED_PATH[$index]}"
    else
        echo "index out of range"
    fi
}

function path_del {
    path_list
    echo -n "input the index of path to cd: "
    read index
    if [ $index -ge 1 ] && [ $index -le ${#RECORDED_PATH[@]} ]; then
        unset RECORDED_PATH[$index]
    else
        echo "index out of range"
    fi
}
