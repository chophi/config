#!/bin/bash

CONFIG_ROOT_DIR=$(dirname `realpath ${BASH_SOURCE[0]}`)
bash_common_list=(
    "bash_system_env"
    "bash_aliases"
    "bash_path_utils"
    "bash_temp_functions"
    "bash_util_functions"
    "where"
)

function echo_and_run {
    echo $@
    $@
}

for name in ${bash_common_list[@]}; do
    echo_and_run rm "$HOME/.${name}"
done

rm -f $HOME/.bashrc
rm -f $HOME/.zsh
ln -sf ${CONFIG_ROOT_DIR}/bash/common/init.bash ${HOME}/.bashrc
