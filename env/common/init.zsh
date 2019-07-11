# If not running interactively, don't do anything
[ -z "$PS1" ] && return


if [ -f /usr/local/bin/realpath ]; then
    REALPATH_PROGRAM=/usr/local/bin/realpath
else
    REALPATH_PROGRAM=realpath
fi

if [ -e /usr/local/bin/bash ]; then
    export SHELL=/usr/local/bin/bash
else
    export SHELL=/bin/bash
fi

export CONFIG_ROOT_DIR=$(dirname $(dirname $(dirname `$REALPATH_PROGRAM $HOME/.zsh.public.symlink`)))
export CONFIG_PRIVATE_ROOT_DIR=$(dirname $(dirname $(dirname `$REALPATH_PROGRAM $HOME/.zsh.private.symlink`)))

source ${CONFIG_ROOT_DIR}/env/common/pre.zsh
source-pre-zshes
source-other-zshes
source-post-zshes
