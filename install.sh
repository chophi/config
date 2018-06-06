#!/bin/bash

MY_HOST_SYSTEM=`uname -a | cut -d " " -f 1 | tr A-Z a-z`
CONFIG_ROOT_DIR=$(dirname `realpath ${BASH_SOURCE[0]}`)

echo -n "HOST is $MY_HOST_SYSTEM, (y/n)?: "
read answer

if [ "$answer" != "y" ]; then
    echo "Quit creating bashrc symbolic files!"
    exit 0
fi

rm -f $HOME/.bashrc
if [ "$MY_HOST_SYSTEM" == "linux" ] || [ "$MY_HOST_SYSTEM" == "darwin" ]; then
    ln -sf ${CONFIG_ROOT_DIR}/bash/${MY_HOST_SYSTEM}/init.bash ${HOME}/.bashrc
fi
    
