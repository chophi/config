function adb {
    if [ -e $HOME/git-repo/config/private/bin/$MY_HOST_SYSTEM/adb ]; then
        CURRENT_ADB=$HOME/git-repo/config/private/bin/$MY_HOST_SYSTEM/adb
    else
        CURRENT_ADB=`which adb`
    fi
    $CURRENT_ADB $@
}

function adb-press-vol-up {
    adb shell input keyevent 24
}

function adb-press-vol-down {
    adb shell input keyevent 25
}

function adb-press-power {
    adb shell input keyevent 26
}
