function _set-android-build-env-pre {
    if [ -e $HOME/work/aosp/kernel/goldfish/.build/sdcard.bash ]; then
        source $HOME/work/aosp/kernel/goldfish/.build/sdcard.bash
    fi
    export PATH=/bin:/usr/bin:$PATH
    alias ls='ls -G'
}

function __my-emulator {
    local possible_kernel=~/work/aosp/kernel/goldfish/out/arch/x86/boot/bzImage
    local possible_sdcard=~/work/aosp/data/SdCard4Emulator.img
    local fixed_flags="-writable-system -show-kernel"
    local timestamp=`bdate`
    local kmsg_log_dir=~/logs/goldfish/kmsg
    mkdir -p $kmsg_log_dir
    local conditional_args=""
    if [ -e $possible_kernel ]; then
        conditional_args+=" -kernel ${possible_kernel}"
    fi
    if [ -e $possible_sdcard ]; then
        conditional_args+=" -sdcard ${possible_sdcard}"
    fi
    if [ $# -ge 1 ]; then
        conditional_args+=" $@"
    fi
    ln -sf $kmsg_log_dir/kmsg-$timestamp.log $kmsg_log_dir/kmsg-goldfish-current.log
    local command="emulator $fixed_flags $conditional_args"
    echo [Run: $command]
    echo [Log: $kmsg_log_dir/kmsg-$timestamp.log]
    $command 2>&1 | tee $kmsg_log_dir/kmsg-$timestamp.log
}

function set-android-build-env {
    _set-android-build-env-pre
    cd ~/work/aosp/pie
    source build/envsetup.sh
    lunch aosp_x86-eng
    alias my-emulator='__my-emulator'
}

function goto-goldfish-dirs {
    # goldfish kernel root
    local gkr="$HOME/work/aosp/pie/kernel_goldfish"
    local menu=(
        "kernel-root: cd $gkr"
        "kernel-out: cd $gkr/out"
        "kernel-bzImage-dir: cd $gkr/out/arch/x86/boot"
    )
    run_item_in_menu "${menu[@]}"
}

