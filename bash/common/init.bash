# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

if [ "$BASH" == "/bin/bash" ] && `/bin/bash -version | grep 3.2 > /dev/null 2>&1` && [ -e /usr/local/bin/bash ] ; then
    exec /usr/local/bin/bash
fi

if [ -f /usr/local/bin/realpath ]; then
    REALPATH_PROGRAM=/usr/local/bin/realpath
else
    REALPATH_PROGRAM=realpath
fi
export CONFIG_ROOT_DIR=$(dirname $(dirname $(dirname `$REALPATH_PROGRAM ${BASH_SOURCE[0]}`)))

source ${CONFIG_ROOT_DIR}/bash/common/pre.bash
source-pre-bashes
source-other-bashes
source-post-bashes
