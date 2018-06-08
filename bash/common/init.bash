# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

export CONFIG_ROOT_DIR=$(dirname $(dirname $(dirname `realpath ${BASH_SOURCE[0]}`)))

source ${CONFIG_ROOT_DIR}/bash/common/pre.bash
source-pre-bashes
source-other-bashes
source-post-bashes
