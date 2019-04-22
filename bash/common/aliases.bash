#!/bin/bash

alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

alias back='cd ..'
alias back2='cd ../..'
alias back3='cd ../../..'
alias back4='cd ../../../..'
alias back5='cd ../../../../..'
alias back6='cd ../../../../../..'

alias tree='tree --charset=ASCII'

if [ "$MY_HOST_SYSTEM" == "linux" ]; then
    alias open=nautilus
fi

alias new-emacs-frame='ef ~/.ef-file'

function cat-which {
    local file=`which $1`
    if [ -f "$file" ]; then
        cat $file
    else
        echo "Can't find file: $1"
    fi
}

export EDITOR=ec
alias E="SUDO_EDITOR=\"ec\" sudo -e"
alias reboot="echo Do you really want to reboot?"

alias bulletin_message='git commit --amend -m "`git log --format=%B -n 1`"'
function bulletin_push {
    local jira_id cve_number branch command answer
    echo -n "Input the JIRA ID: "
    read jira_id
    echo -n "Input the CVE Number: "
    read cve_number
    echo -n "Input the branch: (main/dev or main/nougat): "
    read branch
    command="git push fos HEAD:refs/for/fireos/$branch/${jira_id},aosp_security_bulletin,$cve_number,1/1,vendor=google"
    echo -e "Command is:\n$command\ny or n?"
    read answer
    if [ "$answer" == "y" ]; then
        bulletin_message
        $command
    fi
}

alias source-env='. ${CONFIG_ROOT_DIR}/env/source-env.bash'
